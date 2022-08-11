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
