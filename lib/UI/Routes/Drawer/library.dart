// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Model/bookmark.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../Components/library_card_item.dart';
import 'library_bought_screen.dart';
import 'library_bookmark_screen.dart';

class Librarypage extends StatefulWidget {
  const Librarypage({Key? key}) : super(key: key);

  @override
  State<Librarypage> createState() => _LibrarypageState();
}

class _LibrarypageState extends State<Librarypage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Purchased & Bookmarked',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.black,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            SizedBox(height: 3.h),
            Text(
              'Your Digital Collection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Access your purchased books and bookmarked favorites',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: Consumer<DataProvider>(
                builder: (context, data, _) {
                  return Column(
                    children: [
                      // Already Bought Card
                      _buildLibraryCard(
                        title: 'Already Bought',
                        subtitle: 'Your purchased books and magazines',
                        icon: Icons.library_books,
                        itemCount: _getBoughtCount(data),
                        color: Colors.yellow,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LibraryBoughtScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 3.h),
                      // Bookmarks Card
                      _buildLibraryCard(
                        title: 'Bookmarks',
                        subtitle: 'Your saved favorite books',
                        icon: Icons.bookmark,
                        itemCount: _getBookmarkCount(data),
                        color: Colors.white,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LibraryBookmarkScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 4.h),
                      // Statistics Section
                      // _buildStatisticsSection(data),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required int itemCount,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  SizedBox(width: 1.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: color,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(DataProvider data) {
    final totalBooks = _getBoughtCount(data);
    final totalBookmarks = _getBookmarkCount(data);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Library Statistics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Total Books',
                totalBooks.toString(),
                Icons.menu_book,
              ),
              _buildStatItem(
                'Bookmarked',
                totalBookmarks.toString(),
                Icons.bookmark,
              ),
              _buildStatItem(
                'Reading Progress',
                '${(totalBooks > 0 ? (totalBooks * 0.3).round() : 0)}%',
                Icons.trending_up,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white60,
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white60,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  int _getBoughtCount(DataProvider data) {
    if (data.currentTab == 2) {
      return data.myBooks.length;
    }
    return data.myBooks
        .where((element) =>
            (element.book_format == "e-book" && data.currentTab == 0) ||
            (element.book_format == "magazine" && data.currentTab == 1))
        .length;
  }

  int _getBookmarkCount(DataProvider data) {
    if (data.currentTab == 2) {
      return data.bookmarks.length;
    }
    return data.bookmarks
        .where((element) =>
            (element.book_format == "e-book" && data.currentTab == 0) ||
            (element.book_format == "magazine" && data.currentTab == 1))
        .length;
  }
}
