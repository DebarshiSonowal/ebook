import 'package:cached_network_image/cached_network_image.dart';

// import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Constants/constance_data.dart';

class SearchPage extends StatefulWidget {
  String? tags, authors;

  SearchPage({this.tags, this.authors});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class SearchItem extends StatelessWidget {
  const SearchItem({
    Key? key,
    required this.current,
  }) : super(key: key);

  final Book current;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: current.profile_pic ?? "",
                fit: BoxFit.cover,
                height: 18.h,
                width: 22.w,
                placeholder: (context, url) => Container(
                  height: 18.h,
                  width: 22.w,
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.book,
                    color: Colors.grey.shade400,
                    size: 30.sp,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 18.h,
                  width: 22.w,
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey.shade400,
                    size: 30.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 4.w),

            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    current.title ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          height: 1.3,
                        ),
                  ),
                  SizedBox(height: 1.h),

                  // Author
                  Text(
                    current.writer ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 14.sp,
                        ),
                  ),
                  SizedBox(height: 1.5.h),

                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16.sp,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${current.average_rating ?? "0.0"}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade700,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),

                  // Price
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: current.selling_price.toString() == "0.0"
                          ? Colors.green.shade50
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: current.selling_price.toString() == "0.0"
                            ? Colors.green.shade200
                            : Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      current.selling_price.toString() == "0.0"
                          ? "Free"
                          : '₹${current.selling_price}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: current.selling_price.toString() == "0.0"
                                ? Colors.green.shade700
                                : Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                    ),
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

class _SearchPageState extends State<SearchPage> {
  final search = TextEditingController();
  var _value = 'e-book';
  bool isSearching = false;
  Map<String, String>? categories, authors, awards;
  Map<int, bool> selectedCategories = {},
      selectedAuthors = {},
      selectedAwards = {};

  @override
  void dispose() {
    Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext ?? context,
            listen: false)
        .setSearchResult([]);
    super.dispose();
    search.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(
        "SearchPage initState - tags: ${widget.tags}, authors: ${widget.authors}");

