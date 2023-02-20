import 'package:ebook/UI/Components/tags_section.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';
import '../../Model/home_banner.dart';

class ScrollableContent extends StatelessWidget {
  const ScrollableContent({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Book data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),
            GestureDetector(
              onTap: () {
                Navigation.instance.navigate('/bookInfo', args: data.id);
              },
              child: Text(
                data.title ?? "NA",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(color: Colors.white),
              ),
            ),
            SizedBox(height: 0.5.h),
            GestureDetector(
              onTap: () {
                print("Contributor 2 is ${data.magazine_id}");
                Navigation.instance
                    .navigate('/writerInfo', args: '${data.contributor_id},${data.magazine_id}');
              },
              child: Text(
                data.writer ?? "NA",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.blue),
              ),
            ),

            Row(
              children: [
                IgnorePointer(
                  ignoring: true,
                  child: RatingBar.builder(
                      itemSize: 6.w,
                      initialRating: data.average_rating ?? 0,
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
                Text(
                  " (${data.total_rating})",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Text(
                  data.book_format == "magazine"
                      ? "${data.no_of_articles ?? 0} articles"
                      : "${data.length} pages",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Colors.white),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  "${data.language}",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(5),
                // decoration: ,
                child: Text(
                  data.selling_price?.toStringAsFixed(2).toString() == '0.00'
                      ? 'FREE'
                      : 'Rs. ${data.selling_price?.toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontSize: 1.5.h,
                    color:
                    data.selling_price?.toStringAsFixed(2).toString() ==
                        '0.00'
                        ? Colors.green
                        : Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 0.7.h),
            TagsSection(data: data),
            SizedBox(height: 0.7.h),
            data.awards!.isNotEmpty
                ? Text(
              "${data.awards![0].name} Winner",
              style: Theme.of(context).textTheme.headline5,
            )
                : Container(),
            SizedBox(height: 0.7.h),
            Text(
              "${(data.short_description ?? "").trim()}",
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 0.8.h),

            // SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }
}