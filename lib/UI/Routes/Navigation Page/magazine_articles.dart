import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/navigator.dart';
import '../../../Model/book_chapter.dart';
import '../../../Model/book_details.dart';
import '../../../Networking/api_provider.dart';

class MagazineArticles extends StatefulWidget {
  final int id;

  MagazineArticles(this.id);

  @override
  State<MagazineArticles> createState() => _MagazineArticlesState();
}

class _MagazineArticlesState extends State<MagazineArticles> {
  BookDetailsModel? bookDetails;
  List<BookChapter> chapters = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchBookDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          bookDetails?.title ?? "",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: bookDetails == null ? Container() : MagazineView(),
      ),
    );
  }

  Widget MagazineView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            SizedBox(
              height: 3.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: bookDetails?.profile_pic ?? "",
                  height: 15.h,
                  width: 35.w,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 4.w,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookDetails?.title ?? '',
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        bookDetails?.description ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              width: 9.w,
              child: Divider(
                color: Colors.white,
                thickness: 0.09.h,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (cont, count) {
                var current = bookDetails?.articles![count];
                return count >= 1
                    ? GestureDetector(
                  onTap: (){

                  },
                      child: ClipRect(
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                // height: 10.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colors
                                        .white, //                   <--- border width here
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 1.5.h, horizontal: 2.5.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // CachedNetworkImage(
                                        //   imageUrl: bookDetails?.profile_pic ?? "",
                                        //   height: 4.h,
                                        //   width: 12.w,
                                        //   fit: BoxFit.fill,
                                        // ),
                                        // SizedBox(
                                        //   width: 2.w,
                                        // ),
                                        SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            bookDetails?.title ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                        // Spacer(),
                                        // Icon(
                                        //   Icons.bookmark_border,
                                        //   color: Colors.black54,
                                        //   size: 5.h,
                                        // ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                current?.title ?? '',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                              Text(
                                                current?.short_note ?? '',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        CachedNetworkImage(
                                          imageUrl: current?.profile_pic ?? "",
                                          height: 10.h,
                                          width: 25.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 100,
                                width: 150,
                                child: BackdropFilter(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20)),
                                  ),
                                  filter: ImageFilter.blur(sigmaX: 0.7, sigmaY: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                    )
                    : GestureDetector(
                        onTap: () {
                          Navigation.instance.navigate('/magazineDetails',
                              args: "${bookDetails?.id},${count}" ?? '0');
                        },
                        child: Container(
                          width: double.infinity,
                          // height: 10.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Colors
                                  .white, //                   <--- border width here
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.h, horizontal: 2.5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // CachedNetworkImage(
                                  //   imageUrl: bookDetails?.profile_pic ?? "",
                                  //   height: 4.h,
                                  //   width: 12.w,
                                  //   fit: BoxFit.fill,
                                  // ),
                                  // SizedBox(
                                  //   width: 2.w,
                                  // ),
                                  SizedBox(
                                    width: 50.w,
                                    child: Text(
                                      bookDetails?.title ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                  // Spacer(),
                                  // Icon(
                                  //   Icons.bookmark_border,
                                  //   color: Colors.black54,
                                  //   size: 5.h,
                                  // ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          current?.title ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 0.5.h,
                                        ),
                                        Text(
                                          current?.short_note ?? '',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              ?.copyWith(
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  CachedNetworkImage(
                                    imageUrl: current?.profile_pic ?? "",
                                    height: 10.h,
                                    width: 25.w,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
              },
              separatorBuilder: (cont, count) {
                return Container(
                  height: 1.h,
                  // margin: EdgeInsets.symmetric(vertical: 1.h),
                  // child: Divider(
                  //   color: Colors.black,
                  //   thickness: 0.09.h,
                  // ),
                );
              },
              itemCount: bookDetails?.articles?.length ?? 0,
            ),
            SizedBox(
              height: 1.h,
            ),
            // Divider(
            //   color: Colors.black,
            //   thickness: 0.09.h,
            // ),
          ],
        ),
      ),
    );
  }

  void fetchBookDetails() async {
    Navigation.instance.navigate('/loadingDialog');
    final response =
        await ApiProvider.instance.fetchBookDetails(widget.id.toString());
    if (response.status ?? false) {
      bookDetails = response.details;
      if (mounted) {
        setState(() {});
      }
    }
    final response1 = await ApiProvider.instance
        .fetchBookChapters(widget.id.toString() ?? '3');
    // .fetchBookChapters('3');
    if (response1.status ?? false) {
      chapters = response1.chapters ?? [];
      if (mounted) {
        setState(() {});
      }
    }
    Navigation.instance.goBack();
  }
}
