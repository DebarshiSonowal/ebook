import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Model/add_review.dart';
import 'package:ebook/UI/Components/type_bar.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../../../Constants/constance_data.dart';
import 'package:sizer/sizer.dart';

import '../../../Model/book_details.dart';
import '../../../Model/review.dart';
import '../../../Networking/api_provider.dart';

class BookInfo extends StatefulWidget {
  final int id;

  BookInfo(this.id);

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo>
    with SingleTickerProviderStateMixin {
  BookDetailsModel? bookDetails;
  List<Review> reviews = [];

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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: bookDetails == null
            ? Center(
                child: Container(
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
                    Container(
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
                                Row(
                                  children: [
                                    Text(
                                      "by",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    SizedBox(
                                      width: 1.h,
                                    ),
                                    Text(
                                      bookDetails?.writer ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(color: Colors.blueAccent),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                for (var i in bookDetails?.awards ?? [])
                                  Row(
                                    children: [
                                      Text(
                                        "# Winner of ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            // ?.copyWith(fontSize: 11.sp),
                                      ),
                                      Text(
                                        i.name ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                                color: Colors.blueAccent,
                                                // fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    BuyButton(),
                    SizedBox(
                      height: 2.h,
                    ),
                    ReadButton(),
                    DownloadSection(),
                    SizedBox(
                      width: 90.w,
                      height: 0.03.h,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    BookPublishinDetails(
                      bookDetails!,
                      widget,
                    ),
                    SizedBox(
                      height: 1.h,
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
                   SizedBox(
                     width: double.infinity,
                     child: Row(
                       children: [
                         for (var i in bookDetails?.tags ?? [])
                           Container(
                             padding: const EdgeInsets.all(5),
                             margin: EdgeInsets.symmetric(horizontal: 1.w,vertical: 0.5.h),
                             decoration: BoxDecoration(
                               border: Border.all(color: Colors.white),
                               borderRadius: BorderRadius.all(Radius.circular(5)),
                             ),
                             child: Text(
                               i.name ?? "",
                               style: Theme.of(context).textTheme.headline5,
                             ),
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
                          print(rating);
                        }),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        giveRating(context);
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
                            'Reviews (${bookDetails?.total_rating?.toInt()})',
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
                                      // fontSize: 2.5.h,
                                      // color: Colors.grey.shade200,
                                  color: Colors.white,
                                    ),
                          ),
                          Text(
                            'More >',
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      // fontSize: 1.5.h,
                                      color: Colors.blueAccent,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ListView.separated(

                      physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: reviews.length,
                        itemBuilder: (cont, index) {
                          var data = reviews[index];
                          return Container(
                            width: double.infinity,
                            // height: 20.h,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${data.subscriber}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          ?.copyWith(
                                        color: Colors.white
                                            // fontSize: 2.h,
                                            // color: Colors.grey.shade200,
                                          ),
                                    ),
                                    RatingBar.builder(
                                        itemSize: 5.w,
                                        initialRating: data.rating ?? 3,
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
                                          print(rating);
                                        }),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.5.h,
                                ),
                                Text(
                                  '${data.content}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                        // fontSize: 2.h,
                                        // color: Colors.grey.shade200,
                                      ),
                                ),
                              ],
                            ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 0.5.h),
                          child: Divider(
                            color: Colors.white,
                            height: 0.1.h,
                          ),
                        );
                    },),
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

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
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
    final response1 =
        await ApiProvider.instance.fetchReview('3');
    if (response1.status ?? false) {
      reviews = response1.reviews ?? [];
      print(reviews.length);
      if (mounted) {
        setState(() {});
      }
    }
  }

  void giveRating(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // set to false if you want to force a rating
      builder: (context) => RatingDialog(
        starSize: 4.h,
        initialRating: 0,
        // your app's name?
        title: Text(
          'Give us rating',
          textAlign: TextAlign.center,
          style:  TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        // encourage your user to leave a high rating?
        message: Text(
          'Give a review to this book',
          textAlign: TextAlign.center,
          style: TextStyle( fontSize: 12.sp,),
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
          print(
              'rating: ${response.rating}, comment: ${response.comment}');
          final response1 = await ApiProvider.instance
              .addReview(
              Add_Review(0, response.comment ?? "",
                  response.rating),
              widget.id);
        },
      ),
    );
  }
}

class BookPublishinDetails extends StatelessWidget {
  final BookDetailsModel bookDetails;

  final BookInfo widget;

  BookPublishinDetails(this.bookDetails, this.widget);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 20.h,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'RATINGS',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        // fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              RatingBar.builder(
                  itemSize: 5.w,
                  initialRating: bookDetails.average_rating ?? 3,
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
                '(${bookDetails.total_rating?.toInt()})',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      // fontSize: 2.h,
                      color: Colors.grey.shade200,
                    ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'LENGTH',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        // fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                '${bookDetails.length} pages | ${bookDetails.total_chapters} chapters',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      // fontSize: 2.h,
                      color: Colors.grey.shade200,
                    ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'LANGUAGE',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        // fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                '${bookDetails.language}',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      // fontSize: 2.h,
                      color: Colors.grey.shade200,
                    ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'FORMAT',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        // fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                '${bookDetails.book_format}',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      // fontSize: 2.h,
                      color: Colors.grey.shade200,
                    ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'PUBLISHER',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        // fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigation.instance.navigate('/writerInfo', args: 0);
                },
                child: Text(
                  '${bookDetails.publisher}',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        // fontSize: 2.h,
                        color: Colors.blueAccent,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25.w,
                child: Text(
                  'RELEASED',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                bookDetails.released_date ?? "",
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      // fontSize: 2.h,
                      color: Colors.grey.shade200,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DownloadSection extends StatelessWidget {
  const DownloadSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 0.1.w,
          ),
          SizedBox(
            height: 15.h,
            width: 20.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download),
                Text(
                  'Download',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        // fontSize: 2.h,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
            width: 0.1.w,
            child: Container(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 15.h,
            width: 20.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border),
                Text(
                  'Save',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    // fontSize: 2.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
            width: 0.1.w,
            child: Container(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 15.h,
            width: 20.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.playlist_add),
                Text(
                  'Add to List',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                    // fontSize: 2.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 0.1.w,
          ),
        ],
      ),
    );
  }
}

class BuyButton extends StatelessWidget {
  const BuyButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 5.h,
      child: ElevatedButton(
          onPressed: () {
            // Navigation.instance.navigate('/bookInfo');
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: Text(
            'Read Free for 30 Days',
            style: Theme.of(context).textTheme.headline3?.copyWith(
                  // fontSize: 1,
                  color: Colors.black,
                ),
          )),
    );
  }
}

class ReadButton extends StatelessWidget {
  const ReadButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 5.h,
      child: ElevatedButton(
        onPressed: () {
          // Navigation.instance.navigate('/bookInfo');
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        child: Text(
          'Read Preview',
          style: Theme.of(context).textTheme.headline3?.copyWith(
                // fontSize: 2.5.h,
                color: Colors.blue,
              ),
        ),
      ),
    );
  }
}
