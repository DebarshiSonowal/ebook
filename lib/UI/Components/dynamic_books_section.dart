import 'package:ebook/Storage/common_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../Constants/constance_data.dart';
import '../../Model/home_section.dart';
import '../../Storage/data_provider.dart';
import 'books_section.dart';

class DynamicBooksSection extends StatelessWidget {
  const DynamicBooksSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommonProvider, DataProvider>(
      builder: (context, commonData, dataProvider, _) {
        List<HomeSection> currentSection = [];
        bool isLoading = false;

        switch (dataProvider.currentTab) {
          case 0:
            currentSection = commonData.eBookSection;
            isLoading = commonData.isEbookSectionLoading;
            break;
          case 1:
            currentSection = commonData.magazineSection;
            isLoading = commonData.isMagazineSectionLoading;
            break;
          case 2:
            currentSection = commonData.eNotesSection;
            isLoading = commonData.isEnotesSectionLoading;
            break;
        }

        // Show shimmer loading if still loading
        if (isLoading) {
          return _buildShimmerSections();
        }

        // If not loading and empty, show nothing or empty state
        if (currentSection.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (cont, index) {
            return BooksSection(
              title: currentSection[index].title ?? 'Bestselling Books',
              list: currentSection[index].book ?? [],
              show: (data) {
                ConstanceData.show(context, data);
              },
            );
          },
          separatorBuilder: (cont, ind) {
            return SizedBox(
              height: 0.1.h,
            );
          },
          itemCount: currentSection.length,
        );
      },
    );
  }

  Widget _buildShimmerSections() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _buildShimmerSection();
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 0.1.h,
        );
      },
      itemCount: 3, // Show 3 shimmer sections
    );
  }

  Widget _buildShimmerSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 2.w),
      height: 55.h,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 9.h,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 60.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 4, // Show 4 shimmer book items
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _buildShimmerBookItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBookItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 35.w,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 0.75,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                margin: EdgeInsets.symmetric(horizontal: 1.5.w),
              ),
            ),
            SizedBox(height: 0.5.h),
            Padding(
              padding: EdgeInsets.only(left: 1.w),
              child: Container(
                width: 25.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 0.3.h),
            Padding(
              padding: EdgeInsets.only(left: 1.w),
              child: Container(
                width: 20.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                      5,
                      (index) => Container(
                            width: 3.w,
                            height: 3.w,
                            margin: EdgeInsets.only(right: 0.5.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          )),
                ),
                Container(
                  width: 18.sp,
                  height: 18.sp,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
          ],
        ),
      ),
    );
  }
}

class DynamicEnotesSection extends StatelessWidget {
  const DynamicEnotesSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommonProvider, DataProvider>(
      builder: (context, commonData, dataProvider, _) {
        List<HomeSection> currentSection = [];
        bool isLoading = false;

        switch (dataProvider.currentTab) {
          case 0:
            currentSection = commonData.eBookSection;
            isLoading = commonData.isEbookSectionLoading;
            break;
          case 1:
            currentSection = commonData.magazineSection;
            isLoading = commonData.isMagazineSectionLoading;
            break;
          case 2:
            currentSection = commonData.eNotesSection;
            isLoading = commonData.isEnotesSectionLoading;
            break;
        }

        // Show shimmer loading if still loading
        if (isLoading) {
          return _buildShimmerSections();
        }

        // If not loading and empty, show nothing or empty state
        if (currentSection.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (cont, index) {
            return BooksSection(
              title: currentSection[index].title ?? 'Bestselling Books',
              list: currentSection[index].book ?? [],
              show: (data) {
                ConstanceData.show(context, data);
              },
            );
          },
          separatorBuilder: (cont, ind) {
            return SizedBox(
              height: 0.1.h,
            );
          },
          itemCount: currentSection.length,
        );
      },
    );
  }

  Widget _buildShimmerSections() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _buildShimmerSection();
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 0.1.h,
        );
      },
      itemCount: 3, // Show 3 shimmer sections
    );
  }

  Widget _buildShimmerSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 2.w),
      height: 55.h,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 9.h,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 60.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 4, // Show 4 shimmer book items
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _buildShimmerBookItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBookItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 35.w,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 0.75,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                margin: EdgeInsets.symmetric(horizontal: 1.5.w),
              ),
            ),
            SizedBox(height: 0.5.h),
            Padding(
              padding: EdgeInsets.only(left: 1.w),
              child: Container(
                width: 25.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 0.3.h),
            Padding(
              padding: EdgeInsets.only(left: 1.w),
              child: Container(
                width: 20.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                      5,
                      (index) => Container(
                            width: 3.w,
                            height: 3.w,
                            margin: EdgeInsets.only(right: 0.5.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          )),
                ),
                Container(
                  width: 18.sp,
                  height: 18.sp,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
          ],
        ),
      ),
    );
  }
}
