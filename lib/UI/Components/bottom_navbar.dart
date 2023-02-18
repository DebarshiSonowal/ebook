import 'dart:ui';

import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Storage/data_provider.dart';
import 'package:sizer/sizer.dart';

class BottomNavBarCustom extends StatefulWidget {
  const BottomNavBarCustom({Key? key}) : super(key: key);

  @override
  State<BottomNavBarCustom> createState() => _BottomNavBarCustomState();
}

class _BottomNavBarCustomState extends State<BottomNavBarCustom> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, _) {
      return Container(
        padding: EdgeInsets.only(top: 0.2.h),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.white30,
            Colors.white,
            Colors.white30,
          ]),
        ),
        child: BottomNavigationBar(
            backgroundColor: ConstanceData.secondaryColor,
            selectedItemColor: Colors.white,
            currentIndex: data.currentIndex,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.white70,
            //
            // unselectedItemColor: Colors.white,
            unselectedLabelStyle: TextStyle(
              fontSize: 1.5.h,
              color: Colors.white,
            ),
            onTap: (i) {
              if (i != 4 && i != 2) {
                Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .setIndex(i);
              } else if (i == 2) {
                if (data.details?.book_format == "magazine") {
                  Navigation.instance.navigate('/magazineArticles',
                      args: data.details?.id ?? 0);
                  // ConstanceData.show(context, data.details!);
                } else {
                  if (data.details != null) {
                    Navigation.instance
                        .navigate('/bookDetails', args: data.details?.id ?? 0);
                    // ConstanceData.show(context, data.details!);
                  }
                  // Navigation.instance
                  //     .navigate('/bookDetails', args: data.details?.id ?? 0);
                }
              } else {
                Navigation.instance.navigate('/accountDetails');
              }
            },
            items: [
              BottomNavigationBarItem(
                  backgroundColor: ConstanceData.secondaryColor,
                  icon: Image.asset(
                    ConstanceData.homeIcon,
                    height: 3.5.h,
                    width: 7.w,
                    fit: BoxFit.fill,
                    color: Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: true)
                                .currentIndex ==
                            0
                        ? Colors.white
                        : Colors.grey,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  backgroundColor: ConstanceData.secondaryColor,
                  icon: Image.asset(
                    ConstanceData.libraryIcon,
                    height: 3.5.h,
                    width: 7.w,
                    fit: BoxFit.fill,
                    color: Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: true)
                                .currentIndex ==
                            1
                        ? Colors.white
                        : Colors.grey,
                  ),
                  label: 'Library'),
              BottomNavigationBarItem(
                  backgroundColor: ConstanceData.secondaryColor,
                  icon: Consumer<DataProvider>(builder: (cont, data, _) {
                    return data.details == null
                        ? Image.asset(
                            ConstanceData.primaryIcon,
                            height: 4.5.h,
                            width: 9.w,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            ConstanceData.readingIcon,
                            height: 4.5.h,
                            width: 10.w,
                            fit: BoxFit.fill,
                          );
                  }),
                  label: ''),
              BottomNavigationBarItem(
                  backgroundColor: ConstanceData.secondaryColor,
                  icon: Image.asset(
                    ConstanceData.orderIcon,
                    height: 3.5.h,
                    width: 7.w,
                    fit: BoxFit.fill,
                    color: Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: true)
                                .currentIndex ==
                            3
                        ? Colors.white
                        : Colors.grey,
                  ),
                  label: 'Orders'),
              BottomNavigationBarItem(
                  backgroundColor: ConstanceData.secondaryColor,
                  icon: Image.asset(
                    ConstanceData.humanImage,
                    height: 3.5.h,
                    width: 7.w,
                    fit: BoxFit.fill,
                    color: Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: true)
                                .currentIndex ==
                            4
                        ? Colors.white
                        : Colors.grey,
                  ),
                  label: 'More'),
            ]),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchReadingBook();
    });
  }

  void fetchReadingBook() async {
    if (Storage.instance.readingBook != 0) {
      final response = await ApiProvider.instance
          .fetchBookDetails(Storage.instance.readingBook.toString());
      if (response.status ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setBookDetails(response.details!);
      }
    }
  }
}
