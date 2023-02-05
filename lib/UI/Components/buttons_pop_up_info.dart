import 'package:ebook/Storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Model/bookmark.dart';
import '../../Model/home_banner.dart';
import '../../Storage/data_provider.dart';

class ButtonsPopUpInfo extends StatelessWidget {
  const ButtonsPopUpInfo({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Book data;

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
                if (data.book_format == "magazine") {
                  Navigation.instance
                      .navigate('/magazineArticles', args: data.id ?? 0);
                } else {
                  Navigation.instance.navigate('/bookInfo', args: data.id);
                  // Navigation.instance.navigate('/reading',
                  //     args: data.id ?? 0);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text(
                'View Details',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 2.h,
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          SizedBox(
            width: 1.w,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Navigation.instance
                //     .navigate('/bookInfo', args: data.id);

                if ((Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .profile !=
                        null) &&
                    Storage.instance.isLoggedIn) {
                  ConstanceData.addtocart(context, data.id);
                } else {
                  ConstanceData.showAlertDialog(context);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text(
                'Add To Cart',
                style: Theme.of(context).textTheme.headline5?.copyWith(
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
                if (data.book_format == "magazine") {
                  Navigation.instance
                      .navigate('/magazineArticles', args: data.id ?? 0);
                } else {
                  Navigation.instance.navigate('/bookInfo', args: data.id);
                  // Navigation.instance.navigate('/reading',
                  //     args: data.id ?? 0);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text(
                'View Details',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontSize: 2.h,
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          SizedBox(
            width: 1.w,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Navigation.instance
                //     .navigate('/bookInfo', args: data.id);

                if ((Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .profile !=
                        null) &&
                    Storage.instance.isLoggedIn) {
                  ConstanceData.addtocart(context, data.id);
                } else {
                  ConstanceData.showAlertDialog(context);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text(
                'Add To Cart',
                style: Theme.of(context).textTheme.headline5?.copyWith(
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
