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
      fetchCategory();
      fetchHomeBanner();
      fetchHomeSection();
      fetchBookmarks();
      fetchCupons();
    }
  }

  void fetchCategory() async {
    for (var i in Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .formats!) {
      final response =
          await ApiProvider.instance.fetchBookCategory(i.productFormat ?? '');
      if (response.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addCategoryList(response.categories!);
      }
    }
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
        if (i.productFormat == 'ebook') {
          Provider.of<CommonProvider>(
                  Navigation.instance.navigatorKey.currentContext!,
                  listen: false)
              .setEbookHomeSections(response.sections!);
        } else if (i.productFormat == 'magazine') {
          Provider.of<CommonProvider>(
                  Navigation.instance.navigatorKey.currentContext!,
                  listen: false)
              .setMagazineHomeSections(response.sections!);
        } else if (i.productFormat == 'enotes') {
          Provider.of<CommonProvider>(
                  Navigation.instance.navigatorKey.currentContext!,
                  listen: false)
              .setEnotesHomeSections(response.sections!);
        }
      }
    }
  }

  void fetchBookmarks() async {
    final response = await ApiProvider.instance.fetchBookmark();
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setToBookmarks(response.items ?? []);
    }
  }

  void fetchCupons() async {
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
