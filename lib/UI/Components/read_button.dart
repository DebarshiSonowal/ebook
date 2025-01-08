import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Storage/app_storage.dart';

class ReadButton extends StatelessWidget {
  final int id;
  final String format, profile_pic;
  final bool isBought;

  const ReadButton(
      {super.key,
      required this.id,
      required this.format,
      required this.isBought,
      required this.profile_pic});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 5.h,
      child: ElevatedButton(
        onPressed: () {
          // Navigation.instance.navigate('/bookInfo');
          // Navigation.instance.navigate('/bookDetails', args: id ?? 0);
          // Navigation.instance.navigate('/reading', args: id ?? 0);
          if ((Platform.isAndroid) ||
              (Platform.isIOS && Storage.instance.isLoggedIn)) {
            if (format == "magazine") {
              Navigation.instance.navigate('/magazineArticles', args: id ?? 0);
            } else {
              Navigation.instance
                  .navigate('/bookDetails', args: '${id ?? 0},${profile_pic}');
            }
          } else {
            ConstanceData.showAlertDialog(context);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        child: Text(
          format == 'magazine'
              ? "View Articles"
              : isBought
                  ? 'Read Book'
                  : 'Read Preview',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                // fontSize: 2.5.h,
                color: Colors.blue,
              ),
        ),
      ),
    );
  }
}
