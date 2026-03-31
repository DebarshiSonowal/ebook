import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebook/Model/library_home_models.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/constance_data.dart';
import 'library_details_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Utility/share_helper.dart';

class LibraryHomeScreen extends StatefulWidget {
  const LibraryHomeScreen({Key? key}) : super(key: key);

  @override
  State<LibraryHomeScreen> createState() => _LibraryHomeScreenState();
}

class _LibraryHomeScreenState extends State<LibraryHomeScreen> {
  bool _isLoading = true;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    // Fetch Banners
    final bannerResponse = await ApiProvider.instance.getLibraryHomeBanners();
    if (bannerResponse.success) {
      dataProvider.setLibraryHomeBanners(bannerResponse.result);
    }

    // Fetch Sections
    final sectionResponse = await ApiProvider.instance.getLibraryHomeSections();
    if (sectionResponse.success) {
      dataProvider.setLibraryHomeSections(sectionResponse.result);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _refreshController.refreshCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstanceData.primaryColor,
      appBar: AppBar(
        centerTitle:true,
        title: Row(
            mainAxisAlignment:MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 7.h,
              child: Center(
                child: Image.asset(
                  ConstanceData.primaryIcon,
                  height: 6.h,
                  width: 6.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              "e-Libraries",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: ConstanceData.primaryColor,
        elevation: 0,
        // centerTitle: true,
        actions: [
          IconButton(
            onPressed: _shareLibraryHome,
            icon: Icon(
              Icons.share_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 2.w),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/librarySearchScreen');
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : SmartRefresher(
              enablePullDown: true,
              header: const WaterDropHeader(
                waterDropColor: Colors.white,
                complete: Text(
                  "Refresh Completed",
                  style: TextStyle(color: Colors.white),
                ),
                failed: Text(
                  "Refresh Failed",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              controller: _refreshController,
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBanners(),
                    _buildSections(),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ),
    );
  }

  void _shareLibraryHome() async {
    try {
      const String shareUrl = "https://tratri.in/link?format=library_home";
      final String shareText = "$shareUrl";

      await ShareHelper.shareFromAppBar(shareText, context: context);
    } catch (e) {
      debugPrint('Error sharing library home: $e');
      // Fallback to simple share
      await Share.share(
        "Explore a world of knowledge at our e-Libraries! Check it out here: https://tratri.in/link?format=library_home",
        subject: "Join our e-Library",
      );
    }
  }

  Widget _buildBanners() {
    return Consumer<DataProvider>(
      builder: (context, data, child) {
        if (data.libraryHomeBanners.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: CarouselSlider.builder(
            itemCount: data.libraryHomeBanners.length,
            options: CarouselOptions(
              height: 22.h,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 1500),
              autoPlayCurve: Curves.fastOutSlowIn,
            ),
            itemBuilder: (context, index, realIndex) {
              final banner = data.libraryHomeBanners[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LibraryDetailsScreen(
                        id: banner.id,
                      ),
                    ),
                  );
                },
                child: banner.template == 'temp2'
                    ? _buildTemp2(banner)
                    : _buildTemp1(banner),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTemp1(LibraryHomeBanner data) {
    return Container(
      decoration: BoxDecoration(
        color: ConstanceData.cardBookColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: CachedNetworkImage(
                imageUrl: data.profilePic,
                fit: BoxFit.cover,
                height: double.infinity,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[900]),
                errorWidget: (context, url, error) => const Icon(
                  Icons.library_books,
                  color: Colors.white24,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 12.sp,
                          color: Colors.white54,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            data.ownerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white60,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: double.tryParse(data.averageRating) ?? 0.0,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 16.sp,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          data.averageRating,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemp2(LibraryHomeBanner data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: data.bannerPic,
          fit: BoxFit.fitWidth,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => Container(color: Colors.grey[200]),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildSections() {
    return Consumer<DataProvider>(
      builder: (context, data, child) {
        if (data.libraryHomeSections.isEmpty) return const SizedBox.shrink();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.libraryHomeSections.length,
          itemBuilder: (context, index) {
            final section = data.libraryHomeSections[index];
            return _buildSectionItem(section);
          },
        );
      },
    );
  }

  Widget _buildSectionItem(LibraryHomeSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 1.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                section.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: Colors.white54,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            itemCount: section.libraries.length,
            itemBuilder: (context, index) {
              final library = section.libraries[index];
              return _buildLibraryCard(library);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryCard(LibraryHomeBanner library) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LibraryDetailsScreen(
              id: library.id,
            ),
          ),
        );
      },
      child: Container(
        width: 40.w,
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 22.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ConstanceData.cardBookColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: library.profilePic,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[900]),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.library_books,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      library.libraryType,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    library.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 13.sp),
                      SizedBox(width: 1.w),
                      Text(
                        library.averageRating,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${library.noOfBooks} Books',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.2.h),
                  Row(
                    children: [
                      Icon(Icons.group_outlined, color: Colors.white60, size: 12.sp),
                      SizedBox(width: 1.w),
                      Text(
                        '${library.totalMembers} Members',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white60,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
