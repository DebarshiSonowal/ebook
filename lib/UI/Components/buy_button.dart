import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:pay/pay.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Networking/api_provider.dart';
import '../../Storage/app_storage.dart';
import '../../Storage/data_provider.dart';

class BuyButton extends StatelessWidget {
  final int id;
  bool isBought;
  Function onTap;

  final _paymentConfiguration = PaymentConfiguration.fromJsonString(
      '{"provider": "apple_pay", "data": {"merchantIdentifier": "merchant.xamtech.tratri", "displayName": "Tratri", "merchantCapabilities": ["3DS", "debit", "credit"], "supportedNetworks": ["amex", "visa", "discover", "masterCard"], "countryCode": "IN", "currencyCode": "INR"}}');

  BuyButton(this.id, this.onTap, this.isBought);

  List<PaymentItem> get paymentItems => [
        PaymentItem(
          label: 'Book Purchase',
          amount: '10.00',
          status: PaymentItemStatus.final_price,
        )
      ];

  void checkIfValid(String? orderId) {
    // Handle payment completion logic here
    if (orderId != null) {
      // Process the order
    }
  }

  void _showPaymentOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 5,
          child: Container(
            width: 85.w,
            padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.blue.shade50],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Payment Option',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 2.5.h),
                // Regular Payment Button
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 9.w, vertical: 0.5.h),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onTap();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: EdgeInsets.symmetric(vertical: 0.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 2,
                    ),
                    child: Center(
                      child: Text(
                        'Razorpay',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                // Divider with text
                Row(
                  children: [
                    Expanded(
                        child:
                            Divider(color: Colors.grey.shade300, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Text(
                        'Or pay with',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Expanded(
                        child:
                            Divider(color: Colors.grey.shade300, thickness: 1)),
                  ],
                ),
                SizedBox(height: 2.h),
                // Apple Pay Button
                Container(
                  width: double.infinity,
                  height: 4.h, // Reduced height from 5.h to 4.h
                  padding: EdgeInsets.symmetric(
                      horizontal: 10
                          .w), // Increased padding to make content area smaller
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ApplePayButton(
                    paymentConfiguration: _paymentConfiguration,
                    paymentItems: paymentItems,
                    style: ApplePayButtonStyle.black,
                    type: ApplePayButtonType.buy,
                    onPaymentResult: (result) {
                      Navigator.pop(context);
                      debugPrint("Payment result: $result");
                      checkIfValid(null);
                    },
                    loadingIndicator: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.5, // Reduced stroke width
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                // Cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 0.8.h),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 4.5.h,
        child: Row(
          children: [
            Platform.isAndroid
                ? Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if ((Provider.of<DataProvider>(
                                        Navigation.instance.navigatorKey
                                                .currentContext ??
                                            context,
                                        listen: false)
                                    .profile !=
                                null) &&
                            Storage.instance.isLoggedIn) {
                          if (!kIsWeb && Platform.isIOS) {
                            _showPaymentOptionsDialog(context);
                          } else {
                            onTap();
                          }
                        } else {
                          ConstanceData.showAlertDialog(context);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      child: Text(
                        'Buy Now',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                ),
                      ),
                    ),
                  )
                : Container(),
            isBought
                ? Container()
                : SizedBox(
                    width: 1.w,
                  ),
            isBought
                ? Container()
                : Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: false)
                                .cartData
                                ?.items
                                .where((element) =>
                                    (element.item_id ?? 0) == (id ?? 0))
                                .isNotEmpty ??
                            false) {
                          Navigation.instance.navigate("/cartPage");
                        } else {
                          if ((Provider.of<DataProvider>(
                                          Navigation.instance.navigatorKey
                                                  .currentContext ??
                                              context,
                                          listen: false)
                                      .profile !=
                                  null) &&
                              Storage.instance.isLoggedIn) {
                            addtocart(context, id);
                          } else {
                            ConstanceData.showAlertDialog(context);
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      child: Text(
                        (Provider.of<DataProvider>(
                                        Navigation.instance.navigatorKey
                                                .currentContext ??
                                            context,
                                        listen: false)
                                    .cartData
                                    ?.items
                                    .where((element) =>
                                        (element.item_id ?? 0) == (id ?? 0))
                                    .isNotEmpty ??
                                false)
                            ? (Platform.isAndroid ? 'Go To List' : 'Go To Cart')
                            : (Platform.isAndroid
                                ? 'Add To Cart'
                                : 'Add To List'),
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void addtocart(context, id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.addToCart(id, '1');
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setToCart(response.cart?.items ?? []);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCartData(response.cart!);
      Navigation.instance.goBack();
      showSuccess(context);
    } else {
      Navigation.instance.goBack();
      showError(context);
    }
  }

  void showSuccess(context) {
    Fluttertoast.showToast(
        msg: Platform.isIOS
            ? "The following book is added to list"
            : "The following book is added to cart");
  }

  void showError(context) {
    Fluttertoast.showToast(msg: "Something went wrong, please try again");
  }
}
