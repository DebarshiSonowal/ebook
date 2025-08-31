import 'dart:io';
import 'dart:ui';

import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
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
            unselectedLabelStyle: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
            ),
            onTap: (i) {
              debugPrint("onTap: $i");
              if (Platform.isAndroid) {
                switch (i) {
                  case 1:
                    if (Storage.instance.isLoggedIn) {
                      showLibrary();
                    } else {
                      Navigation.instance.navigate("/login");
                    }
                    break;
                  case 2:
                    if (data.details != null) {
                      if (data.details?.book_format == "magazine") {
                        Navigation.instance.navigate('/magazineArticles',
                            args: data.details?.id ?? 0);
                      } else {
                        Navigation.instance.navigate('/bookDetails',
                            args:
                                '${data.details?.id ?? 0},${data.details?.profile_pic}');
                      }
                    }
                    break;
                  case 3:
                    if (Storage.instance.isLoggedIn) {
                      Navigation.instance.navigate('/orderHistory');
                    } else {
                      Navigation.instance.navigate("/login");
                    }

                    break;
                  case 4:
                    Navigation.instance.navigate('/accountDetails');
                    break;
                  default:
                    Provider.of<DataProvider>(
                            Navigation.instance.navigatorKey.currentContext ??
                                context,
                            listen: false)
                        .setIndex(i);
                    break;
                }
              } else {
                switch (i) {
                  case 1:
                    if (Storage.instance.isLoggedIn) {
                      showLibrary();
                    } else {
                      Navigation.instance.navigate("/login");
                    }
                    break;
                  case 2:
                    if (data.details != null) {
                      if (data.details?.book_format == "magazine") {
                        Navigation.instance.navigate('/magazineArticles',
                            args: data.details?.id ?? 0);
                      } else {
                        Navigation.instance.navigate('/bookDetails',
                            args:
                                '${data.details?.id ?? 0},${data.details?.profile_pic}');
                      }
                    }
                    break;
                  case 3:
                    Navigation.instance.navigate('/accountDetails');
                    break;
                  default:
                    Provider.of<DataProvider>(
                            Navigation.instance.navigatorKey.currentContext ??
                                context,
                            listen: false)
                        .setIndex(i);
                    break;
                }
              }
            },
            items: [
              BottomNavigationBarItem(
                  backgroundColor: ConstanceData.secondaryColor,
                  icon: Image.asset(
                    ConstanceData.homeIcon,
                    height: 3.h,
                    width: 5.5.w,
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
                    height: 3.h,
                    width: 5.5.w,
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
                  label: 'Collections'),
              BottomNavigationBarItem(
                  backgroundColor: ConstanceData.secondaryColor,
                  icon: Consumer<DataProvider>(builder: (cont, data, _) {
                    return data.details == null
                        ? Image.asset(
                            ConstanceData.primaryIcon,
                            height: 5.h,
                            width: 7.5.w,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            ConstanceData.readingIcon,
                            // height: 5.h,
                            width: 11.w,
                            fit: BoxFit.fill,
                          );
                  }),
                  label: ''),
              if (!Platform.isIOS)
                BottomNavigationBarItem(
                    backgroundColor: ConstanceData.secondaryColor,
                    icon: Image.asset(
                      ConstanceData.orderIcon,
                      height: 3.h,
                      width: 5.5.w,
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
                    height: 3.h,
                    width: 6.w,
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
                  label: 'Account'),
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

  void showLibrary() {
    debugPrint("This");
    if (Provider.of<DataProvider>(context, listen: false).libraries.length >=
        2) {
      showModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0.6),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Select Library',
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
                SizedBox(
                  height: 2.h,
                ),
                InkWell(
                  onTap: () {
                    debugPrint("Select Library");
                    Navigator.of(context).pop();
                    Provider.of<DataProvider>(
                            Navigation.instance.navigatorKey.currentContext ??
                                context,
                            listen: false)
                        .setIndex(1);
                    // Navigation.instance.navigate('/myLibrary');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 1.w,
                      vertical: 0.02.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu_book_sharp,
                          color: Colors.white60,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'My Shelf-Bought & Bookmark',
                          style:
                              TextStyle(fontSize: 15.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white54,
                ),
                Consumer<DataProvider>(builder: (context, data, _) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var item = data.libraries[index];
                      return InkWell(
                        onTap: () {
                          // Navigator.of(context).pop();
                          Navigation.instance
                              .navigate('/libraryBooks', args: item.id);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.w,
                            vertical: 0.05.h,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.menu_book_sharp,
                                color: Colors.white60,
                              ),
                              SizedBox(width: 2.w),
                              SizedBox(
                                width: 80.w,
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                      fontSize: 15.sp, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.white54,
                      );
                    },
                    itemCount: data.libraries.length,
                  );
                }),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          );
        },
      );
    } else {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setIndex(1);
    }
  }
}
