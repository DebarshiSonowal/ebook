import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

class CuponsCard extends StatelessWidget {
  const CuponsCard({Key? key, required this.ontap, required this.cupon})
      : super(key: key);
  final Function ontap;
  final String cupon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Wanna save more ?',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            GestureDetector(
              onTap: () => ontap(),
              child: Text(
                cupon != "" ? cupon : 'Apply Coupon',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
