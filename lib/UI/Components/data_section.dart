import 'package:ebook/Model/enote_banner.dart';
import 'package:ebook/UI/Routes/Navigation%20Page/book_details.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Model/bookmark.dart';
import '../../Model/home_banner.dart';
import '../../Model/library_book_details.dart';
import 'book_image_info_widget.dart';
import 'book_info_section.dart';
import 'book_info_section_bookmark.dart';
import 'close_button.dart';

class DataSection extends StatelessWidget {
  const DataSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Book data;

  @override
  Widget build(BuildContext context) {
    return Column(
      // alignment: Alignment.topCenter,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: ConstanceData.secondaryColor.withOpacity(0.97),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              GestureDetector(
                onTap: () {
                  Navigation.instance.navigate('/bookInfo', args: data.id);
                },
                child: BookImageInformationWidget(data: data.profile_pic!),
              ),
              const Expanded(
                flex: 2,
                child: CloseButtonCustom(),
              ),
            ],
          ),
        ),
        BookInfoSection(data: data),
      ],
    );
  }
}

class DataSectionBookmark extends StatelessWidget {
  const DataSectionBookmark({
    Key? key,
    required this.data,
  }) : super(key: key);

  final BookmarkItem data;

  @override
  Widget build(BuildContext context) {
    return Column(
      // alignment: Alignment.topCenter,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(),
            ),
            GestureDetector(
              onTap: () {
                Navigation.instance.navigate('/bookInfo', args: data.id);
              },
              child: BookImageInformationWidget(data: data.profile_pic!),
            ),
            const Expanded(
              flex: 2,
              child: CloseButtonCustom(),
            ),
          ],
        ),
        BookInfoSectionBookmark(data: data),
      ],
    );
  }
}

class DataBookDetailsSection extends StatelessWidget {
  const DataBookDetailsSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final LibraryBookDetailsModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      // alignment: Alignment.topCenter,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: ConstanceData.secondaryColor.withOpacity(0.97),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              GestureDetector(
                onTap: () {
                  // Navigation.instance.navigate('/bookInfo', args: data.id);
                  Navigation.instance.navigate('/bookDetails',
                      args: "${data.id ?? 0},${data.profile_pic}");
                },
                child: BookImageInformationWidget(data: data.profile_pic!),
              ),
              const Expanded(
                flex: 2,
                child: CloseButtonCustom(),
              ),
            ],
          ),
        ),
        BookDetailsInfoSection(data: data),
      ],
    );
  }
}

class DataEnoteSection extends StatelessWidget {
  const DataEnoteSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final EnoteBanner data;

  @override
  Widget build(BuildContext context) {
    return Column(
      // alignment: Alignment.topCenter,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: ConstanceData.secondaryColor.withOpacity(0.97),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              GestureDetector(
                onTap: () {
                  Navigation.instance.navigate('/bookInfo', args: data.id);
                },
                child: BookImageInformationWidget(data: data.profilePic!),
              ),
              const Expanded(
                flex: 2,
                child: CloseButtonCustom(),
              ),
            ],
          ),
        ),
        EnoteInfoSection(data: data),
      ],
    );
  }
}
