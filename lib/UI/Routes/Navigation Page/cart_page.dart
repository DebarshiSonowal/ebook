import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:ebook/Model/cart_item.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Model/razorpay_key.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/UI/Components/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:quantity_input/quantity_input.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/navigator.dart';
import '../../../Networking/api_provider.dart';
import '../../Components/cart_page_item.dart';
import '../../Components/cupons_card.dart';
import '../../Components/payment_address_card.dart';
import '../../Components/shop_now_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String cupon = '';
  final _razorpay = Razorpay();
  double tempTotal = 1.0;
  String temp_order_id = "";

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey.shade200,
        title: Text(
          "Cart",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline1?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Consumer<DataProvider>(builder: (cont, data, _) {
          return data.cartData == null
              ? Container()
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.5.h, horizontal: 3.w),
                        child: SingleChildScrollView(
                          child: Column(
                            // shrinkWrap: true,
                            children: [
                              data.items.isEmpty
                                  ? Container(
                                      height: 40.h,
                                      child: EmptyWidget(
                                        color: Colors.white,
                                        text:
                                            "You have not bought anything yet",
                                      ),
                                    )
                                  : CuponsCard(
                                      cupon: cupon,
                                      ontap: () async {
                                        final response = await Navigation
                                            .instance
                                            .navigate('/couponPage');
                                        if (response != null) {
                                          setState(() {
                                            cupon = response;
                                          });
                                        }
                                      }),
                              data.items.isEmpty
                                  ? const shopNowButton()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: data.items.length,
                                      itemBuilder: (cont, count) {
                                        var simpleIntInput = 1;
                                        var current = data.items[count];
                                        return CartPageItem(
                                          data: data,
                                          current: current,
                                          simpleIntInput: simpleIntInput,
                                          removeItem: (int id) {
                                            removeItem(id);
                                          },
                                        );
                                      })
                            ],
                          ),
                        ),
                      ),
                    ),
                    data.items.isEmpty
                        ? Container()
                        : PaymentAddressCard(
                            data: data,
                            getTotalAmount: (data) => getTotalAmount(data),
                            initiatePaymentProcess: initiatePaymentProcess,
                          ),
                  ],
                );
        }),
      ),
    );
  }

  getTotalAmount(Cart data) {
    // double price = 0;

    return data.total_price;
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    Future.delayed(Duration.zero, () {
      fetchCartItems();
    });
  }

  void fetchCartItems() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.fetchCart();
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setToCart(response.cart?.items ?? []);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCartData(response.cart!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  void initiatePaymentProcess() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.fetchRazorpay();
    if (response.status ?? false) {
      if (cupon == null || cupon == "") {
        initateOrder(response.razorpay!);
      } else {
        applyCoupon(cupon, response.razorpay!);
      }
    } else {
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Something went wrong",
      );
    }
  }

  void initateOrder(RazorpayKey razorpay) async {
    final response = await ApiProvider.instance.createOrder(cupon, null);
    if (response.status ?? false) {
      tempTotal = response.order?.total ?? 0;
      temp_order_id = response.order?.order_id.toString() ?? "";
      startPayment(razorpay, response.order?.total, response.order?.order_id,
          response.order?.subscriber_id);
    } else {
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Something went wrong",
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(
        'success ${response.paymentId} ${response.orderId} ${response.signature}');
    handleSuccess(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    var resp = json.decode(response.message!);
    print('error ${resp['error']['description']} ${response.code} ');
    Navigation.instance.goBack();
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      text: resp['error']['description'] ?? "Something went wrong",
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  void startPayment(RazorpayKey razorpay, double? total, id, customer_id) {
    var options = {
      'key': razorpay.api_key,
      'amount': total! * 100,
      // 'order_id': id,
      'name':
          '${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.f_name} ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.l_name}',
      'description': 'Books',
      'prefill': {
        'contact': Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .profile
            ?.mobile,
        'email': Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .profile
            ?.email
      },
      'note': {
        'customer_id': customer_id,
        'order_id': id,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void removeItem(int id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.deleteCart(id);
    if (response.status ?? false) {
      Navigation.instance.goBack();
      fetchCartItems();
    } else {
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Enter proper credentials",
      );
    }
  }

  void handleSuccess(PaymentSuccessResponse response) async {
    final response1 = await ApiProvider.instance
        .verifyPayment(temp_order_id, response.paymentId, tempTotal ?? 1);
    if (response1.status ?? false) {
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Payment received Successfully",
      );
      fetchCartItems();
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Something went wrong",
      );
    }
  }

  void applyCoupon(String coupon, RazorpayKey razorpayKey) async {
    final response =
        await ApiProvider.instance.applyDiscount(coupon, tempTotal);
    if (response.success ?? false) {
      if (mounted) {
        setState(() {
          tempTotal = response.amount ?? tempTotal;
        });
        initateOrder(razorpayKey);
      } else {
        tempTotal = response.amount ?? tempTotal;
        initateOrder(razorpayKey);
      }
    } else {
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Something went wrong",
      );
    }
  }
}
