import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Networking/api_provider.dart';
import '../../Components/books_section.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selected = 0;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    fetchHomeBanner();
    fetchHomeSection();
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    // if(mounted)
    //   setState(() {
    //
    //   });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white30,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator(
                color: Colors.white,
              );
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Container(
          margin: EdgeInsets.only(top: 0.1.h),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Colors.grey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // const TypeBar(),
                // NewSearchBar(),
                // Container(
                //   height: 1.h,
                //   width: double.infinity,
                //   color: Color(0xff121212),
                // ),

                // SizedBox(
                //   height: 1.h,
                //   width: double.infinity,
                //   // color: Color(0xff121212),
                // ),
                buildBooksBar(context),
                // // const BannerHome(),
                // SizedBox(
                //   height: 1.h,
                // ),
                // // const CategoryBar(),
                // // SizedBox(
                // //   height: 1.h,
                // // ),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (cont, index) {
                      return Consumer<DataProvider>(
                          builder: (context, data, _) {
                        return BooksSection(
                          title:
                              data.homeSection![data.currentTab][index].title ??
                                  'Bestselling Books',
                          list:
                              data.homeSection![data.currentTab][index].book ??
                                  [],
                        );
                      });
                    },
                    separatorBuilder: (cont, ind) {
                      return SizedBox(
                        height: 0.1.h,
                      );
                    },
                    itemCount: Provider.of<DataProvider>(context)
                        .homeSection![
                            Provider.of<DataProvider>(context).currentTab]
                        .length),

                // Consumer<DataProvider>(builder: (context, data, _) {
                //   return BooksSection(
                //     title: 'Critically Acclaimed',
                //     list: data.homeSection![0],
                //   );
                // }),

                SizedBox(
                  height: 35.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBooksBar(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, currentData, _) {
      return SizedBox(
        width: double.infinity,
        height: 19.h,
        child: Center(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            // itemCount: filterByCategory(
            //         currentData.bannerList![currentData.currentTab],
            //         currentData)
            //     .length,
            itemCount: currentData.bannerList![currentData.currentTab].length,
            itemBuilder: (cont, count) {
              // HomeBanner data = filterByCategory(
              //     currentData.bannerList![currentData.currentTab],
              //     currentData)[count];
              Book data =
                  currentData.bannerList![currentData.currentTab][count];
              return GestureDetector(
                onTap: () {
                  if (Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .profile !=
                      null) {
                    show(context, data);
                  } else {
                    ConstanceData.showAlertDialog(context);
                  }
                },
                child: Card(
                  color: Colors.transparent,
                  child: Container(
                    height: 20.h,
                    width: 70.w,
                    decoration: const BoxDecoration(
                      // color: Colors.transparent,
                      color: Color(0xff121212),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 2.h),
                            decoration: const BoxDecoration(
                              // color: ConstanceData.cardBookColor,
                              color: Colors.transparent,
                              // color: Colors.green,
                              // image: DecorationImage(
                              //   image:
                              //   fit: BoxFit.fill,
                              // ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: data.profile_pic ?? '',
                              fit: BoxFit.contain,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 1.h),
                            decoration: const BoxDecoration(
                              // color: ConstanceData.cardBookColor,
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data.title ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(
                                        // fontSize: 2.5.h,
                                        color: Colors.white,
                                      ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text(
                                  data.writer ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        // fontSize: 1.5.h,
                                        color: Colors.white,
                                      ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                RatingBar.builder(
                                    itemSize: 4.w,
                                    initialRating: 3,
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
                                SizedBox(
                                  height: 1.h,
                                ),
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
                                          .headline5
                                          ?.copyWith(
                                            // fontSize: 1.5.h,
                                            color: Colors.black,
                                          ),
                                    ),
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
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 3.w,
              );
            },
          ),
        ),
      );
    });
  }

  getTheList() {
    switch (selected) {
      case 0:
        return ConstanceData.Motivational;
      case 1:
        return ConstanceData.Novel;
      case 2:
        return ConstanceData.Love;
      default:
        return ConstanceData.Children;
    }
  }

  filterByCategory(List<Book> list, DataProvider data) {
    return list
        .where((element) =>
            element.book_category_id ==
            data.categoryList![data.currentTab][data.currentCategory].id)
        .toList();
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

  void fetchHomeBanner() async {
    for (var i in Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .formats!) {
      final response =
          await ApiProvider.instance.fetchHomeBanner(i.productFormat ?? '');
      if (response.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addBannerList(response.banners!);
      }
    }
  }

  void fetchHomeSection() async {
    for (var i in Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .formats!) {
      final response =
          await ApiProvider.instance.fetchHomeSections(i.productFormat ?? '');
      if (response.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .addHomeSection(response.sections!);
      }
    }
    _refreshController.refreshCompleted();
  }
}
