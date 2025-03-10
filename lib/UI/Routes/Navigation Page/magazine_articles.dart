import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Model/article.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/navigator.dart';
import '../../../Model/book_chapter.dart';
import '../../../Model/book_details.dart';
import '../../../Networking/api_provider.dart';
import '../../Components/article_item_card.dart';
import '../../Components/blurred_card_item.dart';
import '../../Components/magazine_view_section.dart';

class MagazineArticles extends StatefulWidget {
  final int id;

  MagazineArticles(this.id);

  @override
  State<MagazineArticles> createState() => _MagazineArticlesState();
}

class _MagazineArticlesState extends State<MagazineArticles> {
  Book? bookDetails;
  List<BookWithAdsChapter> chapters = [];

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
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontSize: 17.sp,
              ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: bookDetails == null
            ? Container()
            : magazineViewSection(bookDetails: bookDetails),
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
        .fetchBookChaptersWithAds(widget.id.toString() ?? '3');
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
