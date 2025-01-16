import 'package:ebook/Model/home_banner.dart';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';
import 'book_item.dart';

class BooksSection extends StatelessWidget {
  final Function(Book data) show;
  const BooksSection(
      {required this.title, required this.list, required this.show});

  final String title;
  final List<Book> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: ConstanceData.secondaryColor,
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 2.w),
      height: 39.5.h,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 9.h,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 80.w,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 19.sp,
                        ),
                  ),
                ),
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
                  return BookItem(data: data, index: count, show: show);
                }),
          ),
        ],
      ),
    );
  }
}
