import 'dart:io';

import 'package:ebook/Model/bookmark.dart';
import 'package:ebook/Model/enote_banner.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/UI/Components/scrollable_content.dart';
import 'package:ebook/UI/Components/tags_section.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Model/home_banner.dart';
import '../../Model/library_book_details.dart';
import 'buttons_pop_up_info.dart';
import 'close_button.dart';

class BookInfoSection extends StatelessWidget {
  const BookInfoSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Book data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 34.h,
      width: double.infinity,
      child: Container(
        // height: 200,
        // width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        color: ConstanceData.secondaryColor.withOpacity(0.97),
        child: Column(
          children: [
            ScrollableContent(data: data),
            Column(
              children: [
                if (data.book_format == "magazine")
                  Container()
                else
                  SizedBox(
                    width: double.infinity,
                    height: 4.5.h,
                    child: ElevatedButton(
                        onPressed: () {
                          if ((Platform.isAndroid) ||
                              (Platform.isIOS && Storage.instance.isLoggedIn)) {
                            Navigation.instance.navigate('/bookDetails',
                                args: "${data.id ?? 0},${data.profile_pic}");
                          } else {
                            ConstanceData.showAlertDialog(context);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Text(
                          data.book_format == "magazine"
                              ? 'View Articles'
                              : (data.is_bought ?? false)
                                  ? 'Read'
                                  : 'Preview',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                        )),
                  ),
                SizedBox(height: 0.5.h),
                ButtonsPopUpInfo(
                    data: data,
                    is_ebook: data.book_format == "magazine" ? false : true),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BookDetailsInfoSection extends StatelessWidget {
  const BookDetailsInfoSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final LibraryBookDetailsModel data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 34.h,
      width: double.infinity,
      child: Container(
        // height: 200,
        // width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        color: ConstanceData.secondaryColor.withOpacity(0.97),
        child: Column(
          children: [
            ScrollableDataContent(data: data),
            Column(
              children: [
                if (data.book_format == "magazine")
                  Container()
                else
                  SizedBox(
                    width: double.infinity,
                    height: 4.5.h,
                    child: ElevatedButton(
                        onPressed: () {
                          if ((Platform.isAndroid) ||
                              (Platform.isIOS && Storage.instance.isLoggedIn)) {
                            Navigation.instance.navigate('/bookDetails',
                                args: "${data.id ?? 0},${data.profile_pic}");
                          } else {
                            ConstanceData.showAlertDialog(context);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Text(
                          'Read',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: 2.h,
                                color: Colors.black,
                              ),
                        )),
                  ),
                SizedBox(height: 0.5.h),
                ButtonsDataPopUpInfo(
                    data: data,
                    is_ebook: data.book_format == "magazine" ? false : true),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EnoteInfoSection extends StatelessWidget {
  const EnoteInfoSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  final EnoteBanner data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 34.h,
      width: double.infinity,
      child: Container(
        // height: 200,
        // width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        color: ConstanceData.secondaryColor.withOpacity(0.97),
        child: Column(
          children: [
            ScrollableEnoteContent(data: data),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 4.5.h,
                  child: ElevatedButton(
                      onPressed: () {
                        if ((Platform.isAndroid) ||
                            (Platform.isIOS && Storage.instance.isLoggedIn)) {
                          Navigation.instance.navigate('/bookDetails',
                              args: "${data.id ?? 0},${data.profilePic}");
                        } else {
                          ConstanceData.showAlertDialog(context);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: Text(
                        (data.isBought ?? false) ? 'Read' : 'Preview',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 2.h,
                                  color: Colors.black,
                                ),
                      )),
                ),
                SizedBox(height: 0.5.h),
                ButtonsEnotePopUpInfo(
                    data: data,
                    is_ebook: data.bookFormat == "magazine" ? false : true),
              ],
            )
          ],
        ),
      ),
    );
  }
}
