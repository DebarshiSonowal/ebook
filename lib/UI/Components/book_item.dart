// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Constants/constance_data.dart';
import '../../Storage/app_storage.dart';

class BookItem extends StatefulWidget {
  final Book data;
  final int index;
  final Function(Book data) show;

  BookItem({
    Key? key,
    required this.data,
    required this.index,
    required this.show,
  }) : super(key: key);

  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  bool selected = false;

  // final _razorpay = Razorpay();
  var cupon = "";

  double tempTotal = 0;

  String temp_order_id = '0';

  @override
  void initState() {
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.show(widget.data);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 35.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:
              MainAxisSize.min, // Ensure column only takes needed space
          children: [
            AspectRatio(
              aspectRatio: 0.75, // Fixed aspect ratio for image container
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                child: CachedNetworkImage(
                  imageUrl: widget.data.profile_pic ?? "",
                  placeholder: (context, url) => const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.image, color: Colors.white),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 1.w),
              child: Text(
                widget.data.title ?? "",
                maxLines: 1, // Limit to one line
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
              ),
            ),
            SizedBox(
              height: 0.3.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 1.w),
              child: Text(
                widget.data.writer ?? "",
                maxLines: 1, // Limit to one line
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 14.sp,
                    ),
              ),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: IgnorePointer(
                    child: RatingBar.builder(
                      itemSize: 3.w,
                      initialRating: widget.data.average_rating ?? 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 10.sp,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                ),
                StatefulBuilder(builder: (context, _) {
                  return GestureDetector(
                    onTap: () async {
                      if ((Provider.of<DataProvider>(
                                      Navigation.instance.navigatorKey
                                              .currentContext ??
                                          context,
                                      listen: false)
                                  .profile !=
                              null) &&
                          Storage.instance.isLoggedIn) {
                        _(() {
                          selected = !selected;
                        });
                        if (Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: false)
                                .currentTab !=
                            2) {
                          final reponse = await ApiProvider.instance
                              .addBookmark(widget.data.id ?? 0);
                          if (reponse.status ?? false) {
                            Fluttertoast.showToast(msg: reponse.message!);
                            final response =
                                await ApiProvider.instance.fetchBookmark();
                            if (response.status ?? false) {
                              Provider.of<DataProvider>(
                                      Navigation.instance.navigatorKey
                                              .currentContext ??
                                          context,
                                      listen: false)
                                  .setToBookmarks(response.items ?? []);
                            }
                          }
                        } else {
                          final reponse = await ApiProvider.instance
                              .addNoteBookmark(widget.data.id ?? 0);
                          if (reponse.status ?? false) {
                            Fluttertoast.showToast(msg: reponse.message!);
                            final response =
                                await ApiProvider.instance.fetchNoteBookmark();
                            if (response.status ?? false) {
                              Provider.of<DataProvider>(
                                      Navigation.instance.navigatorKey
                                              .currentContext ??
                                          context,
                                      listen: false)
                                  .setToBookmarks(response.items ?? []);
                            }
                          }
                        }
                      } else {
                        ConstanceData.showAlertDialog(context);
                      }
                    },
                    child: Icon(
                      (widget.data.is_bookmarked ?? false) ^ selected
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      size: 18.sp,
                      color: Colors.grey.shade200,
                    ),
                  );
                })
              ],
            ),
            SizedBox(
              height: 0.5.h,
            ),
          ],
        ),
      ),
    );
  }

  getSelected(context, id) {
    return Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .bookmarks
            .where((element) => id == element.id)
            .isNotEmpty
        ? true
        : false;

    // for (var i in Provider.of<DataProvider>(
    //         Navigation.instance.navigatorKey.currentContext ?? context,
    //         listen: false)
    //     .bookmarks) {
    //   if (id == i.id) {
    //     return true;
    //   }
    // }
    // return false;
  }

  void showSuccess(context) {
    // var snackBar = SnackBar(
    //   elevation: 0,
    //   behavior: SnackBarBehavior.floating,
    //   backgroundColor: Colors.transparent,
    //   content: AwesomeSnackbarContent(
    //     title: 'Added to cart',
    //     message: 'The following book is added to cart',
    //     contentType: ContentType.success,
    //   ),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Fluttertoast.showToast(msg: "The following book is added to cart");
  }

  void showError(context) {
    // var snackBar = SnackBar(
    //   elevation: 0,
    //   behavior: SnackBarBehavior.floating,
    //   backgroundColor: Colors.transparent,
    //   content: AwesomeSnackbarContent(
    //     title: 'Failed',
    //     message: 'Something went wrong',
    //     contentType: ContentType.failure,
    //   ),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Fluttertoast.showToast(msg: "Something went wrong");
  }

  // String getPriceText() {
  //   var priceText =
  //       (widget.data.selling_price?.toStringAsFixed(2)).toString() == '0.00'
  //           ? (widget.data.base_price ?? 0).toStringAsFixed(2)
  //           : widget.data.selling_price?.toStringAsFixed(2);
  //   if (priceText.toString() != '0.00') {
  //     return 'Rs. $priceText';
  //   }
  //   return "FREE";
  // }

  bool getColorText() {
    var priceText =
        (widget.data.selling_price?.toStringAsFixed(2)).toString() == '0.00'
            ? (widget.data.base_price ?? 0).toStringAsFixed(2)
            : widget.data.selling_price?.toStringAsFixed(2);
    if (priceText.toString() != '0.00') {
      return false;
    }
    return true;
  }
