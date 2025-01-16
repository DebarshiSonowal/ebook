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

class _SearchPageState extends State<SearchPage> {
  final search = TextEditingController();
  var _value = 'e-book';
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
    Future.delayed(Duration.zero, () => fetchFilter());
    Future.delayed(Duration.zero, () {
      setState(() {
        _value =
            Provider.of<DataProvider>(context, listen: false).currentTab == 0
                ? "e-book"
                : "magazine";
      });
      if (widget.tags != null && widget.tags != "") {
        search_it("", "", widget.tags, "", "");
      } else if (widget.authors != null && widget.authors != "") {
        search_it("", "", "", widget.authors, "");
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Search",
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
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      //                   <--- border color
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        5.0,
                      ), //                 <--- border radius here
                    ),
                  ),
                  // height: 4.h,
                  width: double.infinity,
                  child: Center(
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      controller: search,
                      onChanged: (txt) {
                        if (txt == "") {
                          setSearchEmpty();
                        } else {
                          // search_it(
                          //   txt,
                          //   '',
                          //   '',
                          //   '',
                          // );
                        }
                      },
                      onSubmitted: (txt) {
                        if (txt == "") {
                          setSearchEmpty();
                        } else {
                          search_it(
                            txt,
                            '',
                            '',
                            '',
                            '',
                          );
                        }
                      },
                      cursorColor: Colors.grey,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.black,
                                fontSize: 17.sp,
                              ),
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Search',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.black54,
                              fontSize: 15.sp,
                            ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (search.text.isEmpty) {
                              setSearchEmpty();
                            } else {
                              search_it(
                                search.text,
                                '',
                                '',
                                '',
                                '',
                              );
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
                SizedBox(
                  height: 1.h,
                ),
                // ListView.builder(itemBuilder: itemBuilder)
                SizedBox(
                  height: 7.h,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showFilterFormats();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w, vertical: 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Formats',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 13.5.sp,
                                      ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            showCategoriesFormats();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w, vertical: 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Categories',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 13.5.sp,
                                      ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            showAuthors();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w, vertical: 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Authors',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 13.5.sp,
                                      ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            showAwards();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w, vertical: 1.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Awards',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 13.5.sp,
                                      ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                data.search_results.isEmpty
                    ? Text(
                        'No Results Found',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                ),
                      )
                    : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (cont, count) {
                          var current = data.search_results[count];
                          return GestureDetector(
                            onTap: () {
                              Navigation.instance
                                  .navigate('/bookInfo', args: current.id);
                            },
                            child: SearchItem(current: current),
                          );
                        },
                        separatorBuilder: (cont, count) {
                          return SizedBox(
                            height: 0.5.h,
                          );
                        },
                        itemCount: data.search_results.length,
                      )
              ],
            ),
          );
        }),
      ),
    );
  }

  void search_it(title, category_ids, tag_ids, author_ids, awards) async {
    Navigation.instance.navigate('/loadingDialog');
    final result = await ApiProvider.instance
        .search(_value, category_ids, tag_ids, author_ids, title, awards);
    if (result.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setSearchResult(result.books);
      Navigation.instance.goBack();
    } else {
      setSearchEmpty();
      Navigation.instance.goBack();
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.warning,
      //   text: "Something went wrong",
      // );
    }
  }

  void setSearchEmpty() {
    Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext ?? context,
            listen: false)
        .setSearchResult([]);
  }

  void fetchFilter() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getFilters(_value);
    if (response.success ?? false) {
      setState(() {
        categories = response.categories;
        authors = response.authors;
        awards = response.awards;
      });
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
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
                            _(() {
                              setState(() {
                                _value = value ?? "";
                                // order_by = _value;
                              });
                              Navigation.instance.goBack();
                            });
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
                            _(() {
                              setState(() {
                                _value = value ?? "";
                              });
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
                  ],
                ),
              ),
            );
          });
        });
  }

  String getComaSeparated(List<dynamic> list, List<dynamic> list2) {
    String temp = "";
    for (int i = 0; i < list.length; i++) {
      if (list2[i] == true) {
        if (i == 0) {
          temp = '${list[i]},';
        } else {
          temp += '${list[i]},';
        }
      }
    }
    return temp.endsWith(",") ? temp.substring(0, temp.length - 1) : temp;
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
                      'Select categories',
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
                                onChanged: (value) => _(() {
                                  print(value);
                                  setState(() {
                                    selectedCategories[int.parse(current)] =
                                        value!;
                                  });
                                }),
                                title: Text(
                                  categories![current] ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.black),
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
                                onChanged: (value) => _(() {
                                  print(value);
                                  setState(() {
                                    selectedAuthors[int.parse(current)] =
                                        value!;
                                  });
                                }),
                                title: Text(
                                  authors![current] ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.black),
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
                                onChanged: (value) => _(() {
                                  print(value);
                                  setState(() {
                                    selectedAwards[int.parse(current)] = value!;
                                  });
                                }),
                                title: Text(
                                  awards![current] ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.black),
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

class SearchItem extends StatelessWidget {
  const SearchItem({
    Key? key,
    required this.current,
  }) : super(key: key);

  final Book current;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.5.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      ),
      child: ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: current.profile_pic ?? "",
              fit: BoxFit.fill,
              height: 15.h,
              width: 20.w,
            ),
            SizedBox(
              width: 5.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 57.w,
                  child: Text(
                    current.title ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Text(
                  current.writer ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.black, fontSize: 16.sp
                          // fontWeight: FontWeight.bold,
                          ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${current.average_rating}' ?? "NA",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.black,
                                fontSize: 15.sp,
                              ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 19.sp,
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Text(
                  current.selling_price.toString() == "0.0"
                      ? "Free"
                      : '₹${current.selling_price}' ?? "NA",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
