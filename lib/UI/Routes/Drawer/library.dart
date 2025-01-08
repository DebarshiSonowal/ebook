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

class Librarypage extends StatefulWidget {
  const Librarypage({Key? key}) : super(key: key);

  @override
  State<Librarypage> createState() => _LibrarypageState();
}

class _LibrarypageState extends State<Librarypage>
    with TickerProviderStateMixin {
  TabController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.white60,
          fontSize: 13.sp,
        ),
        controller: _controller,
        tabs: const [
          Tab(
            text: 'Already Bought',
          ),
          Tab(
            text: 'Bookmark',
          ),
        ],
      ),
      body: Container(
        color: ConstanceData.primaryColor,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 0.7.h, horizontal: 2.w),
        child: Consumer<DataProvider>(builder: (cont, data, _) {
          return GridView.builder(
              itemCount: data.libraryTab == 0
                  ? filteredList(data.myBooks, data.currentTab).length
                  : filteredBookmarkList(data.bookmarks, data.currentTab)
                      .length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 2.5,
                crossAxisSpacing: 10.w,
              ),
              itemBuilder: (context, count) {
                var current = data.libraryTab == 0
                    ? filteredList(data.myBooks, data.currentTab)[count]
                    : filteredBookmarkList(
                        data.bookmarks, data.currentTab)[count];
                return GestureDetector(
                  onTap: () {
                    if (data.libraryTab == 0) {
                      // Navigation.instance.navigate('/reading',
                      //     args: (data.myBooks[count].id) ?? 0);
                      // Navigation.instance
                      //     .navigate('/bookDetails', args: current.id ?? 0);
                      ConstanceData.show(context, current);
                    } else {
                      ConstanceData.showBookmarkItem(
                        context,
                        filteredBookmarkList(
                            data.bookmarks, data.currentTab)[count],
                      );
                    }
                  },
                  child: LibraryCardItem(
                    data: data,
                    count: count,
                    filteredBookmarkList:
                        filteredBookmarkList(data.bookmarks, data.currentTab),
                    filteredList: filteredList(data.myBooks, data.currentTab),
                  ),
                );
              });
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      length: 2,
      vsync: this,
    );
    Future.delayed(Duration.zero, () {
      fetchData();
    });
    _controller?.addListener(() {
      if (checkCondition(_controller?.index ?? 0)) {
        fetchData();
      }
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setLibraryTab(_controller?.index ?? 0);
    });
  }

  void fetchData() async {
    fetchBookmarks();
    fetchMyList();
    setState(() {});
  }

  bool checkCondition(int i) {
    if (i == 0 &&
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .myBooks
            .isEmpty) {
      return true;
    } else if (i == 1 &&
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .bookmarks
            .isEmpty) {
      return true;
    } else {
      return false;
    }
  }

// setMyBooks

  filteredList(List<Book> myBooks, int currentTab) {
    if (currentTab == 2) {
      return myBooks.toList();
    }
    return myBooks
            .where((element) =>
                (element.book_format == "e-book" && currentTab == 0) ||
                        (element.book_format == "magazine" && currentTab == 1)
                    ? true
                    : false)
            .toList() ??
        [];
  }

  filteredBookmarkList(List<BookmarkItem> bookmarks, int currentTab) {
    if (currentTab == 2) {
      return bookmarks.toList();
    }
    return bookmarks
            .where((element) =>
                (element.book_format == "e-book" && currentTab == 0) ||
                        (element.book_format == "magazine" && currentTab == 1)
                    ? true
                    : false)
            .toList() ??
        [];
  }

  Future<void> fetchBookmarks() async {
    Navigation.instance.navigate('/loadingDialog');
    if (Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .currentTab !=
        2) {
      final response = await ApiProvider.instance.fetchBookmark();
      if (response.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setToBookmarks(response.items ?? []);
        Navigation.instance.goBack();
      } else {
        Navigation.instance.goBack();
      }
    } else {
      final response = await ApiProvider.instance.fetchNoteBookmark();
      if (response.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setToBookmarks(response.items ?? []);
        Navigation.instance.goBack();
      } else {
        Navigation.instance.goBack();
      }
    }
  }

  void fetchMyList() async {
    Navigation.instance.navigate('/loadingDialog');
    if (Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .currentTab !=
        2) {
      final response1 = await ApiProvider.instance.fetchMyBooks();
      if (response1.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setMyBooks(response1.books ?? []);
        Navigation.instance.goBack();
      } else {
        Navigation.instance.goBack();
      }
    } else {
      final response1 = await ApiProvider.instance.getEnoteMyList();
      if (response1.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setMyBooks(response1.books ?? []);
        Navigation.instance.goBack();
      } else {
        Navigation.instance.goBack();
      }
    }
  }
}
