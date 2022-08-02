import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/UI/Components/banner_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:search_page/search_page.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/constance_data.dart';
import '../../../Model/book.dart';
import '../../Components/books_section.dart';
import '../../Components/category_bar.dart';
import '../../Components/new_searchbar.dart';
import '../../Components/type_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Colors.grey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // const TypeBar(),
            NewSearchBar(),
            SizedBox(
              height: 1.h,
            ),
            NewCategoryBar(context),
            SizedBox(
              height: 1.h,
            ),
            buildBooksBar(context),
            // const BannerHome(),
            // SizedBox(
            //   height: 1.h,
            // ),
            // const CategoryBar(),
            // SizedBox(
            //   height: 1.h,
            // ),
            // BooksSection(
            //   title: 'Bestselling Books',
            //   list: ConstanceData.bestselling,
            // ),
            // SizedBox(
            //   height: 1.h,
            // ),
            // BooksSection(
            //   title: 'Critically Acclaimed',
            //   list: ConstanceData.critics,
            // ),
            // SizedBox(
            //   height: 1.h,
            // ),
          ],
        ),
      ),
    );
  }

  SizedBox buildBooksBar(BuildContext context) {
    return SizedBox(
            width: double.infinity,
            height: 19.h,
            child: Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: getTheList().length,
                itemBuilder: (cont, count) {
                  Book data = getTheList()[count];
                  return Card(
                    color: Colors.transparent,
                    child: Container(
                      height: 20.h,
                      width: 55.w,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                // color: Colors.green,
                                image: DecorationImage(
                                  image: NetworkImage(data.image ?? ''),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: const BoxDecoration(
                                color: ConstanceData.cardBookColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                          fontSize: 2.5.h,
                                          color: Colors.white,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    data.author ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          fontSize: 1.5.h,
                                          color: Colors.white,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
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
                                      }),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0),
                                    ),
                                    color: Colors.white,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      // decoration: ,
                                      child: Text(
                                        'Rs. 1500',
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
                                ],
                              ),
                            ),
                          ),
                        ],
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
  }

  SizedBox NewCategoryBar(BuildContext context) {
    return SizedBox(
      height: 3.h,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ConstanceData.categories.length,
              itemBuilder: (cont, count) {
                var data = ConstanceData.categories[count];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = count;
                      print(count);
                    });
                  },
                  child: Container(
                    // width: 18.w,
                    padding: EdgeInsets.all(0.2.h),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color:
                              selected == count ? Colors.green : Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        data,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              fontSize: 1.5.h,
                              color: selected == count
                                  ? Colors.green
                                  : Colors.white,
                            ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 10.w,
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigation.instance.navigate('/categories');
            },
            child: Container(
              width: 13.w,
              height: 3.h,
              padding: EdgeInsets.all(0.2.h),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                child: Text(
                  'More ->',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 1.5.h,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
}


