import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

import '../../Model/home_banner.dart';

class bookBaritem extends StatelessWidget {
  const bookBaritem({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Book data;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: Container(
        height: 20.h,
        width: 70.w,
        decoration: const BoxDecoration(
          // color: Colors.transparent,
          color: Color(0xff121212),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                decoration: const BoxDecoration(
                  // color: ConstanceData.cardBookColor,
                  color: Colors.transparent,
                  // color: Colors.green,
                  // image: DecorationImage(
                  //   image:
                  //   fit: BoxFit.fill,
                  // ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: data.profile_pic ?? '',
                  fit: BoxFit.contain,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: const BoxDecoration(
                  // color: ConstanceData.cardBookColor,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                            // fontSize: 2.5.h,
                            color: Colors.white,
                          ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Text(
                      data.writer ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            // fontSize: 1.5.h,
                            color: Colors.white,
                          ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    IgnorePointer(
                      child: RatingBar.builder(
                          itemSize: 4.w,
                          initialRating: data.average_rating??0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          // itemPadding:
                          //     EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 10,
                              ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          }),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    // Card(
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(5.0),
                    //   ),
                    //   color: Colors.white,
                    //   child: Container(
                    //     padding: const EdgeInsets.all(5),
                    //     // decoration: ,
                    //     child: Text(
                    //       data.selling_price?.toStringAsFixed(2) == "0.00"
                    //           ? "FREE"
                    //           : 'Rs. ${data.selling_price?.toStringAsFixed(2)}',
                    //       maxLines: 1,
                    //       overflow: TextOverflow.ellipsis,
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .headline5
                    //           ?.copyWith(
                    //             // fontSize: 1.5.h,
                    //             color: data.selling_price?.toStringAsFixed(2) ==
                    //                     "0.00"
                    //                 ? Colors.green
                    //                 : Colors.black,
                    //             fontWeight:
                    //                 data.selling_price?.toStringAsFixed(2) ==
                    //                         "0.00"
                    //                     ? FontWeight.bold
                    //                     : FontWeight.normal,
                    //           ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
