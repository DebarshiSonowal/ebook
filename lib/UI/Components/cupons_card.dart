import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Storage/data_provider.dart';

class CuponsCard extends StatelessWidget {
  const CuponsCard(
      {Key? key,
      required this.onCouponTap,
      required this.cupon,
      required this.coins,
      required this.onCoinsTap})
      : super(key: key);
  final Function onCouponTap, onCoinsTap;
  final String cupon;
  final int coins;

  @override
  Widget build(BuildContext context) {
    bool isCuponApplied = cupon.isNotEmpty;
    bool isCoinsApplied = coins > 0;

    return Card(
      elevation: 8,
      color: Colors.white10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 4.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Wanna save more?',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            GestureDetector(
              onTap: () => !isCoinsApplied ? onCouponTap() : () {},
              child: Opacity(
                opacity: isCoinsApplied ? 0.5 : 1.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    cupon != "" ? cupon : 'Apply Coupon',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => !isCuponApplied ? onCoinsTap() : null,
              child: Opacity(
                opacity: isCuponApplied ? 0.5 : 1.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.coins,
                        color: Colors.amber,
                        size: 18.sp,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Consumer<DataProvider>(builder: (context, data, _) {
                        return Text(
                          "${(data.rewardResult?.totalPoints ?? 0) - coins}",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
