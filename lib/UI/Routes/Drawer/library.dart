import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:ebook/UI/Components/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';

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
                  ? data.myBooks.length
                  : data.bookmarks.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 2.5,
              ),
              itemBuilder: (context, count) {
                var current = data.libraryTab == 0
                    ? data.myBooks[count]
                    : data.bookmarks[count];
                return GestureDetector(
                  onTap: () {
                    Navigation.instance.navigate('/bookDetails',
                        args: data.myBooks[count].id ?? 0);
                  },
                  child: Card(
                    child: CachedNetworkImage(
                      imageUrl: data.libraryTab == 0
                          ? data.myBooks[count].profile_pic ?? ""
                          : data.bookmarks[count].profile_pic ?? "",
                      fit: BoxFit.fill,
                    ),
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
    Navigation.instance.navigate('/loadingDialog');
    if ((_controller?.index ?? 0) == 1) {
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
    }
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
}
