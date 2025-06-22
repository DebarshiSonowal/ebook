import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

import '../../../Constants/constance_data.dart';
import '../../../Helper/navigator.dart';
import '../../../Model/library_search_response.dart';
import '../../../Networking/api_provider.dart';
import '../../../Storage/data_provider.dart';

class LibrarySearchScreen extends StatefulWidget {
  const LibrarySearchScreen({Key? key}) : super(key: key);

  @override
  State<LibrarySearchScreen> createState() => _LibrarySearchScreenState();
}

class _LibrarySearchScreenState extends State<LibrarySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LibrarySearchItem> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // Load all libraries initially with empty search text
    _performInitialLoad();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performInitialLoad() async {
    setState(() {
      _isLoading = true;
      _hasSearched = true; // Set to true to show results
      _searchResults.clear();
      _currentPage = 1;
    });

    try {
      final response = await ApiProvider.instance.searchLibraries(1, "");
      debugPrint("Initial load response success: ${response.success}");
      debugPrint("Initial load response message: ${response.message}");

      if (response.success) {
        debugPrint(
            "Initial load results count: ${response.result.bookList.length}");
        setState(() {
          _searchResults = response.result.bookList;
          _currentPage = response.result.currentPage;
          _totalPages = response.result.lastPage;
          _isLoading = false;
        });
      } else {
        debugPrint("Initial load failed: ${response.message}");
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
        _showErrorMessage(response.message);
      }
    } catch (e, stackTrace) {
      debugPrint("Initial load error: $e");
      debugPrint("Stack trace: $stackTrace");
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      _showErrorMessage('Failed to load libraries. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Library Search",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
              ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black12,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              width: double.infinity,
              child: Center(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  controller: _searchController,
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      _performSearch(text.trim());
                    }
                  },
                  onChanged: (text) {
                    // If user clears the search, reload all libraries
                    if (text.trim().isEmpty) {
                      _performInitialLoad();
                    }
                  },
                  cursorColor: Colors.grey,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 17.sp,
                      ),
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Search libraries...',
                    hintStyle:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.black54,
                              fontSize: 15.sp,
                            ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (_searchController.text.trim().isNotEmpty) {
                          _performSearch(_searchController.text.trim());
                        }
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Results
            Expanded(
              child: _buildResultsWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsWidget() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Text(
          'Loading libraries...',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
              ),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.trim().isEmpty
              ? 'No libraries found'
              : 'No libraries found for "${_searchController.text.trim()}"',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              if (index == _searchResults.length) {
                return _buildLoadMoreWidget();
              }
              return _buildLibraryItem(_searchResults[index]);
            },
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemCount: _searchResults.length + (_canLoadMore() ? 1 : 0),
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryItem(LibrarySearchItem library) {
    return GestureDetector(
      onTap: () {
        _navigateToLibraryDetails(library);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture with enhanced styling
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: library.profilePic,
                    fit: BoxFit.cover,
                    height: 16.h,
                    width: 24.w,
                    placeholder: (context, url) => Container(
                      height: 16.h,
                      width: 24.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey.shade50, Colors.grey.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        Icons.library_books,
                        color: Colors.grey.shade400,
                        size: 8.w,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 16.h,
                      width: 24.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey.shade50, Colors.grey.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        Icons.library_books,
                        color: Colors.grey.shade400,
                        size: 8.w,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // Library Details with improved layout
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with better typography
                    Text(
                      library.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            height: 1.3,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.5.h),

                    // Owner Name with icon
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            library.ownerName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey.shade700,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),

                    // Library Type with enhanced styling
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.blue.shade200,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        library.libraryType,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.blue.shade700,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    SizedBox(height: 1.5.h),

                    // Books count with enhanced styling
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Icon(
                            Icons.menu_book,
                            size: 14.sp,
                            color: Colors.green.shade700,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${library.noOfBooks} books available',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.green.shade700,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildLoadMoreWidget() {
    if (_isLoadingMore) {
      return Container(
        padding: EdgeInsets.all(2.h),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: _loadMore,
      child: Container(
        padding: EdgeInsets.all(2.h),
        child: Center(
          child: Text(
            'Load More',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  void _performSearch(String searchText) async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _searchResults.clear();
      _currentPage = 1;
    });

    try {
      final response =
          await ApiProvider.instance.searchLibraries(1, searchText);
      debugPrint("Search response success: ${response.success}");
      debugPrint("Search response message: ${response.message}");

      if (response.success) {
        debugPrint("Search results count: ${response.result.bookList.length}");
        setState(() {
          _searchResults = response.result.bookList;
          _currentPage = response.result.currentPage;
          _totalPages = response.result.lastPage;
          _isLoading = false;
        });
      } else {
        debugPrint("Search failed: ${response.message}");
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
        _showErrorMessage(response.message);
      }
    } catch (e, stackTrace) {
      debugPrint("Search error: $e");
      debugPrint("Stack trace: $stackTrace");
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      _showErrorMessage('Search failed. Please try again.');
    }
  }

  void _loadMore() async {
    if (_isLoadingMore || _currentPage >= _totalPages) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = await ApiProvider.instance.searchLibraries(
        _currentPage + 1,
        _searchController.text.trim(),
      );
      debugPrint("Load more response success: ${response.success}");

      if (response.success) {
        debugPrint(
            "Load more results count: ${response.result.bookList.length}");
        setState(() {
          _searchResults.addAll(response.result.bookList);
          _currentPage = response.result.currentPage;
          _totalPages = response.result.lastPage;
          _isLoadingMore = false;
        });
      } else {
        debugPrint("Load more failed: ${response.message}");
        setState(() {
          _isLoadingMore = false;
        });
        _showErrorMessage(response.message);
      }
    } catch (e, stackTrace) {
      debugPrint("Load more error: $e");
      debugPrint("Stack trace: $stackTrace");
      setState(() {
        _isLoadingMore = false;
      });
      _showErrorMessage('Failed to load more results.');
    }
  }

  bool _canLoadMore() {
    return _currentPage < _totalPages && !_isLoadingMore;
  }

  void _navigateToLibraryDetails(LibrarySearchItem library) {
    // Navigate to library details page
    // Navigation.instance.navigate('/specificLibrary', args: library.id);
    Navigation.instance.navigate('/libraryBooks', args: library.id);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
