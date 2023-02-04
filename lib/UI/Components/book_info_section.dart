import 'package:ebook/Model/bookmark.dart';
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
                              if (data.book_format == "magazine") {
                                Navigation.instance.navigate(
                                    '/magazineArticles',
                                    args: data.id ?? 0);
                              } else {
                                Navigation.instance.navigate('/bookDetails',
                                    args: data.id ?? 0);
                                // Navigation.instance.navigate('/reading',
                                //     args: data.id ?? 0);
                              }
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
                Navigation.instance
                    .navigate('/writerInfo', args: data.contributor_id);
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
                      initialRating: data.average_rating ?? 3,
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
                  'Rs. ${data.selling_price?.toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontSize: 1.5.h,
                        color: Colors.black,
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

class BookInfoSectionBookmark extends StatelessWidget {
  const BookInfoSectionBookmark({
    Key? key,
    required this.data,
  }) : super(key: key);

  final BookmarkItem data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              // height: 200,
              // width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              color: ConstanceData.secondaryColor,
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

                  // GestureDetector(
                  //   onTap: () {
                  //     Navigation.instance
                  //         .navigate('/writerInfo', args: data.);
                  //   },
                  //   child: Text(
                  //     data.writer ?? "NA",
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .headline5
                  //         ?.copyWith(color: Colors.blue),
                  //   ),
                  // ),

                  Row(
                    children: [
                      IgnorePointer(
                        ignoring: true,
                        child: RatingBar.builder(
                            itemSize: 6.w,
                            initialRating: data.average_rating ?? 3,
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
                            ? "${data.total_chapters ?? 0} chapters"
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
                        'Rs. ${data.selling_price?.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              fontSize: 1.5.h,
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.7.h),
                  TagsSectionBookmark(data: data),
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
                  data.book_format == "magazine"
                      ? Container()
                      : SizedBox(
                          width: double.infinity,
                          height: 4.5.h,
                          child: ElevatedButton(
                              onPressed: () {
                                if (data.book_format == "magazine") {
                                  Navigation.instance.navigate(
                                      '/magazineArticles',
                                      args: data.id ?? 0);
                                } else {
                                  Navigation.instance.navigate('/bookDetails',
                                      args: data.id ?? 0);
                                  // Navigation.instance.navigate('/reading',
                                  //     args: data.id ?? 0);
                                }
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
                  ButtonsPopUpInfoBookmark(data: data),
                  // SizedBox(height: 1.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
