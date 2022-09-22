import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final search = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey.shade200,
        title: Text(
          "Search",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline1?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black26,
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
                          );
                        }
                      },
                      cursorColor: Colors.grey,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                          ),
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Search',
                        hintStyle:
                            Theme.of(context).textTheme.headline4?.copyWith(
                                  color: Colors.black26,
                                ),
                        suffixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                data.search_results.isEmpty
                    ? Text(
                        'No Results Found',
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                              color: Colors.black,
                            ),
                      )
                    : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (cont, count) {
                          var current = data.search_results[count];
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 60.w,
                                        child: Text(
                                          current.title ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              ?.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
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
                                            .headline4
                                            ?.copyWith(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.5.h,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${current.average_rating}' ?? "NA",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                ?.copyWith(
                                                  color: Colors.black,
                                                ),
                                          ),
                                          const Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1.5.h,
                                      ),
                                      Text(
                                        '₹${current.base_price}' ?? "NA",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            ?.copyWith(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (cont, count) {
                          return SizedBox(
                            height: 2.h,
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

  void search_it(title, category_ids, tag_ids, author_ids) async {
    final result = await ApiProvider.instance.search(
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .formats![Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .currentTab]
            .productFormat,
        category_ids,
        tag_ids,
        author_ids,
        title);
    if (result.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setSearchResult(result.books);
    }
  }

  void setSearchEmpty() {
    Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext ?? context,
            listen: false)
        .setSearchResult([]);
  }
}
