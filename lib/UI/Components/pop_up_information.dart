import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/UI/Components/tags_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Model/home_banner.dart';
import '../../Storage/data_provider.dart';
import 'book_image_info_widget.dart';
import 'book_info_section.dart';
import 'buttons_pop_up_info.dart';

class PopUpInformation extends StatelessWidget {
  const PopUpInformation({Key? key, required this.data}) : super(key: key);
  final Book data;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 0.1.h),
        color: ConstanceData.secondaryColor.withOpacity(0.97),
        // height: 80.h,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            BookInfoSection(data: data),
            GestureDetector(
              onTap: () {
                Navigation.instance.navigate('/bookInfo', args: data.id);
              },
              child: BookImageInformationWidget(data: data),
            ),
          ],
        ),
      ),
    );
  }
}


