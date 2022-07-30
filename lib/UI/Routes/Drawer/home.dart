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
            const TypeBar(),
            SizedBox(
              height: 1.h,
            ),
            const BannerHome(),
            SizedBox(
              height: 1.h,
            ),
            const CategoryBar(),
            SizedBox(
              height: 1.h,
            ),
            BooksSection(
              title: 'Bestselling Books',
              list: ConstanceData.bestselling,
            ),
            SizedBox(
              height: 1.h,
            ),
            BooksSection(
              title: 'Critically Acclaimed',
              list: ConstanceData.critics,
            ),
            SizedBox(
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }
}
