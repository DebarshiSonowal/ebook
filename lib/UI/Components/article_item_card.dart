import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';
import '../../Model/article.dart';
import '../../Model/book_details.dart';
import '../../Model/home_banner.dart';

class articleitemcard extends StatelessWidget {
  const articleitemcard({
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
        Navigation.instance.navigate('/magazineDetails',
            args: "${bookDetails?.id},${count},${bookDetails?.profile_pic}");
      },
      child: Container(
        width: double.infinity,
        // height: 10.h,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.white, //                   <--- border width here
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                  ),
                  Text(
                    current?.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white60,
                          fontSize: 13.sp,
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
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
    );
  }
}
