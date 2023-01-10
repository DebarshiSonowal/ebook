import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';
import '../../Model/book_details.dart';
import '../../Storage/data_provider.dart';
import 'article_item_card.dart';
import 'blurred_card_item.dart';

class magazineViewSection extends StatelessWidget {
  const magazineViewSection({
    Key? key,
    required this.bookDetails,
  }) : super(key: key);

  final BookDetailsModel? bookDetails;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            SizedBox(
              height: 3.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: bookDetails?.profile_pic ?? "",
                  height: 15.h,
                  width: 35.w,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 4.w,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookDetails?.title ?? '',
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        bookDetails?.description ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              width: 9.w,
              child: Divider(
                color: Colors.white,
                thickness: 0.09.h,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (cont, count) {
                var current = bookDetails?.articles![count];
                return count >= 1 &&
                    Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey
                            .currentContext ??
                            context,
                        listen: true)
                        .profile ==
                        null
                    ? BlurredItemCard(
                    bookDetails: bookDetails,
                    context: context,
                    current: current,
                    count: count)
                    : articleitemcard(
                  bookDetails: bookDetails,
                  context: context,
                  current: current,
                  count: count,
                );
              },
              separatorBuilder: (cont, count) {
                return Container(
                  height: 1.h,
                  // margin: EdgeInsets.symmetric(vertical: 1.h),
                  // child: Divider(
                  //   color: Colors.black,
                  //   thickness: 0.09.h,
                  // ),
                );
              },
              itemCount: bookDetails?.articles?.length ?? 0,
            ),
            SizedBox(
              height: 1.h,
            ),
            // Divider(
            //   color: Colors.black,
            //   thickness: 0.09.h,
            // ),
          ],
        ),
      ),
    );
  }
}