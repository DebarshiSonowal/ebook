// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Model/add_review.dart';
import 'package:ebook/UI/Components/type_bar.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../Constants/constance_data.dart';
import 'package:sizer/sizer.dart';

import '../../../Model/book_details.dart';
import '../../../Model/home_banner.dart';
import '../../../Model/razorpay_key.dart';
import '../../../Model/review.dart';
import '../../../Networking/api_provider.dart';
import '../../../Storage/app_storage.dart';
import '../../../Storage/data_provider.dart';
import '../../Components/book_publishing_details.dart';
import '../../Components/buy_button.dart';
import '../../Components/download_section.dart';
import '../../Components/read_button.dart';
import '../../Components/review_section.dart';
import '../../Components/tag_bookdetails.dart';
import '../../Components/winner_of.dart';

class BookInfo extends StatefulWidget {
  final int id;

  BookInfo(this.id);

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo>
    with SingleTickerProviderStateMixin {
  Book? bookDetails;
  List<Review> reviews = [];
  final _razorpay = Razorpay();
  double tempTotal = 0;
  var cupon = "";
  String temp_order_id = '0';

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    fetchBookDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          bookDetails?.title ?? "",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline1?.copyWith(
                color: Colors.white,
              ),
        ),
        // actions: [
        //
        // ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: bookDetails == null
            ? const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 20.h,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            height: 20.h,
                            width: 30.w,
                            child: CachedNetworkImage(
                              imageUrl: bookDetails?.profile_pic ?? "",
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          SizedBox(
                            width: 55.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bookDetails?.title ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                bookDetails?.book_format != "magazine"
                                    ? Row(
                                        children: [
                                          Text(
                                            "by",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                          SizedBox(
                                            width: 1.h,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigation.instance.navigate(
                                                  '/writerInfo',
                                                  args:
                                                      '${bookDetails?.contributor_id},${bookDetails?.magazine_id}');
                                            },
                                            child: Text(
                                              (bookDetails?.contributor ?? ""),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  ?.copyWith(
                                                      color: Colors.blueAccent),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          // Text(
                                          //   "Publisher: ",
                                          //   style: Theme.of(context)
                                          //       .textTheme
                                          //       .headline4,
                                          // ),
                                          // SizedBox(
                                          //   width: 1.h,
                                          // ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigation.instance.navigate(
                                                  '/writerInfo',
                                                  args:
                                                      '${bookDetails?.contributor_id},${bookDetails?.magazine_id}');
                                            },
                                            child: Text(
                                              (bookDetails?.contributor ?? ""),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  ?.copyWith(
                                                      color: Colors.blueAccent),
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                for (var i in bookDetails?.awards ?? [])
                                  winnerOf(i: i),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0),
                                  ),
                                  color: Colors.white,
                                  child: Container(
                                    padding: EdgeInsets.all(0.7.w),
                                    // decoration: ,
                                    child: Text(
                                      bookDetails?.selling_price
                                                  ?.toStringAsFixed(2)
                                                  .toString() ==
                                              "0.00"
                                          ? "FREE"
                                          : "Rs. ${bookDetails?.selling_price?.toStringAsFixed(2)}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                            fontSize: 9.sp,
                                            color: bookDetails?.selling_price
                                                        ?.toStringAsFixed(2)
                                                        .toString() ==
                                                    "0.00"
                                                ? Colors.green
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    (bookDetails?.is_bought ?? false)
                        ? Container()
                        : SizedBox(
                            height: 2.h,
                          ),
                    (bookDetails?.is_bought ?? false)
                        ? Container()
                        : BuyButton(widget.id, () {
                            (bookDetails?.selling_price ?? 0) <= 0
                                ? freeItemsProcess()
                                : initiatePaymentProcess(widget.id);
                          }, bookDetails?.is_bought ?? false),
                    SizedBox(
                      height: 2.h,
                    ),
                    ReadButton(
                      id: widget.id,
                      format: bookDetails?.book_format ?? "",
                      isBought: bookDetails?.is_bought ?? false,
                      profile_pic: bookDetails?.profile_pic ?? "",
                    ),
                    DownloadSection(
                        widget.id, bookDetails?.is_bookmarked ?? false,bookDetails?.book_format ?? ""),
                    SizedBox(
                      width: 90.w,
                      height: 0.03.h,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    BookPublishinDetails(
                      bookDetails!,
                      widget,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    // SizedBox(
                    //   width: 90.w,
                    //   height: 0.02.h,
                    //   child: Container(
                    //     color: Colors.white,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 1.5.h,
                    // ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          for (var i in bookDetails?.tags ?? [])
                            GestureDetector(
                              onTap: () {
                                Navigation.instance.navigate('/searchWithTag',
                                    args: i.toString());
                              },
                              child: Tag_BookDetails(i: i),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    SizedBox(
                      width: 90.w,
                      height: 0.02.h,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      'Description:',
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            // fontSize: 2.5.h,
                            color: Colors.white,
                          ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    // Text(
                    //   'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout',
                    //   style: Theme.of(context).textTheme.headline4?.copyWith(
                    //         // fontSize: 1.9.h,
                    //         // color: Colors.grey.shade200,
                    //       ),
                    // ),
                    // SizedBox(
                    //   height: 1.h,
                    // ),
                    ExpandableText(
                      bookDetails?.description ?? "",
                      expandText: 'show more',
                      collapseText: 'show less',
                      maxLines: 3,
                      style: Theme.of(context).textTheme.headline5,
                      linkColor: Colors.blue,
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    SizedBox(
                      width: 90.w,
                      height: 0.02.h,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Text(
                      'Your Rating & Review',
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            // fontSize: 2.5.h,
                            // color: Colors.grey.shade200,
                            color: Colors.white,
                          ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    RatingBar.builder(
                        itemSize: 5.h,
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        // itemPadding:
                        //     EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 10,
                            ),
                        onRatingUpdate: (rating) {
                          if (Storage.instance.isLoggedIn) {
                            giveRating(context, rating);
                          } else {
                            ConstanceData.showAlertDialog(context);
                          }
                        }),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Storage.instance.isLoggedIn) {
                          giveRating(context, 0);
                        } else {
                          ConstanceData.showAlertDialog(context);
                        }
                      },
                      child: Text(
                        "Write a Review",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Colors.blueAccent),
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    SizedBox(
                      width: 90.w,
                      height: 0.02.h,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Reviews (${reviews.length})',
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
                                      // fontSize: 2.5.h,
                                      // color: Colors.grey.shade200,
                                      color: Colors.white,
                                    ),
                          ),
                          // Text(
                          //   'More >',
                          //   style:
                          //       Theme.of(context).textTheme.headline5?.copyWith(
                          //             // fontSize: 1.5.h,
                          //             color: Colors.blueAccent,
                          //           ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ReviewSection(reviews: reviews),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    SizedBox(
                      width: 90.w,
                      height: 0.02.h,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void fetchBookDetails() async {
    final response =
        await ApiProvider.instance.fetchBookDetails(widget.id.toString());
    if (response.status ?? false) {
      bookDetails = response.details;
      if (mounted) {
        setState(() {});
      }
    }
    fetchReviews();
  }

  fetchReviews() async {
    final response1 =
        await ApiProvider.instance.fetchReview(widget.id.toString());
    if (response1.status ?? false) {
      reviews = response1.reviews ?? [];
      if (mounted) {
        setState(() {});
      }
    }
  }

  void giveRating(BuildContext context, double rating) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // set to false if you want to force a rating
      builder: (context) => RatingDialog(
        starSize: 4.h,
        initialRating: rating,
        // your app's name?
        title: Text(
          'Give us rating',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        // encourage your user to leave a high rating?
        message: Text(
          'Give a review to this book',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
          ),
        ),
        // your app's logo?
        // image: const FlutterLogo(size: 100),
        submitButtonText: 'Submit',
        submitButtonTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
        ),
        commentHint: '',
        // commentHint: 'Set your custom comment hint',
        onCancelled: () => print('cancelled'),
        onSubmitted: (response) async {
          addReview(response);
        },
      ),
    );
  }

  void initiatePaymentProcess(id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.fetchRazorpay();
    if (response.status ?? false) {
      if (cupon == null || cupon == "") {
        initateOrder(response.razorpay!, id);
      } else {
        // applyCoupon(cupon, response.razorpay!);
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

  freeItemsProcess() async {
    final response = await ApiProvider.instance.createOrder(cupon, null);
    if (response.status ?? false) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Payment received Successfully",
      );
      fetchCartItems();
      Navigation.instance.goBack();
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Something went wrong",
      );
    }
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

  void initateOrder(RazorpayKey razorpay, id) async {
    final response = await ApiProvider.instance.createOrder(cupon, id);
    if (response.status ?? false) {
      tempTotal = response.order?.grand_total ?? 0;
      temp_order_id = response.order?.order_id.toString() ?? "";
      startPayment(razorpay, response.order?.grand_total, response.order?.order_id,
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
    handleSuccess(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Navigation.instance.goBack();
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      text: response.message ?? "Something went wrong",
    );
    Navigation.instance.goBack();
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
    } catch (e) {}
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
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Something went wrong",
      );
      Navigation.instance.goBack();
    }
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

  void addReview(RatingDialogResponse response) async {
    final response1 = await ApiProvider.instance.addReview(
        Add_Review(0, response.comment ?? "", response.rating), widget.id);
    if (response1.status ?? false) {
      fetchReviews();
    } else {
      showError(response1.message ?? "Something went wrong");
    }
  }
}
