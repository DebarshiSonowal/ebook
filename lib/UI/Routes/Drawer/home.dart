import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/UI/Components/banner_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/constance_data.dart';
import '../../Components/books_section.dart';
import '../../Components/category_bar.dart';
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
            NewCategoryBar(context),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              width: double.infinity,
              height: 20.h,
              child: ListView.builder(
                  itemCount: ConstanceData.categories.length,
                  itemBuilder: (cont,count){
                return Card(
                  child: Row(
                    children: [
                        Container(
                          
                        ),
                    ],
                  ),
                );
              }),
            ),
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
                                color: selected == count
                                    ? Colors.green
                                    : Colors.black,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              data,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
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
                  onTap: () {},
                  child: Container(
                    width: 13.w,
                    height: 3.h,
                    padding: EdgeInsets.all(0.2.h),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: Text(
                        'More ->',
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.headline5?.copyWith(
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
}
