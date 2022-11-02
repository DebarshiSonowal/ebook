import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/UI/Components/type_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../Constants/constance_data.dart';
import '../../Model/book.dart';
import '../../Model/razorpay_key.dart';

class BookItem extends StatefulWidget {
  final Book data;
  final int index;

  BookItem({
    Key? key,
    required this.data,
    required this.index,
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
        show(context, widget.data);

      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        // height: 18.h,
        width: 35.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              height: 20.h,
              margin: EdgeInsets.symmetric(horizontal: 1.5.w),
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: widget.data.profile_pic ?? "",
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.image, color: Colors.white),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 0.2.h,
            ),
            Text(
              widget.data.title ?? "",
              // maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Colors.white,
                  ),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Text(
              widget.data.writer ?? "",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 0.5.h,
            ),
            RatingBar.builder(
              itemSize: 4.w,
              initialRating: widget.data.average_rating ?? 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              // itemPadding:
              //     EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.white,
                size: 10,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            SizedBox(
              height: 0.5.h,
            ),
            StatefulBuilder(builder: (context, _) {
              return GestureDetector(
                onTap: () async {
                  if (Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .profile !=
                      null) {
                    _(() {
                      selected = !selected;
                    });
                    final reponse = await ApiProvider.instance
                        .addBookmark(widget.data.id ?? 0);
                    if (reponse.status ?? false) {
                      Fluttertoast.showToast(msg: reponse.message!);
                      final response =
                          await ApiProvider.instance.fetchBookmark();
                      if (response.status ?? false) {
                        Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .setToBookmarks(response.items ?? []);
                      }
                    }
                  } else {
                    ConstanceData.showAlertDialog(context);
                  }
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(0.5.w),
                          // decoration: ,
                          child: Text(
                            'Rs. ${(widget.data.selling_price?.toStringAsFixed(2)).toString() == '0.00' ? (widget.data.base_price ?? 0).toStringAsFixed(2) : widget.data.selling_price?.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      fontSize: 8.sp,
                                      color: Colors.black,
                                    ),
                          ),
                        ),
                      ),
                      Icon(
                        (widget.data.is_bookmarked ?? false) ^ selected
                            // selected
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: Colors.grey.shade200,
                      )
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void show(context, Book data) {
    showCupertinoModalBottomSheet(
      enableDrag: true,
      // expand: true,
      elevation: 15,
      clipBehavior: Clip.antiAlias,
      backgroundColor: ConstanceData.secondaryColor.withOpacity(0.97),
      topRadius: const Radius.circular(15),
      closeProgressThreshold: 10,
      context: Navigation.instance.navigatorKey.currentContext ?? context,
      builder: (context) => Container(
        padding: EdgeInsets.only(top: 0.1.h),
        color: ConstanceData.secondaryColor.withOpacity(0.97),
        // height: 80.h,
        child: Material(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: 75.h,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: ConstanceData.secondaryColor.withOpacity(0.97),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigation.instance.goBack();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        // height: 200,
                        // width: 200,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: double.infinity,
                        color: ConstanceData.secondaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1.5.h),
                            GestureDetector(
                              onTap: () {
                                Navigation.instance
                                    .navigate('/bookInfo', args: data.id);
                              },
                              child: Text(
                                data.title ?? "NA",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            data.book_format == "magazine"
                                ? Container()
                                : Row(
                                    children: [
                                      Text(
                                        "by ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigation.instance.navigate(
                                              '/writerInfo',
                                              args: data.contributor_id);
                                        },
                                        child: Text(
                                          data.writer ?? "NA",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                AbsorbPointer(
                                  child: RatingBar.builder(
                                      itemSize: 6.w,
                                      initialRating: data.average_rating ?? 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      // itemPadding:
                                      //     EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      }),
                                ),
                                Text(
                                  " (${data.total_rating})",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                Text(
                                  data.book_format != "magazine"
                                      ? "${data.length} pages"
                                      : "${data.articles?.length} articles",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(color: Colors.white),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(
                                  "${data.language}",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.white,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                // decoration: ,
                                child: Text(
                                  'Rs. ${data.selling_price?.toStringAsFixed(2)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        fontSize: 1.5.h,
                                        color: Colors.black,
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            SizedBox(
                              width: 50.w,
                              child: SizedBox(
                                width: double.infinity,
                                height: 4.h,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          for (var i in data.tags ?? [])
                                            GestureDetector(
                                              onTap: () {
                                                Navigation.instance.goBack();
                                                Navigation.instance.navigate(
                                                    '/searchWithTag',
                                                    args: i.toString());
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                                child: Text(
                                                  i.name ?? "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     Navigation.instance
                                    //         .navigate('/categories');
                                    //   },
                                    //   child: Container(
                                    //     padding: const EdgeInsets.all(5),
                                    //     margin: const EdgeInsets.symmetric(
                                    //         horizontal: 5),
                                    //     decoration: BoxDecoration(
                                    //       border:
                                    //           Border.all(color: Colors.white),
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(5)),
                                    //     ),
                                    //     child: Text(
                                    //       'All Categories',
                                    //       style: Theme.of(context)
                                    //           .textTheme
                                    //           .headline5,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            data.awards!.isNotEmpty
                                ? Text(
                                    "${data.awards![0].name} Winner",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
                                : Container(),
                            SizedBox(height: 2.h),
                            Text(
                              "${data.short_description}",
                              maxLines: 3,
                              overflow: TextOverflow.fade,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            SizedBox(height: 1.h),
                            SizedBox(
                              width: double.infinity,
                              height: 4.5.h,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (data.book_format == "magazine") {
                                      Navigation.instance.navigate(
                                          '/magazineArticles',
                                          args: data.id ?? 0);
                                    } else {
                                      Navigation.instance.navigate(
                                          '/bookDetails',
                                          args: data.id ?? 0);
                                      // Navigation.instance.navigate('/reading',
                                      //     args: data.id ?? 0);
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  child: Text(
                                    data.book_format == "magazine"
                                        ? 'View Articles'
                                        : 'Preview',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                          fontSize: 2.h,
                                          color: Colors.black,
                                        ),
                                  )),
                            ),
                            SizedBox(height: 1.h),
                            SizedBox(
                              width: double.infinity,
                              height: 4.5.h,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // initiatePaymentProcess(widget.data.id);
                                        Navigation.instance.navigate(
                                            '/bookInfo',
                                            args: data.id);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                      ),
                                      child: Text(
                                        'View Details',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              fontSize: 2.h,
                                              color: Colors.black,
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Navigation.instance
                                        //     .navigate('/bookInfo', args: data.id);

                                        if (Provider.of<DataProvider>(
                                            Navigation.instance.navigatorKey.currentContext ?? context,
                                            listen: false)
                                            .profile !=
                                            null) {
                                          addtocart(context);
                                        } else {
                                          ConstanceData.showAlertDialog(context);
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                      ),
                                      child: Text(
                                        'Add To Cart',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              fontSize: 2.h,
                                              color: Colors.black,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigation.instance.navigate('/bookInfo', args: data.id);
                },
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  height: 25.h,
                  width: 40.w,
                  child: CachedNetworkImage(
                    imageUrl: data.profile_pic ?? "",
                    placeholder: (context, url) => Padding(
                      padding: EdgeInsets.all(18.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.person),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addtocart(context) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.addToCart(widget.data.id!, '1');
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
      Navigation.instance.goBack();
      showSuccess(context);
    } else {
      Navigation.instance.goBack();
      Navigation.instance.goBack();
      showError(context);
    }
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

  void showSuccess(context) {
    var snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Added to cart',
        message: 'The following book is added to cart',
        contentType: ContentType.success,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showError(context) {
    var snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Failed',
        message: 'Something went wrong',
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
