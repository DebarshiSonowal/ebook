import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Model/home_banner.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';
import '../../Constants/constance_data.dart';
import '../../Model/book.dart';
import 'book_item.dart';

class BooksSection extends StatelessWidget {
  BooksSection({required this.title, required this.list});

  final String title;
  final List<HomeBanner> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstanceData.secondaryColor,
      padding: EdgeInsets.symmetric(vertical: 0.2.h,horizontal: 2.w),
      height: 37.h,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 9.h,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Colors.white,
                      ),
                ),
                // Container(
                //   padding: EdgeInsets.all(5),
                //   child: Row(
                //     children: [
                //       Container(
                //           decoration: const BoxDecoration(
                //             color: Colors.blue,
                //             borderRadius: BorderRadius.only(
                //                 // topRight: Radius.circular(40.0),
                //                 // bottomRight: Radius.circular(40.0),
                //                 topLeft: Radius.circular(40.0),
                //                 bottomLeft: Radius.circular(40.0)),
                //           ),
                //           padding: const EdgeInsets.only(
                //               left: 4, right: 4, top: 4, bottom: 4),
                //           child: Text('All')),
                //       Container(
                //           padding: const EdgeInsets.only(
                //               right: 4, top: 4, bottom: 4),
                //           child: Text('Paid')),
                //       Container(
                //           padding: const EdgeInsets.only(
                //               right: 4, top: 4, bottom: 4),
                //           child: Text('Free')),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (cont, count) {
                  var data = list[count];
                  return BookItem(data: data,index:count);
                }),
          ),
        ],
      ),
    );

  }


}

