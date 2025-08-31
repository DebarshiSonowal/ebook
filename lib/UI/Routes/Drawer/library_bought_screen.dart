import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../Components/library_card_item.dart';

class LibraryBoughtScreen extends StatefulWidget {
  const LibraryBoughtScreen({Key? key}) : super(key: key);

  @override
  State<LibraryBoughtScreen> createState() => _LibraryBoughtScreenState();
}

class _LibraryBoughtScreenState extends State<LibraryBoughtScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Already Bought',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: ConstanceData.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ConstanceData.primaryColor,
              ConstanceData.primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Consumer<DataProvider>(
                builder: (context, data, _) {
                  final filteredBooks =
                      _getFilteredBooks(data.myBooks, data.currentTab);

                  if (filteredBooks.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    color: ConstanceData.primaryColor,
                    backgroundColor: Colors.white,
                    strokeWidth: 2,
                    onRefresh: () async {
                      await fetchMyList();
                    },
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredBooks.length,
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 2.8,
                        crossAxisSpacing: 4.w,
                        mainAxisSpacing: 2.h,
                      ),
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        return GestureDetector(
                          onTap: () {
                            ConstanceData.show(context, book);
                          },
                          child: _buildBookCard(book),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.library_books_outlined,
              size: 48.sp,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'No books purchased yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Start exploring and buy your first book!',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
              Radius.circular(12)
          ),
          child: CachedNetworkImage(
            imageUrl: book.profile_pic ?? '',
            fit: BoxFit.fill,
            placeholder: (context, url) => Container(
              color: Colors.white.withOpacity(0.1),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white70,
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.white.withOpacity(0.1),
              child: Icon(
                Icons.book_outlined,
                color: Colors.white70,
                size: 24.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Book> _getFilteredBooks(List<Book> books, int currentTab) {
    if (currentTab == 2) {
      return books.toList();
    }
    return books.where((element) =>
    (element.book_format == "e-book" && currentTab == 0) ||
        (element.book_format == "magazine" && currentTab == 1)
    ).toList();
  }

  Future<void> fetchMyList() async {
    setState(() {
      isLoading = true;
    });

    try {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);

      if (dataProvider.currentTab != 2) {
        final response = await ApiProvider.instance.fetchMyBooks();
        if (response.status ?? false) {
          dataProvider.setMyBooks(response.books ?? []);
        }
      } else {
        final response = await ApiProvider.instance.getEnoteMyList();
        if (response.status ?? false) {
          dataProvider.setMyBooks(response.books ?? []);
        }
      }
    } catch (e) {
      debugPrint('Error fetching my books: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}