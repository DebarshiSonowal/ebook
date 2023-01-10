import 'package:awesome_icons/awesome_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Model/review.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Model/book.dart';
import '../Model/category.dart';
import '../Model/home_banner.dart';
import '../Networking/api_provider.dart';
import '../Storage/data_provider.dart';

class ConstanceData {
  static const primaryColor = Colors.black;
  static const secondaryColor = Color(0xff0d0d0d);
  static const cardColor = Color(0xff6E10BB);
  static const cardBookColor = Color(0xff121212);
  static const fontFamily = 'SF';
  static const primaryFont =
      'assets/fonts/assets/fonts/SF-Pro-Display-Regular.otf';
  static const secondaryFont =
      'assets/fonts/assets/fonts/SF-Pro-Display-Semibold.otf';

  static const splashTime = 7;

  static const optionList = ['e-books', 'books'];

  static final iconList = [
    Category('Motivation', FontAwesomeIcons.flag),
    Category('Horror', FontAwesomeIcons.skullCrossbones),
    Category('Love', FontAwesomeIcons.heart),
    Category('All', FontAwesomeIcons.boxes),
  ];

  static const pages = [
    // 'Cart',
    'Account Information',
    'Sign out',
    // 'Audio Player Settings',
    // 'Language Preference',
    // 'Downloads',
    // 'FAQs & Support',
    'Invite Friends',
    'Refund and Cancellation',
    'Terms and Conditions',
    'Privacy Policy',
    'Contact Us',
    'About',
  ];

  static const banner = [
    "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80",
    "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80",
    "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80"
  ];

  static final Motivational = [
    Book_old(
        'Principles of Economics',
        'Adam Smith',
        'https://images.unsplash.com/photo-1585624882829-f92c2d4cd89d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8dGVzdGluZ3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
        4.5),
    Book_old(
        'Engineering Mathematics',
        'Ambeshwar Phukan',
        'https://images.unsplash.com/photo-1596496181848-3091d4878b24?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fHRlc3Rpbmd8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
        5),
    Book_old(
        'Let\' Us C',
        'Unknown',
        'https://images.unsplash.com/photo-1600267204026-85c3cc8e96cd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHRlc3Rpbmd8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
        4),
    Book_old(
        'Flutter',
        'Google',
        'https://images.unsplash.com/photo-1528845922818-cc5462be9a63?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHRlc3Rpbmd8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
        3),
  ];

  static final Novel = [
    Book_old(
        'Lord of the rings',
        'CJlewis',
        'https://cdn.pixabay.com/photo/2019/03/01/18/32/night-4028339__340.jpg',
        4.9),
    Book_old(
        'Harry Potter',
        'JKRowling',
        'https://cdn.pixabay.com/photo/2019/08/02/14/41/fantasy-4379818__340.jpg',
        4.7),
    Book_old(
        'Chronicles of Narnia',
        'CJlewis',
        'https://cdn.pixabay.com/photo/2020/03/15/13/49/temple-4933682__480.jpg',
        4.4),
    Book_old(
        'Game of Thrones',
        'A.Singh',
        'https://cdn.pixabay.com/photo/2018/02/21/09/35/steampunk-3169877__480.jpg',
        4.1),
  ];

  static final Love = [
    Book_old('Half Girlfriend', 'Chetan Bhagat',
        'https://source.unsplash.com/user/c_v_r/1900x800', 4.9),
    Book_old('3 mistakes of life', 'Chetan Bhagat',
        'https://source.unsplash.com/user/c_v_r/100x100', 4.7),
    Book_old('Mismatched', 'CJlewis', 'https://picsum.photos/200/300', 4.4),
    Book_old(
        'Asdfaf', 'A.Singh', 'https://picsum.photos/seed/picsum/200/300', 4.1),
  ];

