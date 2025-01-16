import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Consumer<DataProvider>(builder: (context, current, _) {
          return Container(
            color: Colors.black54,
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Center(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          current.categoryList[current.currentTab].length,
                      itemBuilder: (cont, ind) {
                        var data =
                            current.categoryList[current.currentTab][ind];
                        return GestureDetector(
                          onTap: () {
                            Navigation.instance.navigateAndReplace(
                                '/selectCategories',
                                args: '${data.title},${data.id}');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                            ),
                            // height: 10.h,
                            child: Center(
                              child: Text(
                                (data.title ?? "")
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    (data.title ?? "").substring(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                    ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                GestureDetector(
                  onTap: () {
                    Navigation.instance.goBack();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: Icon(
                      Icons.clear,
                      color: Colors.black,
                      size: 5.h,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
