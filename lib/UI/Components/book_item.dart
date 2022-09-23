import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:sizer/sizer.dart';
import '../../Model/book.dart';

class BookItem extends StatelessWidget {
  bool selected = false;

  BookItem({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  final Book data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        show(context, data);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        // height: 18.h,
        width: 28.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              height: 15.h,
              margin: EdgeInsets.symmetric(horizontal: 1.5.w),
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: data.profile_pic ?? "",
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
              data.title ?? "",
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
              data.writer ?? "",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 0.5.h,
            ),
            RatingBar.builder(
              itemSize: 4.w,
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
              },
            ),
            SizedBox(
              height: 0.5.h,
            ),
            StatefulBuilder(builder: (context, _) {
              return GestureDetector(
                onTap: () async {
                  // try {
                  //   Provider.of<DataProvider>(
                  //           Navigation.instance.navigatorKey.currentContext ??
                  //               context,
                  //           listen: false)
                  //       .addToBookmarks(data);
                  // } catch (e) {
                  //   print(e);
                  // }
                  _(() {
                    selected = !selected;
                  });
                  final reponse =
                      await ApiProvider.instance.addBookmark(data.id ?? 0);
                  if (reponse.status ?? false) {
                    Fluttertoast.showToast(msg: "Bookmark added");
                    final response = await ApiProvider.instance.fetchBookmark();
                    if (response.status ?? false) {
                      Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .setToBookmarks(response.items ?? []);
                    }
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
                            'Rs. ${data.selling_price?.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      fontSize: 9.sp,
                                      color: Colors.black,
                                    ),
                          ),
                        ),
                      ),
                      Icon(
                        getSelected(context, data.id ?? 0)
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
      backgroundColor: Theme.of(context).accentColor,
      topRadius: const Radius.circular(15),
      closeProgressThreshold: 10,
      context: Navigation.instance.navigatorKey.currentContext ?? context,
      builder: (context) => Container(
        padding: const EdgeInsets.only(top: 20),
        // height: 80.h,
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
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      // height: 200,
                      // width: 200,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1.5.h),
                          Text(
                            data.title ?? "NA",
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                ?.copyWith(color: Colors.white),
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
                              RatingBar.builder(
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
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            child: Text(
                                              i.name ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
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
                                  style: Theme.of(context).textTheme.headline5,
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
                                  Navigation.instance.navigate('/bookDetails',
                                      args: data.id ?? 0);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                                child: Text(
                                  'Preview',
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
                                      Navigation.instance
                                          .navigate('/bookInfo', args: data.id);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                    ),
                                    child: Text(
                                      'Buy Now',
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
                                      addtocart(context);
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
            Container(
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
          ],
        ),
      ),
    );
  }

  void addtocart(context) async {
    final response = await ApiProvider.instance.addToCart(data.id!, '1');
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

  getSelected(context, id) {
    for (var i in Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext ?? context,
            listen: false)
        .bookmarks) {
      if (id == i.id) {
        return true;
      }
    }
    return false;
  }

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
