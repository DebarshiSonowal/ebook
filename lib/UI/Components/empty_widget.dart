import 'package:ebook/Constants/constance_data.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ConstanceData.emptyImage,
            fit: BoxFit.fill,
            height: 14.h,
            width: 24.w,
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            "Oops! You haven't started reading",
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
