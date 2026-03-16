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
import '../../../Model/library_book_details.dart';
import 'dart:async';

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
  bool _isLoading = false;

  // Search state
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchText = "";
  bool _isSearching = false;
  bool _searchLoading = false;
  List<LibraryBookDetailsModel> _searchResults = [];
  Timer? _debounce;

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
          // IconButton(
          //   onPressed: () {
          //     _shareLibrary();
          //   },
          //   icon: const Icon(Icons.share),
          // ),
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
              _buildSearchBar(),
              if (!_isSearching)
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : _isSearching
                        ? _buildSearchResults()
                        : data.specificLibraryBooks.isEmpty
                            ? const Center(
                                child: Text(
                                  'No books available in this library',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : TabBarView(
                                controller: _controller,
                                children: [
                                  _buildGridView(data.specificLibraryBooks, "e-book"),
                                  _buildGridView(data.specificLibraryBooks, "magazine"),
                                  _buildGridView(data.specificLibraryBooks, "e-note"),
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
      setState(() {
        _isLoading = true;
      });
      // Clear previous specific library books data after first frame
      Provider.of<DataProvider>(context, listen: false)
          .setSpecificLibraryBooks([]);
      fetchData();
      _loadLibraryTitle();
    });

    _searchController.addListener(_onSearchChanged);
    _controller?.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_isSearching && !_controller!.indexIsChanging) {
      _performSearch();
    }
  }

  DataProvider? _dataProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataProvider = Provider.of<DataProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    // Clear specific library books data after the disposal cycle
    Future.microtask(() {
      _dataProvider?.setSpecificLibraryBooks([]);
    });
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text != _searchText) {
        setState(() {
          _searchText = _searchController.text;
          _isSearching = _searchText.isNotEmpty;
        });
        if (_isSearching) {
          _performSearch();
        }
      }
    });
  }

  Future<void> _performSearch() async {
    setState(() => _searchLoading = true);
    try {
      String format = "";
      if (_controller != null) {
        if (_controller!.index == 0) {
          format = "e-book";
        } else if (_controller!.index == 1) {
          format = "magazine";
        } else if (_controller!.index == 2) {
          format = "e-note";
        }
      }

      final response = await ApiProvider.instance.search(
        format, // format
        '', // category_ids
        '', // tag_ids
        '', // author_ids
        _searchText, // title
        '', // awards
        library_ids: widget.id.toString(),
      );

      if (response.success ?? false) {
        setState(() {
          _searchResults = response.books.map((book) {
            return LibraryBookDetailsModel.fromJson(book.toJson());
          }).toList();
        });
      }
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      setState(() => _searchLoading = false);
    }
  }

  Widget _buildSearchResults() {
    if (_searchLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: Colors.white54, size: 40.sp),
            SizedBox(height: 1.h),
            Text(
              'No books found',
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      itemCount: _searchResults.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2.5,
        crossAxisSpacing: 10.w,
      ),
      itemBuilder: (context, count) {
        var current = _searchResults[count];
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
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _searchFocusNode.hasFocus
              ? Colors.white
              : Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style:  TextStyle(color: Colors.white,fontSize:14.sp),
        decoration: InputDecoration(
          hintText: 'Search in this library...',
          hintStyle:  TextStyle(color: Colors.white54,fontSize: 14.sp ),
          prefixIcon: const Icon(Icons.search, color: Colors.white54),
          suffixIcon: _searchText.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white54),
                  onPressed: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 1.5.h),
        ),
        onTap: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildGridView(List<LibraryBookDetailsModel> books, String format) {
    final filteredBooks = books
        .where((e) => e.book_format?.toLowerCase() == format.toLowerCase())
        .toList();

    return GridView.builder(
      itemCount: filteredBooks.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2.5,
        crossAxisSpacing: 10.w,
      ),
      itemBuilder: (context, count) {
        var current = filteredBooks[count];
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
    );
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
    final response = await ApiProvider.instance.getLibraryBookList(widget.id);
    if (response.status ?? false) {
      Provider.of<DataProvider>(context, listen: false)
          .setSpecificLibraryBooks(response.details ?? []);
    } else {
    }
    _isLoading = false;
    setState(() {});
  }
}
