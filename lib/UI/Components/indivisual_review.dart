import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

import '../../Model/review.dart';

class IndivisualReview extends StatelessWidget {
  const IndivisualReview({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Review data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 20.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${data.subscriber}',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.white
                  // fontSize: 2.h,
                  // color: Colors.grey.shade200,
                ),
              ),
              RatingBar.builder(
                  itemSize: 5.w,
                  initialRating: data.rating ?? 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  // itemPadding:
                  //     EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 10,
                  ),
                  onRatingUpdate: (rating) {}),
            ],
          ),
          SizedBox(
            height: 1.5.h,
          ),
          Text(
            '${data.content}',
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(
              // fontSize: 2.h,
              // color: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }
}