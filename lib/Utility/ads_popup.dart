import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/navigator.dart';

class AdsPopup extends StatelessWidget {
  const AdsPopup({
    super.key,
    required this.adCount,
  });
  final int adCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (adCount == 1)
                  Image.network(
                    'https://tratri.in/assets/images/300x600-1.jpg',
                    fit: BoxFit.contain,
                    height: 80.h,
                    width: 100.w,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80.h,
                        color: Colors.grey[900],
                        child: Center(
                            child: Text('Ad Image Not Available',
                                style: TextStyle(color: Colors.white))),
                      );
                    },
                  ),
                if (adCount == 2)
                  Column(
                    children: [
                      Image.network(
                        'https://tratri.in/assets/images/336x280-1.jpg',
                        fit: BoxFit.contain,
                        height: 40.h,
                        width: 100.w,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 40.h,
                            color: Colors.grey[900],
                            child: Center(
                                child: Text('Ad Image Not Available',
                                    style: TextStyle(color: Colors.white))),
                          );
                        },
                      ),
                      Image.network(
                        'https://tratri.in/assets/images/336x280-2.jpg',
                        fit: BoxFit.contain,
                        height: 40.h,
                        width: 100.w,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 40.h,
                            color: Colors.grey[900],
                            child: Center(
                                child: Text('Ad Image Not Available',
                                    style: TextStyle(color: Colors.white))),
                          );
                        },
                      ),
                    ],
                  ),
                if (adCount == 3)
                  Column(
                    children: [
                      for (int i = 1; i <= 3; i++)
                        Image.network(
                          'https://tratri.in/assets/images/320x180-$i.jpg',
                          fit: BoxFit.contain,
                          height: 26.h,
                          width: 100.w,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 26.h,
                              color: Colors.grey[900],
                              child: Center(
                                  child: Text('Ad Image Not Available',
                                      style: TextStyle(color: Colors.white))),
                            );
                          },
                        ),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
            top: 1.h,
            right: 1.w,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.black, size: 24.sp),
              onPressed: () => Navigation.instance.goBack(),
            ),
          ),
        ],
      ),
    );
  }
}
