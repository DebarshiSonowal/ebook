import 'package:ebook/UI/Components/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../Constants/constance_data.dart';

class Librarypage extends StatefulWidget {
  const Librarypage({Key? key}) : super(key: key);

  @override
  State<Librarypage> createState() => _LibrarypageState();
}

class _LibrarypageState extends State<Librarypage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstanceData.primaryColor,
      height: double.infinity,
      width: double.infinity,
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
