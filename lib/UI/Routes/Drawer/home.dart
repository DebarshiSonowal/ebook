// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:async';

import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:uni_links/uni_links.dart';
import '../../../Storage/app_storage.dart';
import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Networking/api_provider.dart';
import '../../Components/buildbook_section.dart';
import '../../Components/dynamic_books_section.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late StreamSubscription _sub;
  int selected = 0;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController controller = ScrollController();

  void _onRefresh() async {
    // monitor network fetch
    fetchHomeBanner();
    fetchHomeSection();
    // if failed,use refreshFailed()
  }

  Future<void> initUniLinks() async {
    debugPrint("deeplink start");
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      if (initialLink == null) {
        initUniLinksAlive();
      } else {
        debugPrint("deeplink $initialLink");
        final uri = Uri.parse(initialLink);
        if (uri.queryParameters['details'] == "reading") {
          if (uri.queryParameters['format'] == "e-book") {
            if (Storage.instance.isLoggedIn) {
              Storage.instance.setReadingBookPage(int.parse(uri.queryParameters['page'] ?? "0"));
              Navigation.instance.navigate('/bookDetails',
                  args: "${int.parse(uri.queryParameters['id'] ?? "0")},${uri.queryParameters['image'] ?? ""}");
            } else {
              await Navigation.instance.navigate('/loginReturn');
              initUniLinks();
            }
          } else {
            if (Storage.instance.isLoggedIn) {
              Storage.instance.setReadingBookPage(int.parse(uri.queryParameters['page'] ?? "0"));
              Navigation.instance.navigate('/bookDetails',
                  args:
                      "${int.parse(uri.queryParameters['id'] ?? "0")},${int.parse(uri.queryParameters['count'] ?? "0")}");
            } else {
              await Navigation.instance.navigate('/loginReturn');
              initUniLinks();
            }
          }
        } else {
          Navigation.instance.navigate('/bookInfo',
              args: int.parse(uri.queryParameters['id'] ?? "0"));
        }
      }
    } on PlatformException {
      debugPrint("deeplink1");
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  Future<void> initUniLinksAlive() async {
    // ... check initialLink

    // Attach a listener to the stream
    _sub = linkStream.listen((String? link) {
      debugPrint("deeplink start $link");
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      debugPrint("deeplink $err");
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      controller.addListener(() {
        if (controller.position.atEdge) {
          bool isTop = controller.position.pixels == 0;
          if (isTop) {
            _refreshController.requestRefresh();
          } else {
            // print('At the bottom');
          }
        }
      });
      initUniLinks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white30,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: const WaterDropHeader(
          waterDropColor: Colors.white,
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator(
                color: Colors.white,
              );
            } else if (mode == LoadStatus.failed) {
              body = const Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("release to load more");
            } else {
              body = const Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Container(
          margin: EdgeInsets.only(top: 0.1.h),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Colors.grey,
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                BuildBookBarSection(
                  show: (data) {
                    ConstanceData.show(context, data);
                  },
                ),
                const DynamicBooksSection(),
                SizedBox(
                  height: 35.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getTheList() {
    switch (selected) {
      case 0:
        return ConstanceData.Motivational;
      case 1:
        return ConstanceData.Novel;
      case 2:
        return ConstanceData.Love;
      default:
        return ConstanceData.Children;
    }
  }

  filterByCategory(List<Book> list, DataProvider data) {
    return list
        .where((element) =>
            element.book_category_id ==
            data.categoryList[data.currentTab][data.currentCategory].id)
        .toList();
  }

  getSelected(context, id) {
    return Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .bookmarks
            .where((element) => id == element.id)
            .isNotEmpty
        ? true
        : false;

    // for (var i in Provider.of<DataProvider>(
    //         Navigation.instance.navigatorKey.currentContext ?? context,
    //         listen: false)
    //     .bookmarks) {
    //   if (id == i.id) {
    //     return true;
    //   }
    // }
    // return false;
  }

  void fetchHomeBanner() async {
    for (var i in Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .formats!) {
      final response =
          await ApiProvider.instance.fetchHomeBanner(i.productFormat ?? '');
      if (response.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addBannerList(response.banners!);
      }
    }
  }

  void fetchHomeSection() async {
    for (var i in Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .formats!) {
      final response =
          await ApiProvider.instance.fetchHomeSections(i.productFormat ?? '');
      if (response.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addHomeSection(response.sections!);
      }
    }
    _refreshController.refreshCompleted();
  }
}