  static var Children = [
    Book_old(
        'Aatiaz',
        'CJlewis',
        'https://i.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U',
        4.9),
    Book_old(
        'Harrff', 'JKRowling', 'https://picsum.photos/200/300?grayscale', 4.7),
    Book_old(
        'ebsb',
        'CJlewis',
        'https://i.picsum.photos/id/405/200/300.jpg?blur=5&hmac=EhbmmQwVrdKxdSX-S54A_z7tXWne7vLO4Yx6tZdscIY',
        4.4),
    Book_old(
        'Game fews',
        'A.Singh',
        'https://cdn.pixabay.com/photo/2018/02/21/09/35/steampunk-3169877__480.jpg',
        4.1),
  ];

  static final category = ['All', 'Love', 'Horror', 'Motivation'];

  static const primaryIcon = 'assets/images/logo.png';
  static const humanImage = 'assets/images/user.png';
  static const emptyImage = 'assets/images/shelves.png';
  static const searchIcon = FontAwesomeIcons.search;

  // static const homeIcon = FontAwesomeIcons.home;
  static const homeIcon = "assets/images/home.png";
  static const libraryIcon = "assets/images/library.png";
  static const storeIcon = FontAwesomeIcons.store;
  static const orderIcon = "assets/images/orders.png";
  static const moreIcon = FontAwesomeIcons.hamburger;
  static const readingIcon = "assets/images/reading.png";

  // static final reviews=[
  //   Review(
  //     'Dek','Great books', 4.5,
  //   ),
  //   Review(
  //     'Dek1','Great books1', 4. 1,
  //   ),
  //   Review(
  //     'Dek2','Great books2', 4.3,
  //   ),
  //   Review(
  //     'Dek4','Great books6', 4.6,
  //   ),
  // ];

  static const categories = [
    'Motivation',
    'Novel',
    'Love',
    'Children',
    // 'More ->'
  ];

  static const testing =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
      " Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,"
      " when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

  static showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget signUpButton = TextButton(
      child: Text(
        "Sign Up",
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigation.instance.navigateAndRemoveUntil('/signup');
      },
    );
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(color: Colors.white54),
      ),
      onPressed: () {
        Navigation.instance.goBack();
      },
    );
    Widget launchButton = TextButton(
      child: Text(
        "Log In",
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigation.instance.navigate('/login');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Oops!",
        style: Theme.of(context).textTheme.headline2,
      ),
      content: Text(
        "You have not logged in yet.\nPlease Log in or Signup",
        style: Theme.of(context).textTheme.headline3,
      ),
      actions: [
        cancelButton,
        signUpButton,
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static show(context, Book data) {
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
                            Row(
                              children: [
                                Text(
                                  "by ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(color: Colors.white),
                                ),
                                Text(
                                  data.writer ?? "NA",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(color: Colors.blue),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                IgnorePointer(
                                  ignoring: true,
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
                                  "${data.length} pages",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(color: Colors.white),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 5,
                                  width: 5,
                                  decoration: const BoxDecoration(
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
                            data.book_format == "magazine"
                                ? Container()
                                : SizedBox(
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
                                              MaterialStateProperty.all(
                                                  Colors.white),
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
                                        if (data.book_format == "magazine") {
                                          Navigation.instance.navigate(
                                              '/magazineArticles',
                                              args: data.id ?? 0);
                                        } else {
                                          Navigation.instance.navigate(
                                              '/bookInfo',
                                              args: data.id);
                                          // Navigation.instance.navigate('/reading',
                                          //     args: data.id ?? 0);
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                      ),
                                      child: Text(
                                        data.book_format == "magazine"
                                            ? 'View Articles'
                                            : 'View Details',
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
                                                    Navigation
                                                            .instance
                                                            .navigatorKey
                                                            .currentContext ??
                                                        context,
                                                    listen: false)
                                                .profile !=
                                            null) {
                                          addtocart(context, data.id);
                                        } else {
                                          ConstanceData.showAlertDialog(
                                              context);
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
                    placeholder: (context, url) => const Padding(
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

  static void addtocart(context, id) async {
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

  static void showSuccess(context) {
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

  static void showError(context) {
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
}
