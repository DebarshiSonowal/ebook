import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Model/bookmark.dart';
import '../../../Model/home_banner.dart';
import '../../../Networking/api_provider.dart';
import '../../../Storage/data_provider.dart';
import '../../../Utility/share_helper.dart';
import '../../Components/library_card_item.dart';

class SpecificLibraryPage extends StatefulWidget {
  const SpecificLibraryPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<SpecificLibraryPage> createState() => _SpecificLibraryPageState();
}

class _SpecificLibraryPageState extends State<SpecificLibraryPage>
    with TickerProviderStateMixin {
  TabController? _controller;
  String? _libraryTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _libraryTitle ?? "Library",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.sp,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _shareLibrary();
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Container(
        color: ConstanceData.primaryColor,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 0.7.h, horizontal: 2.w),
        child: Consumer<DataProvider>(builder: (cont, data, _) {
          return Column(
            children: [
              TabBar(
                controller: _controller,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                tabs: [
                  Tab(text: 'E-Book'),
                  Tab(text: 'Magazine'),
                  Tab(text: 'E-Notes'),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: [
                    GridView.builder(
                      itemCount: data.library
                          .where(
                              (e) => e.book_format?.toLowerCase() == "e-book")
                          .toList()
                          .length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 2.5,
                        crossAxisSpacing: 10.w,
                      ),
                      itemBuilder: (context, count) {
                        var current = data.library
                            .where(
                                (e) => e.book_format?.toLowerCase() == "e-book")
                            .toList()[count];
                        return GestureDetector(
                          onTap: () {
                            ConstanceData.showBookDetails(context, current);
                          },
                          child: Card(
                            child: CachedNetworkImage(
                              imageUrl: current.profile_pic ?? "",
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                    GridView.builder(
                      itemCount: data.library
                          .where(
                              (e) => e.book_format?.toLowerCase() == "magazine")
                          .toList()
                          .length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 2.5,
                        crossAxisSpacing: 10.w,
                      ),
                      itemBuilder: (context, count) {
                        var current = data.library
                            .where((e) =>
                                e.book_format?.toLowerCase() == "magazine")
                            .toList()[count];
                        return GestureDetector(
                          onTap: () {
                            ConstanceData.showBookDetails(context, current);
                          },
                          child: Card(
                            child: CachedNetworkImage(
                              imageUrl: current.profile_pic ?? "",
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                    GridView.builder(
                      itemCount: data.library
                          .where(
                              (e) => e.book_format?.toLowerCase() == "e-note")
                          .toList()
                          .length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 2.5,
                        crossAxisSpacing: 10.w,
                      ),
                      itemBuilder: (context, count) {
                        var current = data.library
                            .where(
                                (e) => e.book_format?.toLowerCase() == "e-note")
                            .toList()[count];
                        return GestureDetector(
                          onTap: () {
                            ConstanceData.showBookDetails(context, current);
                          },
                          child: Card(
                            child: CachedNetworkImage(
                              imageUrl: current.profile_pic ?? "",
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      length: 3,
      vsync: this,
    );

    Future.delayed(Duration.zero, () {
      fetchData();
      _loadLibraryTitle();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _loadLibraryTitle() {
    try {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      final library = dataProvider.libraries.firstWhere(
        (e) => e.id == widget.id,
      );

      setState(() {
        _libraryTitle = library.title;
      });
    } catch (e) {
      debugPrint("Error loading library title: $e");
    }
  }

  void _shareLibrary() async {
    try {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      final library = dataProvider.libraries.firstWhere(
        (e) => e.id == widget.id,
      );

      // Use the same pattern as download_section.dart
      String page = "library";
      final shareUrl =
          'https://tratri.in/link?format=library&id=${library.id}&details=$page&title=${Uri.encodeComponent(library.title ?? "")}';
      await ShareHelper.shareText(shareUrl, context: context);
    } catch (e) {
      debugPrint('Error sharing library: $e');
      // Fallback to sharing just the app link
      _shareWithFallback();
    }
  }

  void _shareWithFallback() async {
    try {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      final library = dataProvider.libraries.firstWhere(
        (e) => e.id == widget.id,
      );

      final shareText = '''
Check out "${library.title}" library in our eBook app!

📚 Thousands of books, magazines, and e-notes available
📱 Download the app: https://play.google.com/store/apps/details?id=com.tsinfosec.ebook.ebook

Library ID: ${library.id}
''';

      await ShareHelper.shareText(shareText, context: context);
    } catch (e) {
      debugPrint('Error in fallback sharing: $e');
      // Last resort - share just the app link
      await ShareHelper.shareText(
          'Check out our eBook app: https://play.google.com/store/apps/details?id=com.tsinfosec.ebook.ebook',
          context: context);
    }
  }

  void fetchData() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getLibraryBookList(widget.id);
    if (response.status ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setLibraryBooks(response.details ?? []);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }
}
