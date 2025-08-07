import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Storage/common_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    fetchFormats();
    initiateSplash();
  }

  void initiateSplash() {
    Future.delayed(const Duration(seconds: ConstanceData.splashTime), () {
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
    }
  }

  Future<void> fetchCategory() async {
    final formats = Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .formats!;

    // Fetch all categories in parallel
    final List<Future<void>> categoryFutures = formats.map((format) async {
      final response = await ApiProvider.instance
          .fetchBookCategory(format.productFormat ?? '');
      if (response.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addCategoryList(response.categories!);
      }
    }).toList();

    await Future.wait(categoryFutures);
  }

  Future<void> fetchHomeBanner() async {
    final formats = Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .formats!;

    // Fetch all banners in parallel
    final List<Future<void>> bannerFutures = formats.map((format) async {
      final response = await ApiProvider.instance
          .fetchHomeBanner(format.productFormat ?? '');
      if (response.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addBannerList(response.banners!);
      }
    }).toList();

    await Future.wait(bannerFutures);
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
