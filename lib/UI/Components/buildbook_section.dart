import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Model/library_book_details.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Model/enote_banner.dart';
import '../../Model/home_banner.dart';
import '../../Storage/data_provider.dart';
import 'book_bar_item.dart';

class BuildBookBarSection extends StatelessWidget {
  final Function(Book data) show;
  const BuildBookBarSection({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, currentData, _) {
      return (currentData.bannerList![currentData.currentTab].isEmpty)
          ? Container()
          : SizedBox(
              width: double.infinity,
              height: 19.h,
              child: Center(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  // itemCount: filterByCategory(
                  //         currentData.bannerList![currentData.currentTab],
                  //         currentData)
                  //     .length,
                  itemCount:
                      currentData.bannerList![currentData.currentTab].length,
                  itemBuilder: (cont, count) {
                    // HomeBanner data = filterByCategory(
                    //     currentData.bannerList![currentData.currentTab],
                    //     currentData)[count];
                    Book data =
                        currentData.bannerList![currentData.currentTab][count];
                    return GestureDetector(
                      onTap: () {
                        show(data);
                      },
                      child: bookBaritem(data: data),
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
}

class BuildEnoteBarSection extends StatelessWidget {
  final Function(EnoteBanner data) show;
  const BuildEnoteBarSection({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, currentData, _) {
      return currentData.enotesBanner.isEmpty
          ? Container()
          : SizedBox(
              width: double.infinity,
              height: 19.h,
              child: Center(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  // itemCount: filterByCategory(
                  //         currentData.bannerList![currentData.currentTab],
                  //         currentData)
                  //     .length,
                  itemCount: currentData.enotesBanner.length,
                  itemBuilder: (cont, count) {
                    // HomeBanner data = filterByCategory(
                    //     currentData.bannerList![currentData.currentTab],
                    //     currentData)[count];
                    EnoteBanner data = currentData.enotesBanner[count];
                    return GestureDetector(
                      onTap: () {
                        show(data);
                      },
                      child: enoteBaritem(data: data),
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
}
