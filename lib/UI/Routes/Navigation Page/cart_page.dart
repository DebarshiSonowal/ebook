import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:ebook/Model/cart_item.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Model/razorpay_key.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:quantity_input/quantity_input.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/navigator.dart';
import '../../../Networking/api_provider.dart';

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
        color: Colors.grey.shade200,
        child: Consumer<DataProvider>(builder: (cont, data, _) {
          return data.cartData == null
              ? Container()
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 3.w),
                        child: ListView(
                          // mainAxisSize: MainAxisSize.min,
                          shrinkWrap: true,
                          children: [
                            Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 2.5.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Wanna save more ?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.copyWith(color: Colors.black),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final response = await Navigation
                                            .instance
                                            .navigate('/couponPage');
                                        if (response != null) {
                                          setState(() {
                                            cupon = response;
                                          });
                                        }
                                      },
                                      child: Text(
                                        cupon != "" ? cupon : 'Apply Coupon',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.items.length,
                                itemBuilder: (cont, count) {
                                  var simpleIntInput = 1;
                                  var current = data.items[count];
                                  return Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 1.h, horizontal: 2.w),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 15.h,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                data.items.isNotEmpty
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white)),
                                                        height: 13.h,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    1.5.w),
                                                        width: 20.w,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: current
                                                                  .item_image ??
                                                              "",
                                                          placeholder:
                                                              (context, url) =>
                                                                  const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    18.0),
                                                            child:
                                                                CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.image,
                                                                  color: Colors
                                                                      .white),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${current.name}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                          ),
                                                    ),
                                                    Text(
                                                      '${current.item_code == null || current.item_code == "" ? 'NA' : current.item_code}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                          ),
                                                    ),
                                                    Text(
                                                      '₹${(current.item_unit_cost ?? 1) * simpleIntInput}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          const DottedLine(),
                                          GestureDetector(
                                            onTap: () {
                                              removeItem(current.item_id!);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                'Remove',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    ?.copyWith(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                    Card(
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
                        height: 20.h,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Deliver to other | 3-5 Days',
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
                                      'Bishnu Nagar, Joysagar, Sivasagar, Dicial Dhulia Gaon',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          ?.copyWith(
                                            color: Colors.black,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const DottedLine(),
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
                                        child: Text('Proceede to Pay'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
    final response = await ApiProvider.instance.createOrder(cupon);
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
    print('error ${response.message} ${response.code} ');
    Navigation.instance.goBack();
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      text: response.message ?? "Something went wrong",
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
