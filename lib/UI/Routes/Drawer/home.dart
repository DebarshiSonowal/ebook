// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Storage/common_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

// import 'package:uni_links/uni_links.dart';
import '../../../Storage/app_storage.dart';
import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Networking/api_provider.dart';
import '../../Components/buildbook_section.dart';
import '../../Components/dynamic_books_section.dart';
import '../../Components/library_section.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  late StreamSubscription _sub;
  int selected = 0;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final ScrollController controller = ScrollController();
  // final bool isIos = ;
  void _onRefresh() async {
    // monitor network fetch

    fetchHomeBanner();
    fetchHomeSection();
    // if failed,use refreshFailed()
  }

  // Future<void> initUniLinks() async {
  //   debugPrint("deeplink start initial");
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // try {
  //   //   final initialLink = await getInitialLink();
  //   //   if (initialLink == null) {
  //   //     debugPrint("deeplink start $initialLink");
  //   //
  //   //     initUniLinksAlive();
  //   //   } else {
  //   //     debugPrint("deeplink $initialLink");
  //   //     await fetchBookDetails(initialLink);
  //   //     goToUrl(initialLink);
  //   //   }
  //   // } on PlatformException {
  //   //   debugPrint("deeplink1");
  //   //   // Handle exception by warning the user their action did not succeed
  //   //   // return?
  //   // }
  //   final appLinks = AppLinks(); // AppLinks is singleton
  //   final sub = appLinks.uriLinkStream.listen((uri) async {
  //     debugPrint("URI: $uri");
  //     if (uri == null) {
  //       initUniLinksAlive(uri);
  //     } else {
  //       await fetchBookDetails(uri.toString());
  //       goToUrl(uri.toString());
  //     }
  //   });
  // }

  Future<void> initUniLinks() async {
    print("deeplink start initial");
    final appLinks = AppLinks();

    // Handle initial/background links
    final uri = await appLinks.getInitialLink();
    if (uri == null) {
      print("No initial deeplink");
      initUniLinksAlive(appLinks);
    } else {
      print("Initial deeplink: $uri");
      await fetchBookDetails(uri.toString());
      goToUrl(uri.toString());
    }
  }

  Future<void> initUniLinksAlive(AppLinks appLinks) async {
    // Listen to app links while app is in foreground
    _sub = appLinks.uriLinkStream.listen((Uri? uri) async {
      print("Foreground deeplink: $uri");
      if (uri != null) {
        await fetchBookDetails(uri.toString());
        goToUrlSecond(uri.toString());
      }
    }, onError: (err) {
      print("Deeplink error: $err");
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint("didChangeAppLifecycleState $state}");
    if (state == AppLifecycleState.resumed) {
      _refreshController.requestRefresh();
    } else {
      _refreshController.requestRefresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
      fetchNotifications();
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
          child: Consumer<DataProvider>(builder: (context, data, _) {
            return SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  data.currentTab == 2
                      ? BuildEnoteBarSection(
                          show: (data) {
                            ConstanceData.showEnotes(context, data);
                          },
                        )
                      : BuildBookBarSection(
                          show: (data) {
                            ConstanceData.show(context, data);
                          },
                        ),
                  const LibrarySection(), // Show for Android
                  data.currentTab == 2
                      ? DynamicEnotesSection()
                      : const DynamicBooksSection(),
                  SizedBox(
                    height: 35.h,
                  ),
                ],
              ),
            );
          }),
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
      } else {}
    }
  }

  void fetchHomeSection() async {
    debugPrint("Data Cleared Here");
    for (var i in Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .formats!) {
      final response =
          await ApiProvider.instance.fetchHomeSections(i.productFormat ?? '');
      if (response.status ?? false) {
        if (i.productFormat == 'e-book') {
          Provider.of<CommonProvider>(
                  Navigation.instance.navigatorKey.currentContext!,
                  listen: false)
              .setEbookHomeSections(response.sections!);
        } else if (i.productFormat == 'magazine') {
          Provider.of<CommonProvider>(
                  Navigation.instance.navigatorKey.currentContext!,
                  listen: false)
              .setMagazineHomeSections(response.sections!);
        } else if (i.productFormat == 'e-notes') {
          Provider.of<CommonProvider>(
                  Navigation.instance.navigatorKey.currentContext!,
                  listen: false)
              .setEnotesHomeSections(response.sections!);
        }
      }
      // Provider.of<CommonProvider>(
      //   Navigation.instance.navigatorKey.currentContext!,
      //   listen: false,
      // ).clearData();
      // final currentFormat = Provider.of<DataProvider>(
      //         Navigation.instance.navigatorKey.currentContext!,
      //         listen: false)
      //     .formats![Provider.of<DataProvider>(
      //             Navigation.instance.navigatorKey.currentContext!,
      //             listen: false)
      //         .currentTab]
      //     .productFormat;
      // debugPrint("currentFormat $currentFormat");
      // final response =
      //     await ApiProvider.instance.fetchHomeSections(currentFormat ?? '');
      // if (response.status ?? false) {
      //   Provider.of<CommonProvider>(
      //           Navigation.instance.navigatorKey.currentContext!,
      //           listen: false)
      //       .addHomeSection(response.sections!);
      setState(() {});
    }

    _refreshController.refreshCompleted();
  }

  void goToUrl(String initialLink) async {
    debugPrint("GoToUrl: " + initialLink);
    final uri = Uri.parse(initialLink);
    if (uri.queryParameters['details'] == "reading") {
      checkByFormat(uri, initialLink);
    } else {
      Navigation.instance.navigate('/bookInfo',
          args: int.parse(uri.queryParameters['id'] ?? "0"));
    }
  }

  void goToUrlSecond(String initialLink) async {
    final uri = Uri.parse(initialLink);
    if (uri.queryParameters['details'] == "reading") {
      if (uri.queryParameters['format'] == "e-book") {
        Provider.of<DataProvider>(context, listen: false).setCurrentTab(0);
        if (Storage.instance.isLoggedIn) {
          if (Provider.of<DataProvider>(context, listen: false).myBooks.any(
              (element) =>
                  (element.id ?? 0) ==
                  int.parse(uri.queryParameters['id'] ?? "0"))) {
            Storage.instance.setReadingBookPage(
                int.parse(uri.queryParameters['page'] ?? "0"));
            Navigation.instance.navigate('/bookDetails',
                args:
                    "${int.parse(uri.queryParameters['id'] ?? "0")},${uri.queryParameters['image']}");
          } else {
            Navigation.instance.navigate('/bookInfo',
                args: int.parse(uri.queryParameters['id'] ?? "0"));
          }
        } else {
          await Navigation.instance.navigate('/loginReturn');
          initUniLinks();
        }
      } else {
        Provider.of<DataProvider>(context, listen: false).setCurrentTab(1);
        if (Storage.instance.isLoggedIn) {
          if (Provider.of<DataProvider>(context, listen: false).myBooks.any(
              (element) =>
                  (element.id ?? 0) ==
                  int.parse(uri.queryParameters['id'] ?? "0"))) {
            Storage.instance.setReadingBookPage(
                int.parse(uri.queryParameters['page'] ?? "0"));
            Navigation.instance.navigate('/bookDetails',
                args:
                    "${int.parse(uri.queryParameters['id'] ?? "0")},${uri.queryParameters['image']}");
          } else {
            Navigation.instance.navigate('/bookInfo',
                args: int.parse(uri.queryParameters['id'] ?? "0"));
          }
        } else {
          await Navigation.instance.navigate('/loginReturn');
        }
      }
    } else {
      Navigation.instance.navigate('/bookInfo',
          args: int.parse(uri.queryParameters['id'] ?? "0"));
    }
  }

  void checkByFormat(Uri uri, String initialLink) async {
    if (uri.queryParameters['format'] == "e-book") {
      Provider.of<DataProvider>(context, listen: false).setCurrentTab(0);
      if (Storage.instance.isLoggedIn) {
        sentToDestination(uri);
      } else {
        await Navigation.instance.navigate('/loginReturn');
        initUniLinks();
      }
    } else {
      Provider.of<DataProvider>(context, listen: false).setCurrentTab(1);
      if (Storage.instance.isLoggedIn) {
        sentToDestination(uri);
      } else {
        await Navigation.instance.navigate('/loginReturn');
        initUniLinks();
      }
    }
  }

  void sentToDestination(Uri uri) async {
    if (checkIfBoughtOrFree(uri)) {
      Storage.instance
          .setReadingBookPage(int.parse(uri.queryParameters['page'] ?? "0"));
      Navigation.instance.navigate('/bookDetails',
          args:
              "${int.parse(uri.queryParameters['id'] ?? "0")},${uri.queryParameters['image']}");
    } else {
      Navigation.instance.navigate('/bookInfo',
          args: int.parse(uri.queryParameters['id'] ?? "0"));
    }
  }

  bool checkIfBoughtOrFree(Uri uri) {
    if (Provider.of<DataProvider>(context, listen: false).myBooks.any(
        (element) =>
            (element.id ?? 0) == int.parse(uri.queryParameters['id'] ?? "0"))) {
      return true;
    }
    if (Provider.of<DataProvider>(context, listen: false)
            .details
            ?.selling_price
            ?.toStringAsFixed(2)
            .toString() ==
        "0.00") {
      return true;
    }
    return false;
  }

  fetchBookDetails(String? initialLink) async {
    final uri = Uri.parse(initialLink ?? "");
    final response = await ApiProvider.instance
        .fetchBookDetails("${uri.queryParameters['id'] ?? 0}");
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setBookDetails(response.details!);
    }
  }

  fetchNotifications() async {
    final response = await ApiProvider.instance
        .fetchNotification(Storage.instance.isLoggedIn);
    if (response.success ?? false) {
      Provider.of<DataProvider>(context, listen: false)
          .setNotifications(response.result ?? []);
    }
  }
}
