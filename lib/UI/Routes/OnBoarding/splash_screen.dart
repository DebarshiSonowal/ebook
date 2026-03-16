import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Storage/common_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.yellow,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const Spacer(
              flex: 3,
            ),
            Center(
              child: Image.asset(
                ConstanceData.primaryIcon,
                fit: BoxFit.fill,
                height: 20.h,
                width: 40.w,
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            // const Text('Tratri'),
            const Spacer(
              flex: 1,
            ),
            const SpinKitFoldingCube(
              color: Colors.white,
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _handleInitialization();
  }

  Future<void> _handleInitialization() async {
    bool needsUpdate = await _checkVersion();
    if (!needsUpdate) {
      fetchFormats();
      initiateSplash();
    }
  }

  Future<bool> _checkVersion() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String localVersion = packageInfo.version;
      
      final response = await ApiProvider.instance.verifyVersion();
      
      if (response.success && response.result != null) {
        final String remoteVersion = response.result!.appVersion;
        
        if (_isVersionLower(localVersion, remoteVersion)) {
          _showUpdateDialog(remoteVersion);
          return true;
        }
      }
    } catch (e) {
      debugPrint("Error checking version: $e");
    }
    return false;
  }

  bool _isVersionLower(String local, String remote) {
    List<int> localParts = local.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> remoteParts = remote.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    
    for (int i = 0; i < remoteParts.length; i++) {
      int localPart = i < localParts.length ? localParts[i] : 0;
      if (remoteParts[i] > localPart) return true;
      if (remoteParts[i] < localPart) return false;
    }
    return false;
  }

  void _showUpdateDialog(String newVersion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.white24, width: 1)),
          title: const Text("Update Available",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text(
              "A new version ($newVersion) of Tratri is available. Please update the app to continue.",
              style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () async {
                final Uri url = Uri.parse("https://onelink.to/xzcqex");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "UPDATE NOW",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initiateSplash() {
    Future.delayed(const Duration(seconds: ConstanceData.splashTime), () {
      // Check if we have a stored target route from deep link
      final hasTargetRoute = Storage.instance.targetRoute != null;
      
      if (hasTargetRoute) {
        print(" [DeepLinkDebug SPLASH]: Deep link route detected, navigating to main");
        // Navigate to main and let HomePage handle the deep link
        if (Storage.instance.isLoggedIn) {
          fetchProfile();
          Navigation.instance.navigateAndRemoveUntil('/main');
        } else {
          // Even if not logged in, we proceed to /main and let it handle the target route
          Navigation.instance.navigateAndRemoveUntil('/main');
        }
        return;
      }
      
      if (Storage.instance.isDeepLinkProcessed) {
        print(
            " [DeepLinkDebug SPLASH]: Deep link was processed, skipping automatic navigation to main");
        return;
      }

      print(
          "🚀 SPLASH: No deep link processed, proceeding with normal splash navigation");
      if (Storage.instance.isLoggedIn) {
        fetchProfile();
        Navigation.instance.navigateAndRemoveUntil('/main');
      } else if (Storage.instance.isOnBoarding) {
        Navigation.instance.navigateAndRemoveUntil('/main');
      } else {
        // Navigation.instance.navigateAndRemoveUntil('/login');
        Navigation.instance.navigateAndRemoveUntil('/main');
      }
    });
  }

  void fetchFormats() async {
    final response = await ApiProvider.instance.fetchBookFormat();
    if (response.status ?? false) {
      final formats = response.bookFormats!;
      debugPrint("Loaded ${formats.length} formats:");
      for (int i = 0; i < formats.length; i++) {
        debugPrint(
            "Format $i: ${formats[i].productFormat} (ID: ${formats[i].id})");
      }

      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setFormats(response.bookFormats!);

      // Execute all data fetching operations in parallel for better performance
      await Future.wait([
        fetchCategory(),
        fetchHomeBanner(),
        fetchHomeSection(),
        fetchBookmarks(),
        fetchCupons(),
      ]);
      
      // Mark data as loaded after all initial data is fetched
      Storage.instance.setDataLoaded(true);
      debugPrint("🚀 SPLASH: All initial data loaded successfully");
    }
  }

  Future<void> fetchCategory() async {
    final formats = Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .formats!;

    debugPrint("Fetching categories for ${formats.length} formats in order");

    // Fetch categories sequentially to maintain correct order
    for (int i = 0; i < formats.length; i++) {
      final format = formats[i];
      debugPrint(
          "Fetching categories for format ${i}: ${format.productFormat}");

      final response = await ApiProvider.instance
          .fetchBookCategory(format.productFormat ?? '');

      if (response.status ?? false) {
        debugPrint(
            "Loaded ${response.categories?.length ?? 0} categories for ${format.productFormat}");
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addCategoryList(response.categories!);
      } else {
        debugPrint("Failed to load categories for ${format.productFormat}");
        // Add empty list to maintain index alignment
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addCategoryList([]);
      }
    }

    debugPrint("Category loading completed in order");
  }

  Future<void> fetchHomeBanner() async {
    final formats = Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .formats!;

    debugPrint("Fetching banners for ${formats.length} formats in order");

    // Fetch banners sequentially to maintain correct order
    for (int i = 0; i < formats.length; i++) {
      final format = formats[i];
      debugPrint("Fetching banners for format ${i}: ${format.productFormat}");

      final response = await ApiProvider.instance
          .fetchHomeBanner(format.productFormat ?? '');

      if (response.status ?? false) {
        debugPrint(
            "Loaded ${response.banners?.length ?? 0} banners for ${format.productFormat}");
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addBannerList(response.banners!);
      } else {
        debugPrint("Failed to load banners for ${format.productFormat}");
        // Add empty list to maintain index alignment
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addBannerList([]);
      }
    }

    debugPrint("Banner loading completed in order");
  }

  Future<void> fetchHomeSection() async {
    final formats = Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .formats!;

    // Fetch all sections in parallel
    final List<Future<void>> sectionFutures = formats.map((format) async {
      final response = await ApiProvider.instance
          .fetchHomeSections(format.productFormat ?? '');

      if (response.status ?? false) {
        switch (format.productFormat) {
          case 'e-book':
            Provider.of<CommonProvider>(
                    Navigation.instance.navigatorKey.currentContext!,
                    listen: false)
                .setEbookHomeSections(response.sections!);
            break;
          case 'magazine':
            Provider.of<CommonProvider>(
                    Navigation.instance.navigatorKey.currentContext!,
                    listen: false)
                .setMagazineHomeSections(response.sections!);
            break;
          case 'enotes':
          case 'e-notes':
          case 'E-Notes':
            Provider.of<CommonProvider>(
                    Navigation.instance.navigatorKey.currentContext!,
                    listen: false)
                .setEnotesHomeSections(response.sections!);
            break;
        }
      } else {
        debugPrint(
            "Failed to load section for format: ${format.productFormat}");
      }
    }).toList();

    await Future.wait(sectionFutures);
  }

  Future<void> fetchBookmarks() async {
    final response = await ApiProvider.instance.fetchBookmark();
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setToBookmarks(response.items ?? []);
    }
  }

  Future<void> fetchCupons() async {
    final reponse = await ApiProvider.instance.fetchDiscount();
    if (reponse.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCupons(reponse.cupons ?? []);
    }
  }

  void fetchProfile() async {
    final response = await ApiProvider.instance.getProfile();
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setProfile(response.profile!);
    }
  }
}
