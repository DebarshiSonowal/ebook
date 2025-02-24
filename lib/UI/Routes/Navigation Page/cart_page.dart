import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';

// import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:ebook/Model/cart_item.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Model/razorpay_key.dart';
import 'package:ebook/Storage/common_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/UI/Components/empty_widget.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';

// import 'package:quantity_input/quantity_input.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restart_app/restart_app.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  int coins = 0;
  final _razorpay = Razorpay();
  double tempTotal = 1.0;
  String temp_order_id = "";
  bool loading = false;
  String discount = "0";

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
        centerTitle: true,
        title: Text(
          "Cart",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.black,
                fontSize: 18.sp,
              ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigation.instance.navigate("/wallet");
            },
            child: Icon(
              Icons.wallet,
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Consumer<DataProvider>(builder: (cont, data, _) {
          return data.cartData == null
              ? Container()
              : Skeletonizer(
                  enabled: loading,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.5.h, horizontal: 3.w),
                          child: SingleChildScrollView(
                            child: Column(
                              // shrinkWrap: true,
                              children: [
                                CuponsCard(
                                  canUseCoin:
                                      data.cartData?.can_use_reward ?? false,
                                  cupon: cupon,
                                  coins: coins,
                                  onCouponTap: () async {
                                    if (cupon == "" || cupon.isEmpty) {
                                      final response = await Navigation.instance
                                          .navigate('/couponPage');
                                      if (response != null) {
                                        setState(() {
                                          cupon =
                                              cupon == response ? '' : response;
                                        });
                                        if (cupon.isNotEmpty) {
                                          applyDiscount("coupon", "add", cupon);
                                        } else {
                                          applyDiscount(
                                              "coupon", "remove", cupon);
                                        }
                                      } else {
                                        setState(() {
                                          cupon = "";
                                        });
                                        setState(() {
                                          discount = "0";
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        cupon = "";
                                      });
                                      setState(() {
                                        discount = "0";
                                      });
                                    }
                                  },
                                  onCoinsTap: () {
                                    setState(() {
                                      if (coins == 0) {
                                        final totalPoints =
                                            data.rewardResult?.totalPoints ?? 0;
                                        final totalPrice = int.parse(
                                            data.cartData?.total_price ?? "0");
                                        coins = totalPoints > totalPrice
                                            ? totalPrice
                                            : totalPoints;
                                      } else {
                                        coins = 0;
                                      }
                                    });
                                    if (coins > 0) {
                                      applyDiscount("reward", "add", "");
                                    } else {
                                      applyDiscount("reward", "remove", "");
                                    }
                                  },
                                ),
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
                              cupon: cupon,
                              coins: coins,
                              discount: discount,
                              getTotalAmount: (data) => getTotalAmount(data),
                              freeItemsProcess: (cupon) =>
                                  freeItemsProcess(cupon),
                              initiatePaymentProcess: (amount) =>
                                  initiatePaymentProcess(),
                            ),
                    ],
                  ),
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
      fetchData();
    });
  }

  void fetchCartItems() async {
    setState(() {
      loading = true;
    });
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
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void initiatePaymentProcess() async {
    setState(() {
      loading = true;
    });
    final response = await ApiProvider.instance.fetchRazorpay();
    if (response.status ?? false) {
      if ((cupon == null || cupon == "") && coins != 0) {
        initateOrder(response.razorpay!, "REWARDCOIN");
      } else if (coins != null && coins != 0) {
        initateOrder(response.razorpay!, cupon);
      } else {
        // applyCoupon(cupon, response.razorpay!);
        initateOrder(response.razorpay!, "");
      }
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      // Navigation.instance.goBack();
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.warning,
      //   text: "Something went wrong",
      // );
    }
  }

  void initateOrder(RazorpayKey razorpay, cupon) async {
    final response = await ApiProvider.instance.createOrder(cupon, null);
    if (response.status ?? false) {
      tempTotal = response.order?.grand_total ?? 0;
      temp_order_id = response.order?.order_id.toString() ?? "";
      startPayment(razorpay, response.order?.grand_total,
          response.order?.order_id, response.order?.subscriber_id);
    } else {
      // Navigation.instance.goBack();
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.warning,
      //   text: "Something went wrong",
      // );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(
        'success ${response.paymentId} ${response.orderId} ${response.signature}');
    handleSuccess(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    try {
      var resp = json.decode(response.message!);
      debugPrint('error ${resp['error']['description']} ${response.code} ');
      // Navigation.instance.goBack();
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.error,
      //   text: resp['error']['description'] ?? "Something went wrong",
      // );
    } catch (e) {
      // Navigation.instance.goBack();
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.error,
      //   text: response.message ?? "Something went wrong",
      // );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  void startPayment(RazorpayKey razorpay, double? total, id, customer_id) {
    var options = {
      'key': razorpay.api_key,
      'amount': total! * 100,
      // 'order_id': id,
      "image": "https://tratri.in/assets/assets/images/logos/logo-razorpay.jpg",
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
    debugPrint("Options ${options}");
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void removeItem(int id) async {
    // Navigation.instance.navigate('/loadingDialog');
    setState(() {
      loading = true;
    });
    final response = await ApiProvider.instance.deleteCart(id);
    if (response.status ?? false) {
      setState(() {
        loading = false;
      });
      fetchCartItems();
    } else {
      setState(() {
        loading = false;
      });
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.warning,
      //   text: "Enter proper credentials",
      // );
    }
  }

  void handleSuccess(PaymentSuccessResponse response) async {
    setState(() {
      loading = true;
    });
    final response1 = await ApiProvider.instance
        .verifyPayment(temp_order_id, response.paymentId, tempTotal ?? 1);
    if (response1.status ?? false) {
      setState(() {
        loading = false;
      });
      fetchCartItems();
      fetchData();
      fetchHomeBanner();
      fetchHomeSection();
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  // void applyCoupon(String coupon, RazorpayKey razorpayKey) async {
  //   final response =
  //       await ApiProvider.instance.applyDiscount(coupon, tempTotal);
  //   if (response.success ?? false) {
  //     if (mounted) {
  //       setState(() {
  //         tempTotal = response.amount ?? tempTotal;
  //       });
  //       initateOrder(razorpayKey);
  //     } else {
  //       tempTotal = response.amount ?? tempTotal;
  //       initateOrder(razorpayKey);
  //     }
  //   } else {
  //     Navigation.instance.goBack();
  //     // CoolAlert.show(
  //     //   context: context,
  //     //   type: CoolAlertType.warning,
  //     //   text: "Something went wrong",
  //     // );
  //   }
  // }

  void freeItemsProcess(cupon) async {
    final response = await ApiProvider.instance.createOrder(cupon, null);
    if (response.status ?? false) {
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.success,
      //   text: "Payment received Successfully",
      // );
      debugPrint("responseHome1");
      fetchCartItems();
      debugPrint("responseHome2");
      fetchData();
      debugPrint("responseHome3");
      fetchHomeBanner();
      debugPrint("responseHome4");
      fetchHomeSection();
    } else {
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.warning,
      //   text: "Something went wrong",
      // );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 50,
              ),
              SizedBox(height: 10),
              Text(
                'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 19.sp,
                ),
              ),
            ],
          ),
          content: Text(
            response.message ?? 'Something went wrong',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  fetchData() async {
    setState(() {
      loading = true;
    });
    final response = await ApiProvider.instance.getRewards();
    if (response.success ?? false) {
      Provider.of<DataProvider>(context, listen: false)
          .setRewards(response.result!);
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void showCoinsAppliedDialog(String? msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              'Coins Applied!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 19.sp,
              ),
            ),
          ],
        ),
        content: Text(
          '$msg',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void applyDiscount(discount_for, request_for, coupon_code) async {
    setState(() {
      loading = true;
    });
    final response = await ApiProvider.instance
        .applyDiscountAPI(discount_for, request_for, coupon_code);
    if (response.status ?? false) {
      setState(() {
        loading = false;
      });
      if (discount_for == "reward") {
        if (coins > 0) {
          showCoinsAppliedDialog(response.message);
          debugPrint("${response.cart?.discount_amount}");
          setState(() {
            discount = "${response.cart?.discount_amount}";
          });
        } else {
          setState(() {
            discount = "0";
          });
        }
      } else {
        debugPrint("Cupons Applied");
        if (cupon != "") {
          setState(() {
            discount = "${response.cart?.discount_amount}";
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Coupon Applied!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 19.sp,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Coupon code $cupon has been applied to your purchase.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          setState(() {
            discount = "0";
          });
        }
      }
    } else {
      setState(() {
        loading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 50,
              ),
              SizedBox(height: 10),
              Text(
                'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 19.sp,
                ),
              ),
            ],
          ),
          content: Text(
            response.message ?? 'Something went wrong',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void fetchHomeBanner() async {
    final dataProvider = Provider.of<DataProvider>(
        Navigation.instance.navigatorKey.currentContext!,
        listen: false);

    await Future.wait(dataProvider.formats!.map((format) async {
      final response = await ApiProvider.instance
          .fetchHomeBanner(format.productFormat ?? '');
      if (response.status ?? false) {
        dataProvider.addBannerList(response.banners!);
      }
    }));
  }

  void fetchHomeSection() async {
    final dataProvider = Provider.of<CommonProvider>(
        Navigation.instance.navigatorKey.currentContext!,
        listen: false);

    try {
      await Future.wait(Provider.of<DataProvider>(context, listen: false)
          .formats!
          .map((format) async {
        final response = await ApiProvider.instance
            .fetchHomeSections(format.productFormat ?? '');
        debugPrint("responseHome5");
        if (response.status ?? false) {
          switch (format.productFormat) {
            case 'ebook':
              dataProvider.setEbookHomeSections(response.sections!);
              break;
            case 'magazine':
              dataProvider.setMagazineHomeSections(response.sections!);
              break;
            case 'enotes':
              dataProvider.setEnotesHomeSections(response.sections!);
              break;
          }
        }
      }));
    } finally {
      // Restart.restartApp(
      //   /// In Web Platform, Fill webOrigin only when your new origin is different than the app's origin
      //   // webOrigin: 'http://example.com',
      //
      //   // Customizing the restart notification message (only needed on iOS)
      //   notificationTitle: 'Restarting App',
      //   notificationBody: 'Please tap here to open the app again.',
      // );
      Navigation.instance.navigateAndRemoveUntil("/main");
    }
  }
}
