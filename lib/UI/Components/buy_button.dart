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
                  _showPurchaseInfoDialog(context);
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
  void _showPurchaseInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5,
          child: Container(
            width: 90.w,
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Why can\'t I buy books?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.grey.shade700),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'To remain in compliance with App Store policies, you will no longer be able to buy books in this app. You can buy from our website or build a reading list in the app to track books to buy later.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 2.h),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog first
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IOSPurchaseInfoScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Learn more',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
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
}

// Add this method to your BuyButton class to show the initial dialog


// New Screen Widget - Add this as a separate file or in your project
class IOSPurchaseInfoScreen extends StatelessWidget {
  const IOSPurchaseInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'DISCOVER NEW BOOKS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Icon
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4.h),
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade300,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 25.w,
                      height: 35.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                              (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Row(
                              children: [
                                Container(
                                  width: 5.w,
                                  height: 5.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(1.w),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 1.5.w,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(0.5.w),
                                        ),
                                      ),
                                      SizedBox(height: 1.w),
                                      Container(
                                        height: 1.w,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(0.5.w),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8.w,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Intro Text
            Text(
              'To remain in compliance with Apple\'s updated App Store policies, readers will no longer be able to buy books through this app. You can always add to your library by buying books through tratri.in/shop in in a web browser.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 4.h),

            // Divider
            Divider(color: Colors.grey.shade700, thickness: 1),
            SizedBox(height: 3.h),

            // Title
            Center(
              child: Text(
                'Three ways to get content\nto read on the app',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue.shade400,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(height: 3.h),

            // Divider
            Divider(color: Colors.grey.shade700, thickness: 1),
            SizedBox(height: 4.h),

            // Option 1
            _buildOption(
              number: '1',
              title: 'Build your reading list\nfrom the app',
              description:
              'You can still browse books in the app and add the ones that you are interested in to your list. When you are ready to buy, open your list through tratri.in in your web browser.',
            ),
            SizedBox(height: 4.h),

            // Divider
            Divider(color: Colors.grey.shade700, thickness: 1),
            SizedBox(height: 4.h),

            // Option 2
            _buildOption(
              number: '2',
              title: 'Shop from\ntratri.in/shop',
              description:
              'Go to tratri.in/shop in your web browser to shop for books. Any books you buy will be added to your library and can be read in the Tratri app.',
              showWebsite: true,
            ),
            SizedBox(height: 4.h),

            // Divider
            Divider(color: Colors.grey.shade700, thickness: 1),
            SizedBox(height: 4.h),

            // Option 3
            // _buildOption(
            //   number: '3',
            //   title: 'Subscribe to our\npremium service',
            //   description:
            //   'Subscribe to Tratri Premium and enjoy unlimited access to thousands of books directly from the app. To subscribe or learn more, visit tratri.in in your web browser.',
            // ),
            // SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required String number,
    required String title,
    required String description,
    bool showWebsite = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number Circle
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  height: 1.5,
                ),
              ),
              if (showWebsite) ...[
                SizedBox(height: 3.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    'tratri.in/shop',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}