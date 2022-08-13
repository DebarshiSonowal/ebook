import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

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
                height: 170,
                width: 200,
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Text('Ebook'),
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
    initiateSplash();
    fetchFormats();
  }

  void initiateSplash() {
    Future.delayed(const Duration(seconds: ConstanceData.splashTime), () {
      if (Storage.instance.isLoggedIn) {
        Navigation.instance.navigateAndRemoveUntil('/main');
      } else if (Storage.instance.isOnBoarding) {
        Navigation.instance.navigateAndRemoveUntil('/main');
      } else {
        Navigation.instance.navigateAndRemoveUntil('/login');
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
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addHomeSection(response.sections!);
      }
    }
  }
}
