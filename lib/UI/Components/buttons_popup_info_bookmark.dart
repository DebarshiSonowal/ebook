import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Model/bookmark.dart';
import '../../Storage/app_storage.dart';
import '../../Storage/data_provider.dart';

class ButtonsPopUpInfoBookmark extends StatelessWidget {
  const ButtonsPopUpInfoBookmark({
    Key? key,
    required this.data,
  }) : super(key: key);

  final BookmarkItem data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 4.5.h,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // initiatePaymentProcess(widget.data.id);
                Navigation.instance.navigate('/bookInfo', args: data.id);
                // if (data.book_format == "magazine") {
                //   Navigation.instance
                //       .navigate('/magazineArticles', args: data.id ?? 0);
                // } else {
                //   Navigation.instance.navigate('/bookInfo', args: data.id);
                //   // Navigation.instance.navigate('/reading',
                //   //     args: data.id ?? 0);
                // }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text(
                'View Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 2.h,
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          (data.is_bought ?? false)
              ? Container()
              : SizedBox(
                  width: 1.w,
                ),
          (data.is_bought ?? false)
              ? Container()
              : Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigation.instance
                      //     .navigate('/bookInfo', args: data.id);

                      if ((Provider.of<DataProvider>(
                                      Navigation.instance.navigatorKey
                                              .currentContext ??
                                          context,
                                      listen: false)
                                  .profile !=
                              null) &&
                          Storage.instance.isLoggedIn) {
                        ConstanceData.addtocart(context, data.id);
                        // if (data.book_format!="e-book") {
                        //   //subscription_pop_up
                        //
                        // } else {
                        //
                        // }
                      } else {
                        ConstanceData.showAlertDialog(context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: Text(
                      Platform.isIOS ? 'Add To List' : 'Add To Cart',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 2.h,
                                color: Colors.black,
                              ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
