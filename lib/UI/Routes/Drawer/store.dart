import 'package:ebook/Constants/constance_data.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../Components/empty_widget.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstanceData.primaryColor,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animation/coming.json',
            height: 22.h,
            width: 44.w,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
