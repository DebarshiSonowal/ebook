import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
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
    return Scaffold(
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
    );
  }
}

class ReadingDialog extends StatelessWidget {
  final String? url;

  ReadingDialog(this.url) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              // height: 22.h,
              // width: 44.w,
              // padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  // color: Colors.white,
                  // shape: BoxShape.circle,
                  ),
              child: Center(
                child: url != null
                    ? CachedNetworkImage(
                        imageUrl: url!,
                        height: 30.h,
                        width: 44.w,

                        fit: BoxFit.fill,
                      )
                    : Lottie.asset(
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
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(
              height:1.h
            ),
            Text(
              "Loading",
              style: Theme.of(context).textTheme.headline5,
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
