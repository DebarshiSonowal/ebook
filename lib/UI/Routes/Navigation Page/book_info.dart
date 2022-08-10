import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/UI/Components/type_bar.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../Constants/constance_data.dart';
import 'package:sizer/sizer.dart';

class BookInfo extends StatefulWidget {
  final int index;

  BookInfo(this.index);

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ConstanceData.Motivational[widget.index].name ?? "",
          style: Theme.of(context).textTheme.headline5,
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
        child: SingleChildScrollView(
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
                        imageUrl:
                        ConstanceData.Motivational[widget.index].image ?? "",
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
                            ConstanceData.Motivational[widget.index].name ?? "",
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
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
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(
                                width: 1.h,
                              ),
                              Text(
                                "${ConstanceData.Motivational[widget.index].author ?? ""}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(color: Colors.blueAccent),
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
              BookPublishinDetails(widget: widget),
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
              TypeBar(),
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
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 2.5.h,
                      // color: Colors.grey.shade200,
                    ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 1.9.h,
                      // color: Colors.grey.shade200,
                    ),
              ),
              SizedBox(
                height: 1.h,
              ),
              ExpandableText(
                ConstanceData.testing,
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
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 2.5.h,
                      // color: Colors.grey.shade200,
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
              Text(
                "Write a Review",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.blueAccent),
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
                  children: [
                    Text(
                      'Reviews (${ConstanceData.reviews.length})',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontSize: 2.5.h,
                            // color: Colors.grey.shade200,
                          ),
                    ),
                    Text(
                      'More >',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontSize: 1.5.h,
                            color: Colors.blueAccent,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${ConstanceData.reviews[0].name}',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 2.h,
                      // color: Colors.grey.shade200,
                    ),
                  ),
                  RatingBar.builder(
                      itemSize: 5.w,
                      initialRating:
                      ConstanceData.reviews[0].rating ?? 3,
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
                '${ConstanceData.reviews[0].note}',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                  fontSize: 2.h,
                  // color: Colors.grey.shade200,
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
            ],
          ),
        ),
      ),
    );
  }
}

class BookPublishinDetails extends StatelessWidget {
  const BookPublishinDetails({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final BookInfo widget;

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
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              RatingBar.builder(
                  itemSize: 5.w,
                  initialRating:
                  ConstanceData.Motivational[widget.index].rating ?? 3,
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
                '(59)',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 2.h,
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
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                '326 pages | 5 hrs',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 2.h,
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
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                'English',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 2.h,
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
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                'Book',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 2.h,
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
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              GestureDetector(
                onTap: (){
                  Navigation.instance.navigate('/writerInfo',args: 0);
                },
                child: Text(
                  'Simon & Schuster',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 2.h,
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
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 2.h,
                        color: Colors.grey.shade400,
                      ),
                ),
              ),
              SizedBox(
                width: 3.h,
              ),
              Text(
                'August 18, 2012',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 2.h,
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
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 2.h,
                        // color: Colors.blue,
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
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 2.h,
                        // color: Colors.blue,
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
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 2.h,
                        // color: Colors.blue,
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
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  fontSize: 2.5.h,
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
          style: Theme.of(context).textTheme.headline5?.copyWith(
                fontSize: 2.5.h,
                color: Colors.blue,
              ),
        ),
      ),
    );
  }
}
