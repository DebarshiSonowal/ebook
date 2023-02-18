
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';
import '../../Model/book_details.dart';
import '../../Model/home_banner.dart';
import '../Routes/Navigation Page/book_info.dart';

class BookPublishinDetails extends StatelessWidget {
  final Book bookDetails;

  final BookInfo widget;

  BookPublishinDetails(this.bookDetails, this.widget);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 20.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'RATINGS',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    // fontSize: 2.h,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              AbsorbPointer(
                child: RatingBar.builder(
                    itemSize: 5.w,
                    initialRating: bookDetails.average_rating ?? 3,
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
                    onRatingUpdate: (rating) {}),
              ),
              Text(
                '(${bookDetails.average_rating?.toInt()})',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                  // fontSize: 2.h,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'LENGTH',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    // fontSize: 2.h,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                bookDetails?.book_format == "magazine"
                    ? "${bookDetails.articles?.length} articles"
                    : '${bookDetails.length} pages | ${bookDetails.total_chapters} chapters',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  // fontSize: 2.h,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'LANGUAGE',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    // fontSize: 2.h,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                '${bookDetails.language}',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  // fontSize: 2.h,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'FORMAT',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    // fontSize: 2.h,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                '${bookDetails.book_format}',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  // fontSize: 2.h,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'PUBLISHER',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    // fontSize: 2.h,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigation.instance.navigate('/writerInfo',
                      args: bookDetails.contributor_id);
                },
                child: Text(
                  '${bookDetails.publisher}',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    // fontSize: 2.h,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'RELEASED',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    fontSize: 2.h,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                bookDetails.released_date ?? "",
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  // fontSize: 2.h,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}