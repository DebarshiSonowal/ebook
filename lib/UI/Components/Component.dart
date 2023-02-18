import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import '../../Constants/constance_data.dart';
import 'package:sizer/sizer.dart';
class Component{
  static Container CategoryBar() {
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

  static Container Banner(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: ConstanceData.secondaryColor),
      child: CachedNetworkImage(
        imageUrl: ConstanceData.banner[0],
        width: double.infinity,
        fit: BoxFit.fill,
        height: 200,
      ),
    );
  }

  static SizedBox TypeBar(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 4.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var i in ConstanceData.optionList)
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Text(
                i,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
        ],
      ),
    );
  }
}