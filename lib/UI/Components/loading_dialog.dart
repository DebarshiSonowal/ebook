import 'package:ebook/Constants/constance_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'package:sizer/sizer.dart';

class LoadingDialog extends StatelessWidget {
  LoadingDialog() {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: ConstanceData.primaryColor,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class ReadingDialog extends StatelessWidget {
  ReadingDialog() {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              height: 22.h,
              // width: 44.w,
              // padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  // color: Colors.white,
                  // shape: BoxShape.circle,
                  ),
              child: Center(
                child: Lottie.asset(
                  'assets/animation/reading.json',
                  height: 22.h,
                  width: 44.w,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              "Loading",
              style: Theme.of(context)
                  .textTheme
                  .headline5,
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
