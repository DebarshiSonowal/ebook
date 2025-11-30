import 'dart:async';
import 'dart:convert';

import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/common_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Model/home_section.dart';
import 'package:ebook/UI/Routes/Drawer/library.dart';
import 'package:ebook/UI/Routes/Drawer/more.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// import 'package:uni_links2/uni_links.dart';
import 'package:upgrader/upgrader.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Networking/api_provider.dart';
import '../../Components/CategoryBar.dart';
import '../../Components/bottom_navbar.dart';
import '../../Components/buildbook_section.dart';
import '../../Components/dynamic_books_section.dart';
import '../../Components/new_searchbar.dart';
import '../../Components/new_tab_bar.dart';
import '../Drawer/home.dart';
import '../Drawer/history.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _controller;
  bool _isManualRefresh = false;

  @override
  Widget build(BuildContext context) {
    // Check for stored deep link route and navigate to it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Storage.instance.targetRoute != null) {
        final route = Storage.instance.targetRoute!;
        final args = Storage.instance.targetArguments;
        print(" HOME: Found stored route: $route with args: $args");
        Storage.instance.clearTargetRoute();

        Future.delayed(const Duration(milliseconds: 100), () {
          Navigation.instance.navigate(route, args: args);
          print(" HOME: Navigated to stored route: $route");
        });
      }
    });

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Dialogs.materialDialog(
              msg: 'Are you sure ? you want to exit',
              title: "Exit",
              color: Colors.white,
              context: context,
              titleStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Colors.black,
                    fontSize: 18.sp,
                  ),
              msgStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
              actions: [
                IconsOutlineButton(
                  onPressed: () {
                    Navigation.instance.goBack();
                  },
                  text: 'Cancel',
                  iconData: Icons.cancel_outlined,
                  textStyle: TextStyle(color: Colors.grey),
                  iconColor: Colors.grey,
                ),
                IconsButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  text: 'Exit',
                  iconData: Icons.exit_to_app,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ]);
          return false;
        },
        child: UpgradeAlert(
          upgrader: Upgrader(),
          child: Scaffold(
            // appBar: buildAppBar(context),
            // backgroundColor: const Color(0xff121212),
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              // color: Colors.white30,
              child: Consumer<DataProvider>(builder: (context, data, _) {
                return Column(
                  children: [
                    NewTabBar(controller: _controller),
                    const NewSearchBar(),
                    Builder(
                      builder: (context) {
                        debugPrint(
                            "CategoryBar logic - currentTab: ${data.currentTab}");
                        return data.currentTab == 2
                            ? EnotesCategoryBar()
                            : const CategoryBar();
                      },
                    ),
                    Expanded(
                      child: Consumer<DataProvider>(
                        builder: (context, current, _) {
                          return Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: bodyWidget(
                                current.currentIndex, current.currentTab),
                          );
                        }, 
                      ),
                    ),
                  ],
                );
              }),
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {},
            //   child: Image.asset(ConstanceData.primaryIcon),
            // ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: const BottomNavBarCustom(),
          ),
        ),
      ),
    );
  }

  Widget bodyWidget(int currentIndex, currentTab) {
    // debugPrint(currentIndex);
    // if (currentTab == 0) {
    switch (currentIndex) {
      case 1:
        return const Librarypage();
      case 2:
        return const Librarypage();
      case 3:
        return const OrderHistoryPage();
      case 4:
        return const More();
      default:
        return const Home();
    }
  }

  Widget bodyNoteWidget(int currentIndex, currentTab) {
    // debugPrint(currentIndex);
    // if (currentTab == 0) {
    switch (currentIndex) {
      case 1:
        return const Librarypage();
      case 2:
        return const Librarypage();
      case 3:
        return const OrderHistoryPage();
      case 4:
        return const More();
      default:
        return const Home();
    }
  }

  @override
  void initState() {
    super.initState();

    // Initial data fetch - only once
    _initializeData();

    _controller = TabController(
      length: Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext!,
                  listen: true)
              .formats
              ?.length ??
          2,
      vsync: this,
    );
    _controller?.addListener(() {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCurrentTab(_controller?.index ?? 0);

      // Removed automatic index resetting that was causing navigation back to home
      // This was interfering with deep link navigation
      debugPrint('Tab controller index changed to: ${_controller?.index}');
    });
  }

  Future<void> fetchCartItems() async {
    // Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.fetchCart();
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setToCart(response.cart?.items ?? []);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCartData(response.cart!);
      // Navigation.instance.goBack();
    } else {
      // Navigation.instance.goBack();
    }
  }

  // Future<void> getDynamicLink() async {
  //   final PendingDynamicLinkData? dynamicLinkData =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   if (dynamicLinkData != null) {
  //     final Uri deepLink = dynamicLinkData.link;
  //     debugPrint("URL link2 $deepLink");
  //   }
  // }

  Future<void> fetchDetails() async {
    await fetchCartItems();
    // getDynamicLink();
    // initUniLinks();
    final response = await ApiProvider.instance.getLibraryList();
    if (response.success ?? false) {
      Provider.of<DataProvider>(context, listen: false)
          .setLibraries(response.result ?? []);
    } else {}
  }

  Future<void> fetchEnotes() async {
    final response = await ApiProvider.instance.getEnoteCategory();
    if (response.success) {
      Provider.of<DataProvider>(context, listen: false)
          .setEnotesCategories(response.result);
    } else {}
  }

  Future<void> fetchEnotesBanner() async {
    final response = await ApiProvider.instance.getEnoteBanner();
    if (response.success) {
      Provider.of<DataProvider>(context, listen: false)
          .setEnotesBanner(response.result);
    } else {}
  }

  Future<void> fetchEnotesList() async {
    final response = await ApiProvider.instance.getEnoteList();
    if (response.success) {
      Provider.of<DataProvider>(context, listen: false)
          .setEnotesList(response.result.bookList);
    } else {}
  }

  Future<void> getEnoteSection() async {
    final response = await ApiProvider.instance.getEnoteSection();
    if (response.success) {
      Provider.of<DataProvider>(context, listen: false)
          .setEnotesSection(response.result);
    } else {}

    // Removed the problematic line that was interfering with loading states
    // The proper loading state is now managed in home.dart fetchHomeSection method
  }

  Future<void> fetchEnotesChapterList(String id) async {
    final response = await ApiProvider.instance.getEnoteChapter(id);
    if (response.success) {
      Provider.of<DataProvider>(context, listen: false)
          .setEnotesChapterList(response.result.chapterList);
    } else {}
  }

  Future<void> fetchEnotesDetails(String id) async {
    final response = await ApiProvider.instance.getEnoteDetails(id);
    if (response.success) {
      Provider.of<DataProvider>(context, listen: false)
          .setEnotesDetails(response.result);
    } else {}
  }

  Future<void> fetchData() async {
    // setState(() {
    //   loading = true;
    // });
    final response = await ApiProvider.instance.getRewards();
    if (response.success ?? false) {
      Provider.of<DataProvider>(context, listen: false)
          .setRewards(response.result!);
      // setState(() {
      //   loading = false;
      // });
    } else {
      // setState(() {
      //   loading = false;
      // });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint("didChangeAppLifecycleState $state}");
    // Removed automatic refresh on app lifecycle changes
  }

  Future<void> _initializeData() async {
    // Fetch initial data in parallel instead of sequentially for better performance
    await Future.wait([
      fetchData(),
      fetchDetails(),
      fetchPublicLibraries(),
      fetchEnotes(),
      fetchEnotesBanner(),
      fetchEnotesList(),
      getEnoteSection(),
    ]);

    // Wait a bit for formats to be fully loaded from splash screen
    await Future.delayed(const Duration(milliseconds: 500));

    // Now fetch banners and sections in parallel
    await Future.wait([
      fetchHomeBanner(),
      fetchHomeSection(),
    ]);
  }

  // Method to handle manual refresh with cache clearing
  Future<void> handleManualRefresh() async {
    _isManualRefresh = true;

    // Clear all cache when user manually refreshes
    await Storage.instance.clearAllApiCache();
    debugPrint("Manual refresh: Cleared all API cache");

    // Fetch fresh data
    await Future.wait([
      fetchHomeBanner(forceRefresh: true),
      fetchHomeSection(forceRefresh: true),
    ]);

    _isManualRefresh = false;
    debugPrint("Manual refresh completed");
  }

  Future<void> fetchHomeBanner({bool forceRefresh = false}) async {
    final dataProvider = Provider.of<DataProvider>(
        Navigation.instance.navigatorKey.currentContext!,
        listen: false);

    final formats = dataProvider.formats;
    if (formats == null || formats.isEmpty) {
      debugPrint("Formats not loaded yet, skipping banner fetch");
      return;
    }

    // Initialize bannerList with empty lists for each format to maintain order 
    dataProvider.setBannerList(List.generate(formats.length, (index) => []));

    // Fetch banners in order and place them in correct positions
    for (int i = 0; i < formats.length; i++) {
      final format = formats[i];
      final cacheKey = 'home_banner_${format.productFormat}';

      try {
        List<dynamic>? cachedBanners;

        // Check cache first if not forcing refresh
        if (!forceRefresh && !_isManualRefresh) {
          final cachedData = Storage.instance.getApiCache(cacheKey);
          if (cachedData != null) {
            final cachedJson = jsonDecode(cachedData);
            if (cachedJson['status'] == true && cachedJson['banners'] != null) {
              cachedBanners = cachedJson['banners'];
              debugPrint("Using cached banners for ${format.productFormat}");
            }
          }
        }

        if (cachedBanners != null) {
          // Use cached data
          final bannerList =
              cachedBanners.map((json) => Book.fromJson(json)).toList();
          dataProvider.setBannerListAt(i, bannerList);
          debugPrint(
              "Loaded ${bannerList.length} cached banners for ${format.productFormat} at index $i");
        } else {
          // Fetch from API
          final response = await ApiProvider.instance
              .fetchHomeBanner(format.productFormat ?? '');

          if (response.status ?? false) {
            // Cache the response
            final cacheData = {
              'status': true,
              'banners':
                  response.banners?.map((book) => book.toJson()).toList(),
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            };
            await Storage.instance.setApiCache(cacheKey, jsonEncode(cacheData));

            // Set banners at specific index to maintain order
            dataProvider.setBannerListAt(i, response.banners ?? []);
            debugPrint(
                "Fetched ${response.banners?.length ?? 0} banners for ${format.productFormat} at index $i");
          } else {
            debugPrint(
                "Failed to load banner for format: ${format.productFormat}");
            dataProvider.setBannerListAt(i, []);
          }
        }
      } catch (e) {
        debugPrint("Error fetching banner for ${format.productFormat}: $e");
        dataProvider.setBannerListAt(i, []);
      }
    }

    final bannerCount = dataProvider.bannerList?.length ?? 0;
    debugPrint("Banner loading completed. Total banner groups: $bannerCount");
  }

  Future<void> fetchHomeSection({bool forceRefresh = false}) async {
    try {
      final dataProvider = Provider.of<CommonProvider>(
        context,
        listen: false,
      );

      final formats = Provider.of<DataProvider>(context, listen: false).formats;
      if (formats == null || formats.isEmpty) {
        debugPrint("Formats not loaded yet, skipping section fetch");
        return;
      }

      for (final format in formats) {
        final cacheKey = 'home_section_${format.productFormat}';

        try {
          List<dynamic>? cachedSections;

          // Check cache first if not forcing refresh
          if (!forceRefresh && !_isManualRefresh) {
            final cachedData = Storage.instance.getApiCache(cacheKey);
            if (cachedData != null) {
              final cachedJson = jsonDecode(cachedData);
              if (cachedJson['status'] == true &&
                  cachedJson['sections'] != null) {
                cachedSections = cachedJson['sections'];
                debugPrint("Using cached sections for ${format.productFormat}");
              }
            }
          }

          if (cachedSections != null) {
            // Use cached data
            switch (format.productFormat) {
              case 'e-book':
                final sections = cachedSections
                    .map((json) => HomeSection.fromJson(json))
                    .toList();
                dataProvider.setEbookHomeSections(sections);
                debugPrint("Loaded ${sections.length} cached e-book sections");
                break;
              case 'magazine':
                final sections = cachedSections
                    .map((json) => HomeSection.fromJson(json))
                    .toList();
                dataProvider.setMagazineHomeSections(sections);
                debugPrint(
                    "Loaded ${sections.length} cached magazine sections");
                break;
              case 'enotes':
              case 'e-notes':
              case 'E-Notes':
                final sections = cachedSections
                    .map((json) => HomeSection.fromJson(json))
                    .toList();
                dataProvider.setEnotesHomeSections(sections);
                debugPrint("Loaded ${sections.length} cached e-notes sections");
                break;
            }
          } else {
            // Fetch from API
            final response = await ApiProvider.instance
                .fetchHomeSections(format.productFormat ?? '');

            if (response.status ?? false) {
              // Cache the raw response data
              final cacheData = {
                'status': true,
                'sections': response.sections
                    ?.map((section) => {
                          'title': section.title,
                          'books': section.book
                              ?.map((book) => book.toJson())
                              .toList(),
                        })
                    .toList(),
                'timestamp': DateTime.now().millisecondsSinceEpoch,
              };
              await Storage.instance
                  .setApiCache(cacheKey, jsonEncode(cacheData));

              switch (format.productFormat) {
                case 'e-book':
                  dataProvider.setEbookHomeSections(response.sections!);
                  debugPrint(
                      "Fetched ${response.sections?.length ?? 0} e-book sections");
                  break;
                case 'magazine':
                  dataProvider.setMagazineHomeSections(response.sections!);
                  debugPrint(
                      "Fetched ${response.sections?.length ?? 0} magazine sections");
                  break;
                case 'enotes':
                case 'e-notes':
                case 'E-Notes':
                  dataProvider.setEnotesHomeSections(response.sections!);
                  debugPrint(
                      "Fetched ${response.sections?.length ?? 0} e-notes sections");
                  break;
              }
            } else {
              debugPrint(
                  "Failed to load section for format: ${format.productFormat}");
            }
          }
        } catch (e) {
          debugPrint("Error fetching section for ${format.productFormat}: $e");
        }
      }

      debugPrint("Home sections loading completed");
    } catch (e) {
      debugPrint('Error fetching home sections: $e');
    }
  }

  Future<void> fetchPublicLibraries() async {
    final response = await ApiProvider.instance.getPublicLibraryList();
    if (response.success) {
      Provider.of<DataProvider>(context, listen: false)
          .setPublicLibraries(response.result ?? []);
    } else {}
  }
}
