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
import 'ios_compliance_helper.dart';

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





  @override
  Widget build(BuildContext context) {
    // Check if iOS
    bool isIOS = !kIsWeb && Platform.isIOS;

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 4.5.h,
        child: Row(
          children: [
            // Hide Buy Now button on iOS
            !isIOS && Platform.isAndroid
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
                    onTap();
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
            // Show info button on iOS instead of Buy Now
            isIOS && !isBought
                ? Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  IOSComplianceHelper.showPurchaseInfoDialog(context);
                },
                icon: Icon(Icons.info_outline, color: Colors.white, size: 18.sp),
                label: Text(
                  'Purchase Info',
                  style:
                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange.shade600),
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