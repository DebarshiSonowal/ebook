import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

import '../../Model/discount.dart';

class secondPartCard extends StatelessWidget {
  const secondPartCard({
    Key? key,
    required this.current,
  }) : super(key: key);

  final Discount current;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Text(
                  "Coupon Code",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  "${current.coupon}",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Color(0xff358f8b),
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  "Valid Till -",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.black,
                        fontSize: 14.sp,
                      ),
                ),
                Text(
                  " ${current.valid_to}",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.black,
                        fontSize: 14.sp,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
