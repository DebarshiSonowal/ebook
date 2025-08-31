import 'dart:async';

import 'package:ebook/Storage/common_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../Constants/constance_data.dart';
import '../../Model/home_section.dart';
import '../../Storage/data_provider.dart';
import 'books_section.dart';

class DynamicBooksSection extends StatefulWidget {
  const DynamicBooksSection({
    Key? key,
  }) : super(key: key);

  @override
  State<DynamicBooksSection> createState() => _DynamicBooksSectionState();
}

class _DynamicBooksSectionState extends State<DynamicBooksSection> { 
  Timer? _loadingTimeout;
  static const int _timeoutDuration = 13; // 15 seconds timeout
  int _currentTab = -1; // Track current tab to restart timer when tab changes

  @override
  void initState() {
    super.initState();
    _startLoadingTimeout();
  }

  @override
  void dispose() {
    _loadingTimeout?.cancel();
    super.dispose();
  }

  void _startLoadingTimeout() {
    _loadingTimeout?.cancel(); // Cancel existing timer first
    _loadingTimeout = Timer(const Duration(seconds: _timeoutDuration), () {
      if (mounted) {
        final commonProvider =
            Provider.of<CommonProvider>(context, listen: false);
        final dataProvider = Provider.of<DataProvider>(context, listen: false);

        print(
            "🔥 TIMEOUT: Force stopping loading for tab ${dataProvider.currentTab}");

        // Force stop loading based on current tab
        switch (dataProvider.currentTab) {
          case 0:
            if (commonProvider.isEbookSectionLoading) {
              print("🔥 TIMEOUT: Stopping e-book loading");
              commonProvider.forceStopEbookLoading();
            }
            break;
          case 1:
            if (commonProvider.isMagazineSectionLoading) {
              print("🔥 TIMEOUT: Stopping magazine loading");
              commonProvider.forceStopMagazineLoading();
            }
            break;
          case 2:
            if (commonProvider.isEnotesSectionLoading) {
              print("🔥 TIMEOUT: Stopping e-notes loading");
              commonProvider.forceStopEnotesLoading();
            }
            break;
        }
      }
    });
    print(
        "🔥 TIMER: Started ${_timeoutDuration}s timeout for DynamicBooksSection");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommonProvider, DataProvider>(
      builder: (context, commonData, dataProvider, _) {
        // Restart timer if tab changed
        if (_currentTab != dataProvider.currentTab) {
          _currentTab = dataProvider.currentTab;
          print("🔥 TAB CHANGED: Restarting timeout for tab $_currentTab");
          _startLoadingTimeout();
        }

        List<HomeSection> currentSection = [];
        bool isLoading = false;
        bool hasError = false;

        switch (dataProvider.currentTab) {
          case 0:
            currentSection = commonData.eBookSection;
            isLoading = commonData.isEbookSectionLoading;
            hasError = commonData.hasEbookError;
            break;
          case 1:
            currentSection = commonData.magazineSection;
            isLoading = commonData.isMagazineSectionLoading;
            hasError = commonData.hasMagazineError;
            break;
          case 2:
            currentSection = commonData.eNotesSection;
            isLoading = commonData.isEnotesSectionLoading;
            hasError = commonData.hasEnotesError;
            break;
        }

        // FORCE FIX: If we have sections but loading is still true, force stop loading
        if (isLoading && currentSection.isNotEmpty) {
          print(
              "🔥 FORCE FIX: Have ${currentSection.length} sections but still loading, forcing stop for tab ${dataProvider.currentTab}");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (dataProvider.currentTab) {
              case 0:
                commonData.forceStopEbookLoading();
                break;
              case 1:
                commonData.forceStopMagazineLoading();
                break;
              case 2:
                commonData.forceStopEnotesLoading();
                break;
            }
          });
        }

        print(
            "🔥 BUILD: Tab ${dataProvider.currentTab} - Loading: $isLoading, Error: $hasError, Sections: ${currentSection.length}");

        // Cancel timeout if loading is complete
        if (!isLoading && _loadingTimeout?.isActive == true) {
          _loadingTimeout?.cancel();
          print("🔥 TIMER: Cancelled timeout - loading complete");
        }

        // Show error state if there's an error
        if (hasError && !isLoading) {
          print("🔥 UI: Showing error state");
          return _buildErrorState();
        }

        // Show shimmer loading if still loading
        if (isLoading) {
          print("🔥 UI: Showing shimmer loading");
          return _buildShimmerSections();
        }

        // If not loading and empty, show nothing or empty state
        if (currentSection.isEmpty) {
          print("🔥 UI: Showing empty state");
          return const SizedBox.shrink();
        }

        print("🔥 UI: Showing ${currentSection.length} sections");
        return RefreshIndicator(
          onRefresh: () async {
            final commonProvider =
                Provider.of<CommonProvider>(context, listen: false);
            final dataProvider =
                Provider.of<DataProvider>(context, listen: false);
            commonProvider.resetLoadingStates();
            _startLoadingTimeout();
          },
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
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
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 12.w,
            color: Colors.grey,
          ),
          SizedBox(height: 2.h),
          Text(
            'Failed to load content',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 1.h),
          ElevatedButton(
            onPressed: () {
              final commonProvider =
                  Provider.of<CommonProvider>(context, listen: false);
              commonProvider.resetLoadingStates();
              _startLoadingTimeout();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
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

class DynamicEnotesSection extends StatefulWidget {
  const DynamicEnotesSection({
    Key? key,
  }) : super(key: key);

  @override
  State<DynamicEnotesSection> createState() => _DynamicEnotesSectionState();
}

class _DynamicEnotesSectionState extends State<DynamicEnotesSection> {
  Timer? _loadingTimeout;
  static const int _timeoutDuration = 15; // 15 seconds timeout
  int _currentTab = -1; // Track current tab to restart timer when tab changes

  @override
  void initState() {
    super.initState();
    _startLoadingTimeout();
  } 
  @override
  void dispose() {
    _loadingTimeout?.cancel();
    super.dispose();
  }

  void _startLoadingTimeout() {
    _loadingTimeout?.cancel(); // Cancel existing timer first
    _loadingTimeout = Timer(const Duration(seconds: _timeoutDuration), () {
      if (mounted) {
        final commonProvider =
            Provider.of<CommonProvider>(context, listen: false);
        final dataProvider = Provider.of<DataProvider>(context, listen: false);

        print(
            "🔥 TIMEOUT: Force stopping loading for tab ${dataProvider.currentTab}");

        // Force stop loading based on current tab
        switch (dataProvider.currentTab) {
          case 0:
            if (commonProvider.isEbookSectionLoading) {
              print("🔥 TIMEOUT: Stopping e-book loading");
              commonProvider.forceStopEbookLoading();
            }
            break;
          case 1:
            if (commonProvider.isMagazineSectionLoading) {
              print("🔥 TIMEOUT: Stopping magazine loading");
              commonProvider.forceStopMagazineLoading();
            }
            break;
          case 2:
            if (commonProvider.isEnotesSectionLoading) {
              print("🔥 TIMEOUT: Stopping e-notes loading");
              commonProvider.forceStopEnotesLoading();
            }
            break;
        }
      }
    });
    print(
        "🔥 TIMER: Started ${_timeoutDuration}s timeout for DynamicEnotesSection");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommonProvider, DataProvider>(
      builder: (context, commonData, dataProvider, _) {
        // Restart timer if tab changed
        if (_currentTab != dataProvider.currentTab) {
          _currentTab = dataProvider.currentTab;
          print("🔥 TAB CHANGED: Restarting timeout for tab $_currentTab");
          _startLoadingTimeout();
        }

        List<HomeSection> currentSection = [];
        bool isLoading = false;
        bool hasError = false;

        switch (dataProvider.currentTab) {
          case 0:
            currentSection = commonData.eBookSection;
            isLoading = commonData.isEbookSectionLoading;
            hasError = commonData.hasEbookError;
            break;
          case 1:
            currentSection = commonData.magazineSection;
            isLoading = commonData.isMagazineSectionLoading;
            hasError = commonData.hasMagazineError;
            break;
          case 2:
            currentSection = commonData.eNotesSection;
            isLoading = commonData.isEnotesSectionLoading;
            hasError = commonData.hasEnotesError;
            break;
        }

        // FORCE FIX: If we have sections but loading is still true, force stop loading
        if (isLoading && currentSection.isNotEmpty) {
          print(
              "🔥 FORCE FIX: Have ${currentSection.length} sections but still loading, forcing stop for tab ${dataProvider.currentTab}");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (dataProvider.currentTab) {
              case 0:
                commonData.forceStopEbookLoading();
                break;
              case 1:
                commonData.forceStopMagazineLoading();
                break;
              case 2:
                commonData.forceStopEnotesLoading();
                break;
            }
          });
        }

        print(
            "🔥 BUILD: Tab ${dataProvider.currentTab} - Loading: $isLoading, Error: $hasError, Sections: ${currentSection.length}");

        // Cancel timeout if loading is complete
        if (!isLoading && _loadingTimeout?.isActive == true) {
          _loadingTimeout?.cancel();
          print("🔥 TIMER: Cancelled timeout - loading complete");
        }

        // Show error state if there's an error
        if (hasError && !isLoading) {
          print("🔥 UI: Showing error state");
          return _buildErrorState();
        }

        // Show shimmer loading if still loading
        if (isLoading) {
          print("🔥 UI: Showing shimmer loading");
          return _buildShimmerSections();
        }

        // If not loading and empty, show nothing or empty state
        if (currentSection.isEmpty) {
          print("🔥 UI: Showing empty state");
          return const SizedBox.shrink();
        }

        print("🔥 UI: Showing ${currentSection.length} sections");
        return RefreshIndicator(
          onRefresh: () async {
            final commonProvider =
                Provider.of<CommonProvider>(context, listen: false);
            final dataProvider =
                Provider.of<DataProvider>(context, listen: false);
            commonProvider.resetLoadingStates();
            _startLoadingTimeout();
          },
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
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
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 12.w,
            color: Colors.grey,
          ),
          SizedBox(height: 2.h),
          Text(
            'Failed to load content',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 1.h),
          ElevatedButton(
            onPressed: () {
              final commonProvider =
                  Provider.of<CommonProvider>(context, listen: false);
              commonProvider.resetLoadingStates();
              _startLoadingTimeout();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
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
