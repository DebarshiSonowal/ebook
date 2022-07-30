import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
      body: Container(
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
            SpinKitFoldingCube(
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
  }

  void initiateSplash() {
    Future.delayed(Duration(seconds: ConstanceData.splashTime), () {
      if (Storage.instance.isLoggedIn) {
        Navigation.instance.navigateAndRemoveUntil('/main');
      } else if (Storage.instance.isOnBoarding) {
        Navigation.instance.navigateAndRemoveUntil('/main');
      } else {
        Navigation.instance.navigateAndRemoveUntil('/login');
      }
    });
  }
}
