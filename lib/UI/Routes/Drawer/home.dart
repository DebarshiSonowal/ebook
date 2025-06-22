// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:async';
import 'dart:io';

import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Storage/common_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../../Storage/app_storage.dart';
import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../Components/buildbook_section.dart';
import '../../Components/dynamic_books_section.dart';
import '../../Components/library_section.dart';
import 'package:app_links/app_links.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  StreamSubscription? _sub;
  int selected = 0;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController controller = ScrollController();
  bool isLoading = true; // Add loading state

  void _onRefresh() async {
    // monitor network fetch
    setState(() {
      isLoading = true;
    });

    try {
      // Wait for both APIs to complete
      await Future.wait([
        fetchHomeBanner(),
        fetchHomeSection(),
      ]);

      // Add a small delay to ensure state updates are processed
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      debugPrint("Error during refresh: $e");
    } finally {
      // Always complete the refresh and hide loading
      setState(() {
        isLoading = false;
      });
      _refreshController.refreshCompleted();
    }
  }

  Future<void> initUniLinks() async {
    print("deeplink start initial");
    try {
      final appLinks = AppLinks();

      // Always set up the listener first
      initUniLinksAlive(appLinks);

      // Then handle initial/background links
      final uri = await appLinks.getInitialLink();
      if (uri != null) {
        print("Initial deeplink: $uri");
        await handleInitialLink(uri.toString());
      } else {
        print("No initial deeplink");
      }
    } catch (e) {
      print("Error initializing deep links: $e");
    }
  }

  Future<void> initUniLinksAlive(AppLinks appLinks) async {
    try {
      // Listen to app links while app is in foreground
      _sub = appLinks.uriLinkStream.listen((Uri? uri) async {
        print("Foreground deeplink: $uri");
        if (uri != null) {
          await handleForegroundLink(uri.toString());
        }
      }, onError: (err) {
        print("Deeplink error: $err");
        // Handle exception by warning the user their action did not succeed
      });
    } catch (e) {
      print("Error setting up link listener: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint("didChangeAppLifecycleState $state}");
    // Removed automatic refresh on app lifecycle changes
  }

  @override
  void dispose() {
    _sub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(seconds: 0), () {
      initUniLinks();
      fetchNotifications();
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    setState(() {
      isLoading = true;
    });

    // Small delay to let the UI render
    await Future.delayed(const Duration(milliseconds: 100));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SmartRefresher(
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
              child: Consumer<DataProvider>(builder: (context, data, _) {
                // Check if we have actual data loaded
                bool hasBannerData = false;
                try {
                  hasBannerData = data.bannerList != null &&
                      data.bannerList!.isNotEmpty &&
                      data.currentTab < data.bannerList!.length &&
                      data.bannerList![data.currentTab].isNotEmpty;
                } catch (e) {
                  debugPrint("Error checking banner data: $e");
                  hasBannerData = false;
                }

                debugPrint(
                    "Banner check - isLoading: $isLoading, hasBannerData: $hasBannerData, currentTab: ${data.currentTab}, bannerList length: ${data.bannerList?.length}");

                return SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      (isLoading || !hasBannerData)
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : data.currentTab == 2
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
                      const LibrarySection(),
                      data.currentTab == 2
                          ? DynamicEnotesSection()
                          : const DynamicBooksSection(),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Loading...',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black,
                              fontSize: 16.sp,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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

  Future<void> fetchHomeBanner() async {
    final dataProvider = Provider.of<DataProvider>(
        Navigation.instance.navigatorKey.currentContext!,
        listen: false);

    // Clear existing banners before refreshing
    dataProvider.bannerList?.clear();

    final formats = dataProvider.formats;
    if (formats == null || formats.isEmpty) {
      debugPrint("Formats not available for banner refresh");
      return;
    }

    for (var i in formats) {
      final response =
          await ApiProvider.instance.fetchHomeBanner(i.productFormat ?? '');
      if (response.status ?? false) {
        dataProvider.addBannerList(response.banners!);
      } else {
        debugPrint("Failed to refresh banner for format: ${i.productFormat}");
      }
    }
    debugPrint(
        "Banner refresh completed. Total banner groups: ${dataProvider.bannerList?.length ?? 0}");
  }

  Future<void> fetchHomeSection() async {
    debugPrint("Data Cleared Here");
    final dataProvider = Provider.of<DataProvider>(
        Navigation.instance.navigatorKey.currentContext!,
        listen: false);

    final formats = dataProvider.formats;
    if (formats == null || formats.isEmpty) {
      debugPrint("Formats not available for section refresh");
      return;
    }

    final List<Future<void>> sectionFutures = [];

    for (var i in formats) {
      sectionFutures.add(_fetchSectionForFormat(i));
    }

    // Wait for all sections to complete
    await Future.wait(sectionFutures);

    setState(() {});
    debugPrint("Section refresh completed for all formats");
  }

  Future<void> _fetchSectionForFormat(dynamic format) async {
    try {
      final response = await ApiProvider.instance
          .fetchHomeSections(format.productFormat ?? '');

      if (response.status ?? false) {
        final commonProvider = Provider.of<CommonProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false);

        switch (format.productFormat) {
          case 'e-book':
            commonProvider.setEbookHomeSections(response.sections!);
            break;
          case 'magazine':
            commonProvider.setMagazineHomeSections(response.sections!);
            break;
          case 'e-note':
            commonProvider.setEnotesHomeSections(response.sections!);
            break;
        }
      } else {
        debugPrint(
            "Failed to refresh section for format: ${format.productFormat}");
      }
    } catch (e) {
      debugPrint(
          "Error fetching section for format ${format.productFormat}: $e");
    }
  }

  void goToUrl(String initialLink) async {
    debugPrint("GoToUrl: " + initialLink);
    final uri = Uri.parse(initialLink);
    debugPrint("Parsed URI: $uri");
    debugPrint("Details parameter: ${uri.queryParameters['details']}");

    if (uri.queryParameters['details'] == "reading") {
      debugPrint("Handling reading link");
      checkByFormat(uri, initialLink);
    } else if (uri.queryParameters['details'] == "library") {
      debugPrint("Handling library link");
      // Handle library links
      handleLibraryLink(uri);
    } else {
      debugPrint("Handling regular book info link");
      Navigation.instance.navigate('/bookInfo',
          args: int.parse(uri.queryParameters['id'] ?? "0"));
    }
  }

  void goToUrlSecond(String initialLink) {
    debugPrint("GoToUrlSecond: " + initialLink);
    final uri = Uri.parse(initialLink);
    debugPrint("Parsed URI: $uri");
    debugPrint("Details parameter: ${uri.queryParameters['details']}");

    if (uri.queryParameters['details'] == "reading") {
      debugPrint("Handling reading link in foreground");
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
          Navigation.instance.navigate('/loginReturn');
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
          Navigation.instance.navigate('/loginReturn');
          initUniLinks();
        }
      }
    } else if (uri.queryParameters['details'] == "library") {
      debugPrint("Handling library link in foreground");
      // Handle library links
      handleLibraryLink(uri);
    } else {
      debugPrint("Handling regular book info link in foreground");
      Navigation.instance.navigate('/bookInfo',
          args: int.parse(uri.queryParameters['id'] ?? "0"));
    }
  }

  void checkByFormat(Uri uri, String initialLink) {
    if (uri.queryParameters['format'] == "e-book") {
      Provider.of<DataProvider>(context, listen: false).setCurrentTab(0);
      if (Storage.instance.isLoggedIn) {
        sentToDestination(uri);
      } else {
        Navigation.instance.navigate('/loginReturn');
        initUniLinks();
      }
    } else {
      Provider.of<DataProvider>(context, listen: false).setCurrentTab(1);
      if (Storage.instance.isLoggedIn) {
        sentToDestination(uri);
      } else {
        Navigation.instance.navigate('/loginReturn');
        initUniLinks();
      }
    }
  }

  void sentToDestination(Uri uri) {
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

  Future<void> fetchBookDetails(String? initialLink) async {
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

  Future<void> fetchNotifications() async {
    final response = await ApiProvider.instance
        .fetchNotification(Storage.instance.isLoggedIn);
    if (response.success ?? false) {
      Provider.of<DataProvider>(context, listen: false)
          .setNotifications(response.result ?? []);
    }
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  void handleLibraryLink(Uri uri) {
    debugPrint("Handling library link: $uri");
    debugPrint("Query parameters: ${uri.queryParameters}");

    try {
      final libraryIdString = uri.queryParameters['id'];
      debugPrint("Library ID string: $libraryIdString");

      if (libraryIdString == null || libraryIdString.isEmpty) {
        debugPrint("No library ID found in link");
        return;
      }

      final libraryId = int.parse(libraryIdString);
      debugPrint("Parsed library ID: $libraryId");

      if (libraryId > 0) {
        debugPrint("Navigating to library with ID: $libraryId");
        // Navigate to the specific library page using the correct route
        Navigation.instance.navigate('/libraryBooks', args: libraryId);
      } else {
        debugPrint("Invalid library ID: $libraryId");
      }
    } catch (e) {
      debugPrint("Error parsing library link: $e");
      debugPrint("Stack trace: ${StackTrace.current}");
    }
  }

  Future<void> handleInitialLink(String linkString) async {
    final uri = Uri.parse(linkString);

    // Only fetch book details for book-related links
    if (uri.queryParameters['details'] != "library") {
      await fetchBookDetails(linkString);
    }

    goToUrl(linkString);
  }

  Future<void> handleForegroundLink(String linkString) async {
    final uri = Uri.parse(linkString);

    // Only fetch book details for book-related links
    if (uri.queryParameters['details'] != "library") {
      await fetchBookDetails(linkString);
    }

    goToUrlSecond(linkString);
  }
}
