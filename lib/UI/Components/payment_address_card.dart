import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

import '../../Model/cart_item.dart';
import '../../Storage/data_provider.dart';

class PaymentAddressCard extends StatelessWidget {
  const PaymentAddressCard({
    Key? key,
    required this.data,
    required this.getTotalAmount,
    required this.initiatePaymentProcess,
    this.cupon,
    this.coins = 0,
    this.onUseCoinsTap,
    required this.discount,
  }) : super(key: key);

  final DataProvider data;
  final String? cupon;
  final String discount;
  final int coins;
  final Function(Cart data) getTotalAmount;
  final Function(int amount) initiatePaymentProcess;
  final VoidCallback? onUseCoinsTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(1.h),
        height: 12.h,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if ((cupon != null && cupon!.isNotEmpty) ||
                                coins != 0)
                              Text(
                                '₹${data.cartData!.total_price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                              ),
                            SizedBox(width: 1.w),
                            Text(
                              getTotalAmount(data.cartData!).toString() == "0"
                                  ? "Free"
                                  : '₹${int.parse(getTotalAmount(data.cartData!).toString()) - int.parse(discount)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.sp,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        if (discount != null && (discount != "0"))
                          Text(
                            'Discount Applied: $discount',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  color: Colors.amber,
                                  fontSize: 12.sp,
                                ),
                          ),

                        // if (cupon != null && (cupon?.isNotEmpty ?? false))
                        //   Text(
                        //     'Coupon Applied: $cupon',
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .displaySmall
                        //         ?.copyWith(
                        //           color: Colors.amber,
                        //           fontSize: 12.sp,
                        //         ),
                        //   )
                        // else if (coins != 0)
                        //   GestureDetector(
                        //     onTap: () => onUseCoinsTap,
                        //     child: Text(
                        //       'Using $coins Coins',
                        //       style: Theme.of(context)
                        //           .textTheme
                        //           .displaySmall
                        //           ?.copyWith(
                        //             color: Colors.amber,
                        //             fontSize: 16.sp,
                        //           ),
                        //     ),
                        //   ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Text(
                          'View Detailed Bill',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        initiatePaymentProcess(
                            int.parse(getTotalAmount(data.cartData!)));
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Proceed to Pay',
                          style:
                              TextStyle(fontSize: 15.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
