import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';
import '../../Storage/data_provider.dart';

class CategoryBar extends StatelessWidget {
  const CategoryBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, current, _) {
      debugPrint("CategoryBar logic - currentTab: ${current.currentTab}");
      debugPrint("Total categoryList length: ${current.categoryList.length}");
      if (current.categoryList.isNotEmpty &&
          current.currentTab < current.categoryList.length) {
        debugPrint(
            "Categories for tab ${current.currentTab}: ${current.categoryList[current.currentTab].length} items");
        debugPrint(
            "Category Items ${current.categoryList[current.currentTab].toList().map((e) => e.title)}");
      } else {
        debugPrint("No categories available for tab ${current.currentTab}");
      }
      return current.currentIndex == 0
          ? Container(
              padding: EdgeInsets.only(top: .5.h, left: 2.w, right: 2.w),
              decoration: const BoxDecoration(
                color: const Color(0xff121212),
                border: Border(
                  bottom: BorderSide(
                    // color: selected == count
                    //     ? const Color(0xffffd400)
                    //     : Colors.black,
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
              height: 4.5.h,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          current.categoryList[current.currentTab].length > 3
                              ? 3
                              : current.categoryList[current.currentTab].length,
                      itemBuilder: (cont, count) {
                        var data =
                            current.categoryList[current.currentTab][count];
                        return GestureDetector(
                          onTap: () {
                            // setState(() {
                            //   selected = count;
                            //   debugPrint(count.toString());
                            //   current.setCategory(count);
                            // });
                            Navigation.instance.navigate('/selectCategories',
                                args: '${data.title},${data.id}');
                          },
                          child: Container(
                            // width: 18.w,
                            padding: EdgeInsets.all(0.2.h),
                            margin: const EdgeInsets.symmetric(horizontal: 5),

                            child: Center(
                              child: Text(
                                data.title ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontSize: 15.sp,
                                      // color: selected == count
                                      //     ? const Color(0xffffd400)
                                      //     : Colors.white,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 2.w,
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigation.instance.navigate('/categories', args: "");
                    },
                    child: Container(
                      width: 15.w,
                      height: 3.h,
                      padding: EdgeInsets.all(0.2.h),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Center(
                        child: Text(
                          'More ->',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: 15.sp,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container();
    });
  }
}

class EnotesCategoryBar extends StatelessWidget {
  const EnotesCategoryBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, current, _) {
      return current.currentIndex == 0
          ? Container(
              padding: EdgeInsets.only(top: .5.h, left: 2.w, right: 2.w),
              decoration: const BoxDecoration(
                color: const Color(0xff121212),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
              height: 4.5.h,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          current.enotes.length > 3 ? 3 : current.enotes.length,
                      itemBuilder: (cont, count) {
                        var data = current.enotes[count];
                        return GestureDetector(
                          onTap: () {
                            Navigation.instance.navigate('/selectCategories',
                                args: '${data.title},${data.id}');
                          },
                          child: Container(
                            // width: 18.w,
                            padding: EdgeInsets.all(0.2.h),
                            margin: const EdgeInsets.symmetric(horizontal: 5),

                            child: Center(
                              child: Text(
                                data.title ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontSize: 14.sp,
                                      // color: selected == count
                                      //     ? const Color(0xffffd400)
                                      //     : Colors.white,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 2.w,
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigation.instance
                          .navigate('/categories', args: "enotes");
                    },
                    child: Container(
                      width: 14.w,
                      height: 3.h,
                      padding: EdgeInsets.all(0.2.h),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Center(
                        child: Text(
                          'More ->',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container();
    });
  }
}
