import 'package:flutter/material.dart';

import '../../Constants/constance_data.dart';
import 'package:sizer/sizer.dart';

class NewTabBar extends StatelessWidget {
  const NewTabBar({
    Key? key,
    required TabController? controller,
  })  : _controller = controller,
        super(key: key);

  final TabController? _controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 7.h,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 7.h,
            child: Center(
              child: Image.asset(
                ConstanceData.primaryIcon,
                height: 6.h,
                width: 6.h,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: TabBar(
              controller: _controller,
              indicatorColor: Colors.black,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(icon: Text(ConstanceData.optionList[0]),),
                Tab(icon: Text(ConstanceData.optionList[1])),
                // Tab(icon: Icon(Icons.directions_car)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
