import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../Constants/constance_data.dart';
import '../../Components/empty_widget.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
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
