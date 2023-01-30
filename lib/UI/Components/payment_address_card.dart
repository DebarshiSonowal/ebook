import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Model/cart_item.dart';
import '../../Storage/data_provider.dart';

class PaymentAddressCard extends StatelessWidget {
  const PaymentAddressCard({Key? key, required this.data, required this.getTotalAmount, required this.initiatePaymentProcess}) : super(key: key);
  final DataProvider data;
  final Function(Cart data) getTotalAmount;
  final Function initiatePaymentProcess;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(1.h),
        height: 10.h,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${getTotalAmount(data.cartData!)}',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          'View Detailed Bill',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        initiatePaymentProcess();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(
                            Colors.green),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(5.0),
                            side:
                            BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Proceed to Pay'),
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
