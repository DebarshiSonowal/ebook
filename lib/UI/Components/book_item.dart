import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/UI/Components/type_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import '../../Model/book.dart';

class BookItem extends StatelessWidget {
  const BookItem({
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
            padding: const EdgeInsets.only(top: 30),
            height: 80.h,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  height: 80.h,
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
                                data.name ?? "NA",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(color: Colors.white),
                              ),
                              SizedBox(height: 1.h),
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
                                    data.author ?? "NA",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(color: Colors.blue),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              RatingBar.builder(
                                  itemSize: 6.w,
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
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  Text(
                                    "673 pages",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 5,
                                    width: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Text(
                                    "English",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              SizedBox(
                                width: 50.w,
                                child: TypeBar(),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "#1 New York Times Bestseller",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Lorem Ipsum is simply dummy text of the printing and"
                                " typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(height: 1.h),
                              SizedBox(
                                width: double.infinity,
                                height: 4.5.h,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigation.instance.navigate(
                                          '/bookDetails',
                                          args: index);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue),
                                    ),
                                    child: Text(
                                      'Start Trial',
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
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigation.instance.navigate('/main');
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
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
                    imageUrl: data.image ?? "",
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        // height: 18.h,
        width: 27.w,
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              height: 15.h,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: data.image ?? "",
                fit: BoxFit.fill,
              ),
            ),
            Text(
              data.name ?? "",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Text(
              data.author ?? "",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(
              height: 0.5.h,
            ),
            RatingBar.builder(
              itemSize: 4.w,
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
              },
            ),
            SizedBox(
              height: 0.5.h,
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    color: Colors.grey.shade200,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
