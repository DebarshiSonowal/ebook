import 'package:ebook/Model/bookmark.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Model/home_banner.dart';
import 'data_section.dart';

class PopUpInformation extends StatelessWidget {
  const PopUpInformation({Key? key, required this.data}) : super(key: key);
  final Book data;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 0.1.h),
        color: Colors.black,
        height: 55.9.h,
        child:DataSection(data: data),
      ),
    );
  }
}
class PopUpInformationBookmark extends StatelessWidget {
  const PopUpInformationBookmark({Key? key, required this.data}) : super(key: key);
  final BookmarkItem data;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 0.1.h),
        color: ConstanceData.secondaryColor.withOpacity(0.97),
        height: (data.tags?.isEmpty ?? true) ? 63.2.h : 65.h,
        child:DataSectionBookmark(data: data),
      ),
    );
  }
}


