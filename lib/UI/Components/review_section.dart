import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

import '../../Model/review.dart';
import '../Routes/Navigation Page/book_info.dart';
import 'indivisual_review.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviews.length>5?5:reviews.length,
      itemBuilder: (cont, index) {
        var data = reviews[index];
        return IndivisualReview(data: data);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 0.5.h),
          child: Divider(
            color: Colors.white,
            height: 0.1.h,
          ),
        );
      },
    );
  }
}