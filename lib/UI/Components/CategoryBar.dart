import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';
import '../../Storage/data_provider.dart';

class CategoryBar extends StatelessWidget {
  const CategoryBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, current, _) {
      return current.currentIndex == 0
          ? Container(
        padding: EdgeInsets.only(top: .5.h),
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
                current.categoryList[current.currentTab].length ~/
                    2,
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
                              .headline5
                              ?.copyWith(
                            // fontSize: 1.5.h,
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
                    width: 10.w,
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigation.instance.navigate('/categories');
              },
              child: Container(
                width: 13.w,
                height: 3.h,
                padding: EdgeInsets.all(0.2.h),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Center(
                  child: Text(
                    'More ->',
                    overflow: TextOverflow.ellipsis,
                    style:
                    Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 1.5.h,
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
