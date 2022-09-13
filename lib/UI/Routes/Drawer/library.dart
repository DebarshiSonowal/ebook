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
                  ? data.cartBooks.length
                  : data.bookmarks.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 2.5,
              ),
              itemBuilder: (context, count) {
                var current = data.libraryTab == 0
                    ? data.cartBooks[count]
                    : data.bookmarks[count];
                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    child: CachedNetworkImage(
                      imageUrl: data.libraryTab == 0
                          ? data.cartBooks[count].profile_pic ?? ""
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
    fetchData();
    _controller = TabController(
      length: 2,
      vsync: this,
    );
    _controller?.addListener(() {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setLibraryTab(_controller?.index ?? 0);
    });
  }

  void fetchData() async {
    final response = await ApiProvider.instance.fetchBookmark();
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setToBookmarks(response.items ?? []);
    }
  }
}
