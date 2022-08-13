import 'package:flutter/material.dart';
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
      height: 7.h,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: TabBar(
                controller: _controller,
                indicatorColor: Colors.black,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                tabs: List.generate(
                  Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext!,
                              listen: true)
                          .formats
                          ?.length ??
                      2,
                  (count) => Tab(
                    icon: Text(
                      Provider.of<DataProvider>(
                                  Navigation
                                      .instance.navigatorKey.currentContext!,
                                  listen: true)
                              .formats![count]
                              .name ??
                          "",
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
