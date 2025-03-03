import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:sizer/sizer.dart';

// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/tap_bounce_container.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Model/article.dart';
import '../../Model/book_details.dart';
import '../../Model/home_banner.dart';

class BlurredItemCard extends StatelessWidget {
  const BlurredItemCard({
    Key? key,
    required this.bookDetails,
    required this.context,
    required this.current,
    required this.count,
  }) : super(key: key);

  final Book? bookDetails;
  final BuildContext context;
  final Article? current;
  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (bookDetails?.is_bought ?? false) {
          Dialogs.materialDialog(
              msg: 'You have to be logged in to view this',
              title: "Want to Read This?",
              color: Colors.white,
              titleStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              msgStyle: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
              ),
              context: context,
              actions: [
                IconsButton(
                  onPressed: () {
                    Navigation.instance.goBack();
                  },
                  text: 'Cancel',
                  iconData: Icons.close,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
                IconsOutlineButton(
                  onPressed: () {
                    Navigation.instance.navigate('/login');
                  },
                  text: 'Log In',
                  color: Colors.green,
                  iconData: Icons.login,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ]);
        } else {
          Fluttertoast.showToast(
              msg: "You will have to buy this magazine before reading");
        }
      },
      child: ClipRect(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              // height: 10.h,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color:
                      Colors.white, //                   <--- border width here
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.5.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 45.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookDetails?.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.white, fontSize: 17.sp),
                        ),
                        Text(
                          current?.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        // SizedBox(
                        //   height: 0.5.h,
                        // ),
                        Text(
                          current?.short_note ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white60,
                                fontSize: 13.sp,
                                // fontWeight: FontWeight.bold,
                              ),
                        ),
                        // Spacer(),
                      ],
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl: current?.profile_pic ?? "",
                    height: 10.h,
                    width: 25.w,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: 150,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.7, sigmaY: 0.7),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
