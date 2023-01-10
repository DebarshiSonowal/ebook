import 'package:ebook/Model/home_banner.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'book_item.dart';

class BooksSection extends StatelessWidget {
  final Function(Book data) show;
  const BooksSection({required this.title, required this.list, required this.show});

  final String title;
  final List<Book> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: ConstanceData.secondaryColor,
      padding: EdgeInsets.symmetric(vertical: 0.h,horizontal: 2.w),
      height: 37.h,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height:6.h,
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
                  return BookItem(data: data,index:count,show:show);
                }),
          ),
        ],
      ),
    );

  }


}

