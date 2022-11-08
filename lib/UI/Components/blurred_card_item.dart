import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Model/article.dart';
import '../../Model/book_details.dart';

class BlurredItemCard extends StatelessWidget {
  const BlurredItemCard({
    Key? key,
    required this.bookDetails,
    required this.context,
    required this.current,
    required this.count,
  }) : super(key: key);

  final BookDetailsModel? bookDetails;
  final BuildContext context;
  final Article? current;
  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // CachedNetworkImage(
                      //   imageUrl: bookDetails?.profile_pic ?? "",
                      //   height: 4.h,
                      //   width: 12.w,
                      //   fit: BoxFit.fill,
                      // ),
                      // SizedBox(
                      //   width: 2.w,
                      // ),
                      SizedBox(
                        width: 50.w,
                        child: Text(
                          bookDetails?.title ?? '',
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                      // Spacer(),
                      // Icon(
                      //   Icons.bookmark_border,
                      //   color: Colors.black54,
                      //   size: 5.h,
                      // ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              current?.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Text(
                              current?.short_note ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      CachedNetworkImage(
                        imageUrl: current?.profile_pic ?? "",
                        height: 10.h,
                        width: 25.w,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              width: 150,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.7, sigmaY: 0.7),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
