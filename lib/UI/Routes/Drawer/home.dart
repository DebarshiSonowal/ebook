// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:http_cache_manager/http_cache_manager.dart';

import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Model/advertisement.dart';
import 'package:ebook/Model/home_section.dart';
import 'package:ebook/Storage/common_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Storage/app_storage.dart';
import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../Components/buildbook_section.dart';
import '../../Components/dynamic_books_section.dart';
import '../../Components/library_section.dart';
import '../../Components/advertisement_banner.dart';
import 'package:app_links/app_links.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  // Static reference to the current home state instance
  static _HomeState? _currentInstance;

  // Static method to safely trigger refresh
  static void triggerRefresh() {
    if (_currentInstance != null && _currentInstance!.mounted) {
      _currentInstance!.refreshHomeData();
      debugPrint("Home screen refresh triggered via static method");
    } else {
      debugPrint("No active Home instance available for refresh");
    }
  }

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
  bool isLoadingAdBanners = true; // Add specific loading state for ad banners

  void _onRefresh() async {
    // monitor network fetch
    debugPrint("onRefresh - Manual refresh triggered");
    setState(() {
      isLoading = true;
    });

    try {
      // Clear all cache on manual refresh
      await Storage.instance.clearAllApiCache();
      debugPrint("Manual refresh: Cleared all API cache");

      // Wait for both APIs to complete
      await Future.wait([
        fetchHomeBanner(),
        fetchHomeSection(),
        fetchAdvertisementBanners(),
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
      if (mounted) {
        _refreshController.refreshCompleted();
      }
    }
  }

  Future<void> initUniLinks() async {
    print("🔗 HOME: Initializing universal links...");
    try {
      final appLinks = AppLinks();

      // Always set up the listener first
      initUniLinksAlive(appLinks);

      // Then handle initial/background links
      final uri = await appLinks.getInitialLink();
      if (uri != null) {
        print("🔗 HOME: Initial deeplink: $uri");
        await handleInitialLink(uri.toString());
      } else {
        print("🔗 HOME: No initial deeplink");
      }

      // Test universal links configuration
      await testUniversalLinksConfiguration();
    } catch (e) {
      print("🔗 HOME: Error initializing deep links: $e");
    }
  }

  // Test universal links configuration
  Future<void> testUniversalLinksConfiguration() async {
    print("🔗 HOME: Testing universal links configuration...");

    // Test if the app can handle the domain
    try {
      final testUrls = [
        'https://tratri.in/link',
        'https://tratri.in/link?test=1',
        'tratri://test',
      ];

      for (final url in testUrls) {
        print("🔗 HOME: Testing URL: $url");
        // This would normally be handled by the system
      }
    } catch (e) {
      print("🔗 HOME: Error testing configuration: $e");
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

  Future<void> handleInitialLink(String linkString) async {
    try {
      print("🔗 handleInitialLink: $linkString");

      // Enhanced validation for Facebook links
      bool isFromFacebook =
          linkString.contains('facebook') || linkString.contains('fb');
      print("🔗 Link from Facebook: $isFromFacebook");

      // Validate URL format with more flexibility
      bool isValidTratriLink = linkString.contains('tratri.in/link') ||
          linkString.startsWith('https://tratri.in/link') ||
          linkString.startsWith('http://tratri.in/link');

      if (!isValidTratriLink) {
        print("❌ Invalid URL format: $linkString");
        // Try to extract tratri.in link from Facebook wrapper
        final regex = RegExp(r'https?://(?:www\.)?tratri\.in/link[^&]*');
        final match = regex.firstMatch(linkString);
        if (match != null) {
          linkString = match.group(0)!;
          print("🔗 Extracted link from wrapper: $linkString");
        } else {
          return;
        }
      }

      final uri = Uri.parse(linkString);
      print("🔗 Parsed URI: $uri");
      print("🔗 Query params: ${uri.queryParameters}");

      // Validate required parameters with better error handling
      if (uri.queryParameters['id'] == null ||
          uri.queryParameters['details'] == null) {
        print("❌ Missing required parameters: id or details");
        // For Facebook links, try to show a helpful message
        if (isFromFacebook) {
          print("🔗 Facebook link detected - showing fallback");
          // You could show a toast or redirect to main app
        }
        return;
      }

      // Add delay for Facebook in-app browser
      if (isFromFacebook) {
        print("🔗 Adding delay for Facebook in-app browser");
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Only fetch book details for book-related links
      if (uri.queryParameters['details'] != "library") {
        await fetchBookDetails(linkString);
      }

      goToUrl(linkString);
      print("🔗 handleInitialLink completed successfully");
    } catch (e, stackTrace) {
      print("❌ Error in handleInitialLink: $e");
      print("❌ Stack trace: $stackTrace");
      // Don't rethrow - this might cause the fallback to Safari
    }
  }

  Future<void> handleForegroundLink(String linkString) async {
    try {
      print("🔗 handleForegroundLink: $linkString");

      // Enhanced validation for Facebook links
      bool isFromFacebook =
          linkString.contains('facebook') || linkString.contains('fb');
      print("🔗 Link from Facebook: $isFromFacebook");

      // Validate URL format with more flexibility
      bool isValidTratriLink = linkString.contains('tratri.in/link') ||
          linkString.startsWith('https://tratri.in/link') ||
          linkString.startsWith('http://tratri.in/link');

      if (!isValidTratriLink) {
        print("❌ Invalid URL format: $linkString");
        // Try to extract tratri.in link from Facebook wrapper
        final regex = RegExp(r'https?://(?:www\.)?tratri\.in/link[^&]*');
        final match = regex.firstMatch(linkString);
        if (match != null) {
          linkString = match.group(0)!;
          print("🔗 Extracted link from wrapper: $linkString");
        } else {
          return;
        }
      }

      final uri = Uri.parse(linkString);
      print("🔗 Parsed URI: $uri");
      print("🔗 Query params: ${uri.queryParameters}");

      // Validate required parameters with better error handling
      if (uri.queryParameters['id'] == null ||
          uri.queryParameters['details'] == null) {
        print("❌ Missing required parameters: id or details");
        // For Facebook links, try to show a helpful message
        if (isFromFacebook) {
          print("🔗 Facebook link detected - showing fallback");
          // You could show a toast or redirect to main app
        }
        return;
      }

      // Add delay for Facebook in-app browser
      if (isFromFacebook) {
        print("🔗 Adding delay for Facebook in-app browser");
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Only fetch book details for book-related links
      if (uri.queryParameters['details'] != "library") {
        await fetchBookDetails(linkString);
      }

      goToUrlSecond(linkString);
      print("🔗 handleForegroundLink completed successfully");
    } catch (e, stackTrace) {
      print("❌ Error in handleForegroundLink: $e");
      print("❌ Stack trace: $stackTrace");
      // Don't rethrow - this might cause the fallback to Safari
    }
  }

  void goToUrlSecond(String initialLink) {
    debugPrint("GoToUrlSecond: " + initialLink);
    final uri = Uri.parse(initialLink);
    debugPrint("Parsed URI: $uri");
    debugPrint("Details parameter: ${uri.queryParameters['details']}");

    if (uri.queryParameters['details'] == "reading") {
      debugPrint("Handling reading link in second method");
      checkByFormat(uri, initialLink);
    } else if (uri.queryParameters['details'] == "library") {
      debugPrint("Handling library link in second method");
      // Handle library links
      handleLibraryLink(uri);
    } else {
      debugPrint("Handling regular book info link in second method");
      Navigation.instance.navigate('/bookInfo',
          args: int.parse(uri.queryParameters['id'] ?? "0"));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint("didChangeAppLifecycleState $state");

    // Only refresh if we're coming back to the app and don't have data
    if (state == AppLifecycleState.resumed && mounted && !isLoading) {
      final dataProvider = Provider.of<DataProvider>(
          Navigation.instance.navigatorKey.currentContext ?? context,
          listen: false);

      bool hasAnyBannerData = dataProvider.bannerList != null &&
          dataProvider.bannerList!.isNotEmpty &&
          dataProvider.bannerList!.any((list) => list.isNotEmpty);

      if (!hasAnyBannerData) {
        debugPrint("No banner data on resume, triggering load");
        _loadInitialData();
      }
    }
  }

  @override
  void dispose() {
    // Unregister this instance
    if (Home._currentInstance == this) {
      Home._currentInstance = null;
    }
    _sub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Register this instance
    Home._currentInstance = this;
    WidgetsBinding.instance.addObserver(this);

    // Run initialization tasks in parallel for better performance
    Future.wait([
      initUniLinks(),
      fetchNotifications(),
      fetchAdvertisementBanners(),
    ]).then((_) {
      _loadInitialData();
    });
  }

  // Method to test cache functionality
  Future<void> _testCacheLoad() async {
    debugPrint("🧪 Testing cache functionality...");

    final dataProvider = Provider.of<DataProvider>(
        Navigation.instance.navigatorKey.currentContext!,
        listen: false);

    // Clear in-memory data to force reload
    dataProvider.setBannerList([]);

    // Show current cache status
    Storage.instance.debugCacheStatus();

    setState(() {
      isLoading = true;
    });

    // This should now use cache if available
    await Future.wait([
      fetchHomeBanner(),
      fetchHomeSection(),
    ]);

    setState(() {
      isLoading = false;
    });

    debugPrint("🧪 Cache test completed");
  }

  void _loadInitialData() async {
    setState(() {
      isLoading = true;
    });

    // Reset loading states for sections when initially loading
    final commonProvider = Provider.of<CommonProvider>(
        Navigation.instance.navigatorKey.currentContext!,
        listen: false);
    commonProvider.resetLoadingStates();

    // Actually fetch the banner data if not already loaded
    final dataProvider = Provider.of<DataProvider>(
        Navigation.instance.navigatorKey.currentContext!,
        listen: false);

    // Ensure formats are loaded first
    bool hasFormats =
        dataProvider.formats != null && dataProvider.formats!.isNotEmpty;
    if (!hasFormats) {
      debugPrint("🔍 Formats not loaded yet, waiting...");
      // Wait a bit for formats to be loaded from splash or other sources
      await Future.delayed(const Duration(milliseconds: 500));
      hasFormats =
          dataProvider.formats != null && dataProvider.formats!.isNotEmpty;
    }

    // For cache testing, temporarily clear in-memory banner data to force reload
    bool hadBannerData = dataProvider.bannerList != null &&
        dataProvider.bannerList!.isNotEmpty &&
        dataProvider.bannerList!.any((list) => list.isNotEmpty);

    if (hadBannerData) {
      debugPrint("🧪 Clearing in-memory banner data to test cache...");
      dataProvider.setBannerList([]);
    }

    // Check if we need to load banner data
    bool needsBannerData = dataProvider.bannerList == null ||
        dataProvider.bannerList!.isEmpty ||
        dataProvider.bannerList!.every((list) => list.isEmpty);

    debugPrint(
        "🔍 Loading check: needsBannerData=$needsBannerData, hasFormats=$hasFormats, hadDataBefore=$hadBannerData");
    debugPrint(
        "🔍 Current banner data: ${dataProvider.bannerList?.length} groups");

    // Debug cache status at startup
    Storage.instance.debugCacheStatus();

    if (needsBannerData && hasFormats) {
      debugPrint("🚀 Loading banner and section data...");
      try {
        await Future.wait([
          fetchHomeBanner(),
          fetchHomeSection(),
        ]);
      } catch (e) {
        debugPrint("❌ Error loading initial data: $e");
      }
    } else if (!hasFormats) {
      debugPrint("❌ Formats still not available, skipping banner load");
    } else {
      debugPrint("✅ Banner data already available, skipping load");
    }

    // Reduce delay for faster UI response
    await Future.delayed(const Duration(milliseconds: 50));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(
          waterDropColor: Colors.white,
          complete: Text(
            "Refresh Completed",
            style: TextStyle(color: Colors.white),
          ),
          failed: Text(
            "Refresh Failed",
            style: TextStyle(color: Colors.white),
          ),
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("");
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
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
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
                "Banner check - isLoading: $isLoading, hasBannerData: $hasBannerData, currentTab: ${data.currentTab}, bannerList length: ${data.bannerList?.length ?? 0}, tab content length: ${data.bannerList != null && data.currentTab < data.bannerList!.length ? data.bannerList![data.currentTab].length : 'N/A'}");

            return Column(
              children: [
                GestureDetector(
                  onDoubleTap: _testCacheLoad,
                  child: (!hasBannerData && isLoading)
                      ? Container(
                          height: 20.h,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : hasBannerData
                          ? (data.currentTab == 2
                              ? BuildEnoteBarSection(
                                  show: (data) {
                                    ConstanceData.showEnotes(context, data);
                                  },
                                )
                              : BuildBookBarSection(
                                  show: (data) {
                                    ConstanceData.show(context, data);
                                  },
                                ))
                          : Container(
                              height: 10.h,
                              child: Center(
                                child: Text(
                                  data.currentTab == 2
                                      ? "No E-notes available\n(Double tap to reload)"
                                      : data.currentTab == 1
                                          ? "No magazines available\n(Double tap to reload)"
                                          : "No e-books available\n(Double tap to reload)",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                ),
                SizedBox(height: 1.h),
                // Advertisement Banner Carousel Sections
                // Show shimmer while loading or ad banners when ready
                Consumer<DataProvider>(
                  builder: (context, dataProvider, child) {
                    final allBanners = dataProvider.advertisementBanners ?? [];

                    if (isLoadingAdBanners) {
                      return Column(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 20.h,
                              child: PageView.builder(
                                itemCount: 3, // Show 3 shimmer items
                                controller:
                                    PageController(viewportFraction: 0.9),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    child: Container(
                                      height: 20.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                        ],
                      );
                    }

                    if (allBanners.isNotEmpty) {
                      return Column(
                        children: [
                          Container(
                            height: 20.h,
                            child: PageView.builder(
                              itemCount: allBanners.length,
                              controller: PageController(viewportFraction: 0.9),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                                  child: AdvertisementBannerWidget(
                                    banner: allBanners[index],
                                    height: 20.h,
                                    margin: EdgeInsets.zero,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                        ],
                      );
                    }
                    // Hide section completely when not loading and no banners
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: 1.h),
                const LibrarySection(),
                data.currentTab == 2
                    ? DynamicEnotesSection()
                    : const DynamicBooksSection(),
                SizedBox(
                  height: 1.h,
                ),
              ],
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
    debugPrint("🎯 [HOME.DART] Starting home banner fetch with caching");
    final dataProvider = Provider.of<DataProvider>(
        Navigation.instance.navigatorKey.currentContext!,
        listen: false);

    // Clear existing banners before refreshing
    dataProvider.setBannerList([]);

    final formats = dataProvider.formats;
    if (formats == null || formats.isEmpty) {
      debugPrint("❌ [HOME.DART] Formats not available for banner refresh");
      return;
    }

    debugPrint(
        "📋 [HOME.DART] Processing ${formats.length} formats for banners");

    // Initialize bannerList with empty lists for each format to maintain order
    dataProvider
        .setBannerList(List.generate(formats.length, (index) => <Book>[]));

    // Fetch banners sequentially to maintain correct order (not in parallel)
    for (int i = 0; i < formats.length; i++) {
      final format = formats[i];
      final cacheKey = 'home_banner_${format.productFormat}';

      debugPrint("🔍 [HOME.DART] Checking cache for: $cacheKey");

      try {
        List<dynamic>? cachedBanners;

        // Check cache first
        final cachedData = Storage.instance.getApiCache(cacheKey);
        if (cachedData != null) {
          debugPrint("✅ [HOME.DART] Cache hit for $cacheKey");
          final cachedJson = jsonDecode(cachedData);
          if (cachedJson['status'] == true && cachedJson['banners'] != null) {
            cachedBanners = cachedJson['banners'];
            debugPrint(
                "✅ [HOME.DART] Using cached banners for ${format.productFormat}");
          }
        } else {
          debugPrint("❌ [HOME.DART] Cache miss for $cacheKey");
        }

        if (cachedBanners != null) {
          // Use cached data
          final bannerList =
              cachedBanners.map((json) => Book.fromJson(json)).toList();
          dataProvider.setBannerListAt(i, bannerList);
          debugPrint(
              "📚 [HOME.DART] Loaded ${bannerList.length} cached banners for ${format.productFormat} at index $i");
        } else {
          // Fetch from API
          debugPrint(
              "🌐 [HOME.DART] Fetching banners from API for ${format.productFormat}");
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
                "📚 [HOME.DART] Fetched & cached ${response.banners?.length ?? 0} banners for ${format.productFormat} at index $i");
          } else {
            debugPrint(
                "❌ [HOME.DART] Failed to refresh banner for format: ${format.productFormat}");
            dataProvider.setBannerListAt(i, []);
          }
        }
      } catch (e) {
        debugPrint(
            "❌ [HOME.DART] Error fetching banner for ${format.productFormat}: $e");
        dataProvider.setBannerListAt(i, []);
      }
    }

    debugPrint(
        "✅ [HOME.DART] Banner refresh completed. Total banner groups: ${dataProvider.bannerList?.length ?? 0}");
  }

  Future<void> fetchHomeSection() async {
    debugPrint("🔄 Starting home sections fetch with caching");
    final dataProvider = Provider.of<DataProvider>(
        Navigation.instance.navigatorKey.currentContext!,
        listen: false);
    final commonProvider = Provider.of<CommonProvider>(
        Navigation.instance.navigatorKey.currentContext!,
        listen: false);

    // Reset loading states for all sections
    commonProvider.resetLoadingStates();

    final formats = dataProvider.formats;
    if (formats == null || formats.isEmpty) {
      debugPrint("❌ Formats not available for section refresh");
      return;
    }

    debugPrint("📋 Processing ${formats.length} formats for sections");

    // Process each format sequentially to maintain order
    for (final format in formats) {
      await _fetchSectionForFormat(format);
    }

    setState(() {});
    debugPrint("✅ Section refresh completed for all formats");
  }

  Future<void> _fetchSectionForFormat(dynamic format) async {
    final cacheKey = 'home_section_${format.productFormat}';

    try {
      List<dynamic>? cachedSections;

      // Check cache first
      final cachedData = Storage.instance.getApiCache(cacheKey);
      if (cachedData != null) {
        final cachedJson = jsonDecode(cachedData);
        if (cachedJson['status'] == true && cachedJson['sections'] != null) {
          cachedSections = cachedJson['sections'];
          debugPrint("Using cached sections for ${format.productFormat}");
        }
      }

      final commonProvider = Provider.of<CommonProvider>(
          Navigation.instance.navigatorKey.currentContext!,
          listen: false);

      if (cachedSections != null) {
        // Use cached data
        switch (format.productFormat) {
          case 'e-book':
            final sections = cachedSections
                .map((json) => {
                      'title': json['title'],
                      'books': json['books'],
                    })
                .toList();
            final homeSections = sections
                .map((sectionData) => _createHomeSectionFromCache(sectionData))
                .cast<HomeSection>()
                .toList();
            commonProvider.setEbookHomeSections(homeSections);
            debugPrint(
                "📚 Loaded ${homeSections.length} cached e-book sections");
            break;
          case 'magazine':
            final sections = cachedSections
                .map((json) => {
                      'title': json['title'],
                      'books': json['books'],
                    })
                .toList();
            final homeSections = sections
                .map((sectionData) => _createHomeSectionFromCache(sectionData))
                .cast<HomeSection>()
                .toList();
            commonProvider.setMagazineHomeSections(homeSections);
            debugPrint(
                "📰 Loaded ${homeSections.length} cached magazine sections");
            break;
          case 'e-note':
            final sections = cachedSections
                .map((json) => {
                      'title': json['title'],
                      'books': json['books'],
                    })
                .toList();
            final homeSections = sections
                .map((sectionData) => _createHomeSectionFromCache(sectionData))
                .cast<HomeSection>()
                .toList();
            commonProvider.setEnotesHomeSections(homeSections);
            debugPrint(
                "📝 Loaded ${homeSections.length} cached e-notes sections");
            break;
        }
      } else {
        // Fetch from API
        debugPrint("Fetching sections from API for ${format.productFormat}");
        final response = await ApiProvider.instance
            .fetchHomeSections(format.productFormat ?? '');

        if (response.status ?? false) {
          // Cache the response
          final cacheData = {
            'status': true,
            'sections': response.sections
                ?.map((section) => {
                      'title': section.title,
                      'books':
                          section.book?.map((book) => book.toJson()).toList(),
                    })
                .toList(),
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          };
          await Storage.instance.setApiCache(cacheKey, jsonEncode(cacheData));

          switch (format.productFormat) {
            case 'e-book':
              commonProvider.setEbookHomeSections(response.sections ?? []);
              debugPrint(
                  "Fetched ${response.sections?.length ?? 0} e-book sections");
              break;
            case 'magazine':
              commonProvider.setMagazineHomeSections(response.sections ?? []);
              debugPrint(
                  "Fetched ${response.sections?.length ?? 0} magazine sections");
              break;
            case 'e-note':
              commonProvider.setEnotesHomeSections(response.sections ?? []);
              debugPrint(
                  "Fetched ${response.sections?.length ?? 0} e-notes sections");
              break;
          }
        } else {
          // Even if API fails, set error state
          switch (format.productFormat) {
            case 'e-book':
              commonProvider.setEbookError();
              break;
            case 'magazine':
              commonProvider.setMagazineError();
              break;
            case 'e-note':
              commonProvider.setEnotesError();
              break;
          }
          debugPrint(
              "Failed to refresh section for format: ${format.productFormat}");
        }
      }
    } catch (e) {
      // On error, set error state
      final commonProvider = Provider.of<CommonProvider>(
          Navigation.instance.navigatorKey.currentContext!,
          listen: false);

      switch (format.productFormat) {
        case 'e-book':
          commonProvider.setEbookError();
          break;
        case 'magazine':
          commonProvider.setMagazineError();
          break;
        case 'e-note':
          commonProvider.setEnotesError();
          break;
      }
      debugPrint(
          "Error fetching section for format ${format.productFormat}: $e");
    }
  }

  // Helper method to create HomeSection from cached data
  HomeSection _createHomeSectionFromCache(Map<String, dynamic> sectionData) {
    // Create a proper HomeSection object from cached data
    final homeSection = HomeSection.fromJson({
      'title': sectionData['title'],
      'books': sectionData['books'],
    });
    return homeSection;
  }

  Future<void> fetchAdvertisementBanners() async {
    setState(() {
      isLoadingAdBanners = true;
    });

    try {
      final response = await ApiProvider.instance.fetchAdvertisementBanners();
      if (response.success ?? false) {
        final dataProvider = Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false);

        // Convert AdvertisementBanner to Advertisement for DataProvider compatibility
        final advertisements = response.result
                ?.map((banner) => Advertisement.fromJson({
                      'id': banner.id,
                      'ad_id': banner.id,
                      'is_interactive': false,
                      'ad_type': banner.adType,
                      'content': banner.content,
                      'redirect_link': banner.redirectLink,
                      'related_id': banner.relatedId,
                      'ad_category': banner.adCategory,
                    }))
                .toList() ??
            [];

        dataProvider.setAdBanner(advertisements);

        // Also store the original banner response for easier category filtering
        dataProvider.setAdvertisementBanners(response.result ?? []);

        debugPrint(
            "Advertisement banners loaded: ${response.result?.length ?? 0}");
      } else {
        debugPrint("Failed to fetch advertisement banners");
      }
    } catch (e) {
      debugPrint("Error fetching advertisement banners: $e");
    } finally {
      setState(() {
        isLoadingAdBanners = false;
      });
    }
  }

  void goToUrl(String initialLink) {
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

  void refreshHomeData() {
    debugPrint("External refresh triggered from mobile number update");
    _onRefresh();
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
        Navigation.instance.navigate('/libraryDetails', args: libraryId);
      } else {
        debugPrint("Invalid library ID: $libraryId");
      }
    } catch (e) {
      debugPrint("Error parsing library link: $e");
      debugPrint("Stack trace: ${StackTrace.current}");
    }
  }

  Future<void> _loadFormatsAndBannerData() async {
    if (isLoading) return; // Prevent multiple simultaneous loads

    setState(() {
      isLoading = true;
    });

    try {
      // First load formats
      await _fetchFormats();

      // Then load banner data
      await Future.wait([
        fetchHomeBanner(),
        fetchHomeSection(),
      ]);
    } catch (e) {
      debugPrint("Error loading formats and banner data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchFormats() async {
    final response = await ApiProvider.instance.fetchBookFormat();
    if (response.status ?? false) {
      final dataProvider = Provider.of<DataProvider>(
          Navigation.instance.navigatorKey.currentContext!,
          listen: false);
      dataProvider.setFormats(response.bookFormats!);
      debugPrint("Formats loaded: ${response.bookFormats?.length ?? 0}");
    } else {
      debugPrint("Failed to fetch formats");
    }
  }

  void _loadBannerData() async {
    if (isLoading) return; // Prevent multiple simultaneous loads

    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([
        fetchHomeBanner(),
        fetchHomeSection(),
      ]);
    } catch (e) {
      debugPrint("Error loading banner data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