    Future.delayed(Duration.zero, () => fetchFilter());
    Future.delayed(Duration.zero, () {
      setState(() {
        _value = Provider.of<DataProvider>(context, listen: false).currentTab ==
                0
            ? "e-book"
            : Provider.of<DataProvider>(context, listen: false).currentTab == 1
                ? "magazine"
                : "e-note";
      });

      print("Current format set to: $_value");

      if (widget.tags != null && widget.tags!.isNotEmpty) {
        print("Searching with tags: ${widget.tags}");
        search_it("", "", widget.tags, "", "");
      } else if (widget.authors != null && widget.authors!.isNotEmpty) {
        print("Searching with authors: ${widget.authors}");
        // Pre-select the author in the filter and perform search
        Future.delayed(Duration(milliseconds: 1000), () {
          print("Available authors: ${authors?.keys.toList()}");
          if (authors != null && authors!.containsKey(widget.authors)) {
            print("Pre-selecting author: ${widget.authors}");
            setState(() {
              selectedAuthors[int.parse(widget.authors!)] = true;
            });
            search_it("", "", "", widget.authors, "");
          } else {
            print("Author ${widget.authors} not found in available authors");
            // Try direct search anyway
            search_it("", "", "", widget.authors, "");
          }
        });
      } else {
        print(
            "No initial search parameters provided - default search will be triggered after filters load");
      }
    });
  }

  void performDefaultSearch() {
    print("Performing default search to load initial results");
    // Call search with empty parameters to get default results
    search_it("", "", "", "", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Search",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    controller: search,
                    onChanged: (txt) {
                      if (txt.isEmpty) {
                        setSearchEmpty();
                      }
                    },
                    onSubmitted: (txt) {
                      if (txt.isEmpty) {
                        setSearchEmpty();
                      } else {
                        search_it(search.text, '', '', '', '');
                      }
                    },
                    cursorColor: Theme.of(context).primaryColor,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      border: InputBorder.none,
                      hintText: 'Search for books, authors, magazines...',
                      hintStyle:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey.shade500,
                                fontSize: 15.sp,
                              ),
                      suffixIcon: Container(
                        margin: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (search.text.isEmpty) {
                              setSearchEmpty();
                            } else {
                              search_it(search.text, '', '', '', '');
                            }
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // Filter Chips
                Container(
                  height: 6.h,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          'Formats',
                          false,
                          Colors.purple,
                          () => showFilterFormats(),
                        ),
                        SizedBox(width: 2.w),
                        _buildFilterChip(
                          selectedCategories.values.any((selected) => selected)
                              ? 'Categories (${selectedCategories.values.where((selected) => selected).length})'
                              : 'Categories',
                          selectedCategories.values.any((selected) => selected),
                          Colors.green,
                          () => showCategoriesFormats(),
                        ),
                        SizedBox(width: 2.w),
                        _buildFilterChip(
                          selectedAuthors.values.any((selected) => selected)
                              ? 'Authors (${selectedAuthors.values.where((selected) => selected).length})'
                              : 'Authors',
                          selectedAuthors.values.any((selected) => selected),
                          Colors.blue,
                          () => showAuthors(),
                        ),
                        SizedBox(width: 2.w),
                        _buildFilterChip(
                          selectedAwards.values.any((selected) => selected)
                              ? 'Awards (${selectedAwards.values.where((selected) => selected).length})'
                              : 'Awards',
                          selectedAwards.values.any((selected) => selected),
                          Colors.orange,
                          () => showAwards(),
                        ),
                        SizedBox(width: 2.w),
                        // Debug test button
                        if (true) // Set to false in production
                          GestureDetector(
                            onTap: () {
                              print("Test search triggered");
                              search_it("", "", "", "", "");
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.red, width: 1),
                              ),
                              child: Text(
                                'Test Search',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Results
                isSearching
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : data.searchResults.isEmpty
                        ? Container(
                            height: 40.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 50.sp,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'No Results Found',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Try adjusting your search or filters',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14.sp,
                                      ),
                                ),
                                // Debug info
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              // Results header with count
                              Padding(
                                padding: EdgeInsets.only(bottom: 1.h),
                                child: Row(
                                  children: [
                                    Text(
                                      '${data.searchResults.length} results found',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Results list
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var current = data.searchResults[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigation.instance.navigate('/bookInfo',
                                          args: current.id);
                                    },
                                    child: SearchItem(current: current),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 1.h),
                                itemCount: data.searchResults.length,
                              ),
                            ],
                          ),
                SizedBox(height: 2.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFilterChip(
      String label, bool isActive, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isActive ? color : Colors.grey.shade300,
            width: isActive ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isActive ? color : Colors.black87,
                    fontSize: 13.sp,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
            SizedBox(width: 1.w),
            Icon(
              Icons.arrow_drop_down,
              color: isActive ? color : Colors.grey.shade600,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  void search_it(title, category_ids, tag_ids, author_ids, awards) async {
    print(
        "Search called with: title=$title, categories=$category_ids, tags=$tag_ids, authors=$author_ids, awards=$awards, format=$_value");

    try {
      setState(() => isSearching = true);
      Navigation.instance.navigate('/loadingDialog');
      final result = await ApiProvider.instance
          .search(_value, category_ids, tag_ids, author_ids, title, awards);

      if (result.success ?? false) {
        final books = result.books ?? [];
        print("Setting ${books.length} books to search results");

        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setSearchResult(books);
        Navigation.instance.goBack();
        setState(() => isSearching = false);
      } else {
        print("Search failed: ${result.message ?? 'Unknown error'}");
        setSearchEmpty();
        Navigation.instance.goBack();
        setState(() => isSearching = false);
      }
    } catch (e) {
      print("Error during search: $e");
      setSearchEmpty();
      Navigation.instance.goBack();
      setState(() => isSearching = false);
    }
  }

  void setSearchEmpty() {
    print("Setting search results to empty");
    Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext ?? context,
            listen: false)
        .setSearchResult([]);
  }

  void fetchFilter() async {
    print("Fetching filters for format: $_value");
    try {
      Navigation.instance.navigate('/loadingDialog');
      final response = await ApiProvider.instance.getFilters(_value);

      if (response.success ?? false) {
        print(
            "Filter data received - Categories: ${response.categories?.length}, Authors: ${response.authors?.length}, Awards: ${response.awards?.length}");
        setState(() {
          categories = response.categories;
          authors = response.authors;
          awards = response.awards;
        });
        Navigation.instance.goBack();

        // After filters are loaded, trigger default search if no specific search was requested
        if ((widget.tags == null || widget.tags!.isEmpty) &&
            (widget.authors == null || widget.authors!.isEmpty)) {
          print("Filters loaded - triggering default search");
          Future.delayed(Duration(milliseconds: 200), () {
            performDefaultSearch();
          });
        }
      } else {
        print("Failed to fetch filters");
        Navigation.instance.goBack();
      }
    } catch (e) {
      print("Error fetching filters: $e");
      Navigation.instance.goBack();
    }
  }

  String getComaSeparated(List<dynamic> list, List<dynamic> list2) {
    String temp = "";
    for (int i = 0; i < list.length; i++) {
      if (list2[i] == true) {
        if (temp.isEmpty) {
          temp = '${list[i]}';
        } else {
          temp += ',${list[i]}';
        }
      }
    }
    return temp;
  }

  void showFilterFormats() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, _) {
            return Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
              ),
              child: Container(
                padding: EdgeInsets.only(
                    top: 3.h, right: 10.w, left: 10.w, bottom: 3.h),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0))),
                child: Wrap(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Select a formats',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: ConstanceData.primaryColor,
                            fontSize: 2.h,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        Radio(
                          groupValue: _value,
                          value: 'e-book',
                          fillColor: MaterialStateProperty.all(
                            ConstanceData.primaryColor,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _value = value ?? "";
                            });
                            Navigation.instance.goBack();
                          },
                          activeColor: ConstanceData.primaryColor,
                        ),
                        Text(
                          'E-book',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: ConstanceData.primaryColor,
                                    fontSize: 1.8.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          focusColor: ConstanceData.primaryColor,
                          // overlayColor: MaterialStateProperty,
                          groupValue: _value,
                          value: 'magazine',
                          fillColor: MaterialStateProperty.all(
                            ConstanceData.primaryColor,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _value = value ?? "";
                            });
                            Navigation.instance.goBack();
                          },
                          activeColor: ConstanceData.primaryColor,
                        ),
                        Text(
                          'Magazine',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: ConstanceData.primaryColor,
                                    fontSize: 1.8.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          focusColor: ConstanceData.primaryColor,
                          // overlayColor: MaterialStateProperty,
                          groupValue: _value,
                          value: 'e-note',
                          fillColor: MaterialStateProperty.all(
                            ConstanceData.primaryColor,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _value = value ?? "";
                            });
                            Navigation.instance.goBack();
                          },
                          activeColor: ConstanceData.primaryColor,
                        ),
                        Text(
                          'E-note',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: ConstanceData.primaryColor,
                                    fontSize: 1.8.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void showCategoriesFormats() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, _) {
            return Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0))),
                child: Wrap(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Select Categories',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: ConstanceData.primaryColor,
                            fontSize: 2.h,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: categories?.keys.length,
                          itemBuilder: (conte, cout) {
                            var current = categories?.keys.toList()[cout] ?? "";
                            return Theme(
                              data:
                                  ThemeData(unselectedWidgetColor: Colors.grey),
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                checkColor: Colors.black,
                                activeColor: Colors.grey.shade300,
                                // tileColor: Colors.grey,
                                value: selectedCategories[int.parse(current)] ??
                                    false,
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    selectedCategories[int.parse(current)] =
                                        value!;
                                  });
                                },
                                title: Text(
                                  categories![current] ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          color: Colors.black,
                                          fontSize: 14.5.sp),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            selectedCategories.clear();
                            Navigation.instance.goBack();
                          },
                          child: Text(
                            'Close',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.5.sp,
                                ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            fetchSearchResults();
                          },
                          child: Text(
                            'Apply Filters',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.5.sp,
                                ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void showAuthors() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, _) {
            return Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0))),
                child: Wrap(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Select Authors',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: ConstanceData.primaryColor,
                            fontSize: 2.h,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: authors?.keys.length,
                          itemBuilder: (conte, cout) {
                            var current = authors?.keys.toList()[cout] ?? "";
                            return Theme(
                              data:
                                  ThemeData(unselectedWidgetColor: Colors.grey),
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                checkColor: Colors.black,
                                activeColor: Colors.grey.shade300,
                                // tileColor: Colors.grey,
                                value: selectedAuthors[int.parse(current)] ??
                                    false,
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    selectedAuthors[int.parse(current)] =
                                        value!;
                                  });
                                },
                                title: Text(
                                  authors![current] ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 14.5.sp,
                                      ),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            selectedAuthors.clear();
                            Navigation.instance.goBack();
                          },
                          child: Text(
                            'Close',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.5.sp,
                                ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            fetchSearchResults();
                          },
                          child: Text(
                            'Apply Filters',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.5.sp,
                                ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void showAwards() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, _) {
            return Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0))),
                child: Wrap(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Select Awards',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: ConstanceData.primaryColor,
                            fontSize: 2.h,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: awards?.keys.length,
                          itemBuilder: (conte, cout) {
                            var current = awards?.keys.toList()[cout] ?? "";
                            return Theme(
                              data:
                                  ThemeData(unselectedWidgetColor: Colors.grey),
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                checkColor: Colors.black,
                                activeColor: Colors.grey.shade300,
                                // tileColor: Colors.grey,
                                value:
                                    selectedAwards[int.parse(current)] ?? false,
                                onChanged: (value) {
                                  debugPrint("${value}");
                                  setState(() {
                                    selectedAwards[int.parse(current)] = value!;
                                  });
                                },
                                title: Text(
                                  awards![current] ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          color: Colors.black,
                                          fontSize: 14.5.sp),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            selectedAwards.clear();
                            Navigation.instance.goBack();
                          },
                          child: Text(
                            'Close',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.5.sp,
                                ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              fetchSearchResults();
                            });
                          },
                          child: Text(
                            'Apply Filters',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.black,
                                  fontSize: 14.5.sp,
                                ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void fetchSearchResults() {
    Navigation.instance.goBack();
    search_it(
      search.text,
      getComaSeparated(
        selectedCategories.keys.toList(),
        selectedCategories.values.toList(),
      ),
      '',
      getComaSeparated(
        selectedAuthors.keys.toList(),
        selectedAuthors.values.toList(),
      ),
      getComaSeparated(
        selectedAwards.keys.toList(),
        selectedAwards.values.toList(),
      ),
    );
  }
}
