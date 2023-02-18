import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Networking/api_provider.dart';
import '../../Storage/app_storage.dart';
import '../../Storage/data_provider.dart';

class DownloadSection extends StatelessWidget {
  final int id;

  DownloadSection(this.id);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 0.1.w,
          ),
          GestureDetector(
            onTap: () {
              Share.share('https://play.google.com/store/apps/details?id=com.tsinfosec.ebook.ebook');
            },
            child: SizedBox(
              height: 15.h,
              width: 20.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.share),
                  Text(
                    'Share',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                      // fontSize: 2.h,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 0.1.w,
          ),
          GestureDetector(
            onTap: () async {
              if ((Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ??
                      context,
                  listen: false)
                  .profile !=
                  null) &&
                  Storage.instance.isLoggedIn) {
                addBookmark(id, context);
              } else {
                ConstanceData.showAlertDialog(context);
              }
            },
            child: SizedBox(
              height: 15.h,
              width: 20.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_border),
                  Text(
                    'Save',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                      // fontSize: 2.h,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 0.1.w,
          ),
        ],
      ),
    );
  }

  void addBookmark(int id, context) async {
    Navigation.instance.navigate('/loadingDialog');
    final reponse = await ApiProvider.instance.addBookmark(id ?? 0);
    if (reponse.status ?? false) {
      Fluttertoast.showToast(msg: reponse.message!);
      final response = await ApiProvider.instance.fetchBookmark();
      if (response.status ?? false) {
        Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext ?? context,
            listen: false)
            .setToBookmarks(response.items ?? []);
        Navigation.instance.goBack();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Bookmark added successfully",
        );
      } else {
        Navigation.instance.goBack();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          text: "Something went wrong",
        );
      }
    }
  }
}