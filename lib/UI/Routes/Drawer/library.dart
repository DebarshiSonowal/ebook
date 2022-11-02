import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Model/bookmark.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/UI/Components/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Model/home_banner.dart';

class Librarypage extends StatefulWidget {
  const Librarypage({Key? key}) : super(key: key);

  @override
  State<Librarypage> createState() => _LibrarypageState();
}

class _LibrarypageState extends State<Librarypage>
    with TickerProviderStateMixin {
  TabController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _controller,
        tabs: const [
          Tab(
            text: 'Already Bought',
          ),
          Tab(
            text: 'Bookmark',
          ),
        ],
      ),
      body: Container(
        color: ConstanceData.primaryColor,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 0.7.h, horizontal: 2.w),
        child: Consumer<DataProvider>(builder: (cont, data, _) {
          return GridView.builder(
              itemCount: data.libraryTab == 0
                  ? data.myBooks.length
                  : data.bookmarks.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 2.5,
                crossAxisSpacing: 10.w,
              ),
              itemBuilder: (context, count) {
                var current = data.libraryTab == 0
                    ? data.myBooks[count]
                    : data.bookmarks[count];
                return GestureDetector(
                  onTap: () {
                    if (data.libraryTab == 0) {
                      // Navigation.instance.navigate('/reading',
                      //     args: (data.myBooks[count].id) ?? 0);
                      Navigation.instance.navigate('/bookDetails',
                          args: data.myBooks[count].id ?? 0);
                    } else {
                      show(context,data.bookmarks[count]);
                    }
                  },
                  child: Card(
                    child: CachedNetworkImage(
                      imageUrl: data.libraryTab == 0
                          ? data.myBooks[count].profile_pic ?? ""
                          : data.bookmarks[count].profile_pic ?? "",
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      length: 2,
      vsync: this,
    );
    Future.delayed(Duration.zero, () {
      fetchData();
    });
    _controller?.addListener(() {
      if (checkCondition(_controller?.index ?? 0)) {
        fetchData();
      }
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setLibraryTab(_controller?.index ?? 0);
    });
  }

  void fetchData() async {
    Navigation.instance.navigate('/loadingDialog');
    if ((_controller?.index ?? 0) == 1) {
      final response = await ApiProvider.instance.fetchBookmark();
      if (response.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setToBookmarks(response.items ?? []);
        Navigation.instance.goBack();
      } else {
        Navigation.instance.goBack();
      }
    } else {
      final response1 = await ApiProvider.instance.fetchMyBooks();
      if (response1.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setMyBooks(response1.books ?? []);
        Navigation.instance.goBack();
      } else {
        Navigation.instance.goBack();
      }
    }
  }

  bool checkCondition(int i) {
    if (i == 0 &&
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .myBooks
            .isEmpty) {
      return true;
    } else if (i == 1 &&
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .bookmarks
            .isEmpty) {
      return true;
    } else {
      return false;
    }
  }

// setMyBooks
  void show(context, BookmarkItem data) {
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
                                  data.contributor ?? "NA",
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
                                      // Navigation.instance.navigate(
                                      //     '/bookDetails',
                                      //     args: data.id ?? 0);
                                      Navigation.instance.navigate('/reading',
                                          args: data.id ?? 0);
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
                                        addtocart(context, data.id);
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

  void addtocart(context, id) async {
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