// void initiatePaymentProcess(id) async {
//   Navigation.instance.navigate('/loadingDialog');
//   final response = await ApiProvider.instance.fetchRazorpay();
//   if (response.status ?? false) {
//     if (cupon != null || cupon == "") {
//       initateOrder(response.razorpay!,id);
//     } else {
//       // applyCoupon(cupon, response.razorpay!);
//     }
//   } else {
//     Navigation.instance.goBack();
//     CoolAlert.show(
//       context: context,
//       type: CoolAlertType.warning,
//       text: "Something went wrong",
//     );
//   }
// }
//
// void initateOrder(RazorpayKey razorpay,id) async {
//   final response = await ApiProvider.instance.createOrder(cupon,id);
//   if (response.status ?? false) {
//     tempTotal = response.order?.total ?? 0;
//     temp_order_id = response.order?.order_id.toString() ?? "";
//     startPayment(razorpay, response.order?.total, response.order?.order_id,
//         response.order?.subscriber_id);
//   } else {
//     Navigation.instance.goBack();
//     CoolAlert.show(
//       context: context,
//       type: CoolAlertType.warning,
//       text: "Something went wrong",
//     );
//   }
// }
//
// void _handlePaymentSuccess(PaymentSuccessResponse response) {
//   print(
//       'success ${response.paymentId} ${response.orderId} ${response.signature}');
//   handleSuccess(response);
// }
//
// void _handlePaymentError(PaymentFailureResponse response) {
//   // Do something when payment fails
//   print('error ${response.message} ${response.code} ');
//   Navigation.instance.goBack();
//   CoolAlert.show(
//     context: context,
//     type: CoolAlertType.warning,
//     text: response.message ?? "Something went wrong",
//   );
//   Navigation.instance.goBack();
// }
//
// void _handleExternalWallet(ExternalWalletResponse response) {
//   // Do something when an external wallet was selected
// }
//
// void startPayment(RazorpayKey razorpay, double? total, id, customer_id) {
//   var options = {
//     'key': razorpay.api_key,
//     'amount': total! * 100,
//     // 'order_id': id,
//     'name':
//         '${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.f_name} ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.l_name}',
//     'description': 'Books',
//     'prefill': {
//       'contact': Provider.of<DataProvider>(
//               Navigation.instance.navigatorKey.currentContext ?? context,
//               listen: false)
//           .profile
//           ?.mobile,
//       'email': Provider.of<DataProvider>(
//               Navigation.instance.navigatorKey.currentContext ?? context,
//               listen: false)
//           .profile
//           ?.email
//     },
//     'note': {
//       'customer_id': customer_id,
//       'order_id': id,
//     },
//   };
//
//   try {
//     _razorpay.open(options);
//   } catch (e) {
//     print(e);
//   }
// }
//
// void handleSuccess(PaymentSuccessResponse response) async {
//   final response1 = await ApiProvider.instance
//       .verifyPayment(temp_order_id, response.paymentId, tempTotal ?? 1);
//   if (response1.status ?? false) {
//     Navigation.instance.goBack();
//     CoolAlert.show(
//       context: context,
//       type: CoolAlertType.success,
//       text: "Payment received Successfully",
//     );
//     Navigation.instance.goBack();
//   } else {
//     Navigation.instance.goBack();
//     CoolAlert.show(
//       context: context,
//       type: CoolAlertType.warning,
//       text: "Something went wrong",
//     );
//     Navigation.instance.goBack();
//   }
// }
}
