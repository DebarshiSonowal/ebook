import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Model/library_book_details.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';

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
      // Check if we have banner data for current tab
      bool hasData = currentData.bannerList != null &&
          currentData.bannerList!.isNotEmpty &&
          currentData.currentTab < currentData.bannerList!.length &&
          currentData.bannerList![currentData.currentTab].isNotEmpty;

      if (!hasData) {
        return _buildBookBannerShimmer();
      }

      return SizedBox(
        width: double.infinity,
        height: 19.h,
        child: Center(
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: currentData.bannerList![currentData.currentTab].length,
            itemBuilder: (cont, count) {
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

  Widget _buildBookBannerShimmer() {
    return SizedBox(
      width: double.infinity,
      height: 19.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Show 3 shimmer items
        itemBuilder: (context, index) {
          return Container(
            width: 75.w,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
    );
  }
}

class BuildEnoteBarSection extends StatelessWidget {
  final Function(EnoteBanner data) show;
  const BuildEnoteBarSection({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, currentData, _) {
      bool hasData = currentData.enotesBanner.isNotEmpty;

      if (!hasData) {
        return _buildEnoteBannerShimmer();
      }

      return SizedBox(
        width: double.infinity,
        height: 19.h,
        child: Center(
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: currentData.enotesBanner.length,
            itemBuilder: (cont, count) {
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

  Widget _buildEnoteBannerShimmer() {
    return SizedBox(
      width: double.infinity,
      height: 19.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Show 3 shimmer items
        itemBuilder: (context, index) {
          return Container(
            width: 75.w,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
    );
  }
}
