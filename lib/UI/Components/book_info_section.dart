import 'package:ebook/Model/bookmark.dart';
import 'package:ebook/UI/Components/scrollable_content.dart';
import 'package:ebook/UI/Components/tags_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Model/home_banner.dart';
import 'buttons_pop_up_info.dart';
import 'close_button.dart';

class BookInfoSection extends StatelessWidget {
  const BookInfoSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Book data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 34.h,
      width: double.infinity,
      child: Container(
        // height: 200,
        // width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        color: ConstanceData.secondaryColor.withOpacity(0.97),
        child: Column(
          children: [
            ScrollableContent(data: data),
            Column(
              children: [
                data.book_format == "magazine"
                    ? Container()
                    : SizedBox(
                        width: double.infinity,
                        height: 4.5.h,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigation.instance.navigate('/bookDetails',
                                  args: data.id ?? 0);
                              // if (data.book_format == "magazine") {
                              //   Navigation.instance.navigate(
                              //       '/magazineArticles',
                              //       args: data.id ?? 0);
                              // } else {
                              //   Navigation.instance.navigate('/bookDetails',
                              //       args: data.id ?? 0);
                              //   // Navigation.instance.navigate('/reading',
                              //   //     args: data.id ?? 0);
                              // }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            child: Text(
                              data.book_format == "magazine"
                                  ? 'View Articles'
                                  : 'Preview',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    fontSize: 2.h,
                                    color: Colors.black,
                                  ),
                            )),
                      ),
                SizedBox(height: 0.5.h),
                ButtonsPopUpInfo(data: data),
              ],
            )
          ],
        ),
      ),
    );
  }
}




