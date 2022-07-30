import 'package:flutter/material.dart';

import '../../Constants/constance_data.dart';
import 'package:sizer/sizer.dart';
class CategoryBar extends StatefulWidget {
  const CategoryBar({Key? key}) : super(key: key);

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstanceData.secondaryColor,
      width: double.infinity,
      height: 12.h,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 4.w,
          );
        },
        itemCount: ConstanceData.iconList.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          var i = ConstanceData.iconList[index];
          return Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff191919),
                  ),
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(bottom: 4),
                  child: IconButton(
                      onPressed: () {}, icon: Icon(i.icon ?? Icons.add)),
                ),
                Text(
                  i.name ?? "",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
