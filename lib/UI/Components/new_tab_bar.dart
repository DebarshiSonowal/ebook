import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';

import '../../Constants/constance_data.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/navigator.dart';
import '../../Storage/data_provider.dart';

class NewTabBar extends StatelessWidget {
  const NewTabBar({
    Key? key,
    required TabController? controller,
  })  : _controller = controller,
        super(key: key);

  final TabController? _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff121212),
      // height: 7.h,
      width: double.infinity,
      child: Consumer<DataProvider>(builder: (context, data, _) {
        return Row(
          children: [
            Expanded(
              child: TabBar(
                  controller: _controller,
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade600,
                  tabs: List.generate(
                    data.formats?.length ?? 2,
                    (count) => Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 3.w),
                        decoration: BoxDecoration(
                          border: (count) == data.currentTab
                              ? const Border(
                                  bottom: BorderSide(
                                    //                   <--- right side
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                )
                              : Border.all(color: Colors.transparent),
                        ),
                        child: Text(
                          data.formats![count].name ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontSize: 15.sp,
                                color: (count) == data.currentTab
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        );
      }),
    );
  }
}
