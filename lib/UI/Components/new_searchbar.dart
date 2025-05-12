import 'dart:io';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:badges/badges.dart' as badge;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Model/book.dart';
import 'package:sizer/sizer.dart';

import '../../Storage/app_storage.dart';

class NewSearchBar extends StatelessWidget {
  const NewSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // height: 7.h,
      width: double.infinity,
      color: Color(0xff121212),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // https://tratri.in
              Navigation.instance.navigateAndRemoveUntil('/main');
              Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ??
                          context,
                      listen: false)
                  .setIndex(0);
            },
            child: SizedBox(
              // width: 20.w,
              height: 7.h,
              child: Center(
                child: Image.asset(
                  ConstanceData.primaryIcon,
                  height: 6.h,
                  width: 6.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          (Platform.isAndroid && !Storage.instance.isLoggedIn)
              ? GestureDetector(
                  onTap: () {
                    // _launchUrl(Uri.parse('https://tratri.in/login/contributor'));
                    // _launchUrl(Uri.parse('https://tratri.in'));
                    Navigation.instance.navigate("/login");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        // color: ConstanceData.cardColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        border: Border.all(color: Colors.white)),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 1.h),
                    child: Text(
                      'Login/Register',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 14.sp,
                          ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            width: 1.w,
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              Navigation.instance.navigate('/search');
              // showSearch(
              //   context: context,
              //   delegate: SearchPage<Book_old>(
              //     items: ConstanceData.Motivational,
              //     searchLabel: 'Search Books',
              //     suggestion: const Center(
              //       child: Text('Filter people by name, surname or age'),
              //     ),
              //     failure: const Center(
              //       child: Text('No person found :('),
              //     ),
              //     filter: (current) => [
              //       current.name,
              //       current.author,
              //       // person.age.toString(),
              //     ],
              //     builder: (book) => ListTile(
              //       title: Text(
              //         book.name ?? '',
              //         style: Theme.of(context).textTheme.headline5,
              //       ),
              //       subtitle: Text(
              //         book.author ?? '',
              //         style: Theme.of(context).textTheme.headline6,
              //       ),
              //       trailing: CachedNetworkImage(
              //         imageUrl: book.image ?? '',
              //         height: 10.h,
              //         width: 15.w,
              //       ),
              //     ),
              //   ),
              // );
            },
            child: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 1.w,
          ),
          Consumer<DataProvider>(builder: (context, data, _) {
            return Platform.isAndroid
                ? GestureDetector(
                    onTap: () {
                      if ((Provider.of<DataProvider>(
                                      Navigation.instance.navigatorKey
                                              .currentContext ??
                                          context,
                                      listen: false)
                                  .profile !=
                              null) &&
                          Storage.instance.isLoggedIn) {
                        Navigation.instance.navigate('/cartPage');
                      } else {
                        ConstanceData.showAlertDialog(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: data.cartData?.items.isEmpty ?? true
                          ? const Icon(
                              Icons.shopping_cart,
                              // size: 2.h
                            )
                          : badge.Badge(
                              position: badge.BadgePosition.topEnd(),
                              // badgeColor: ConstanceData.primaryColor,
                              badgeContent: Text(
                                '${data.cartData?.items.length ?? ""}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              child: const Icon(
                                ConstanceData.storeIcon,
                                // size: 2.h
                              ),
                            ),
                    ),
                  )
                : Container();
          }),
          GestureDetector(
            onTap: () {
              Navigation.instance.navigate('/notifications');
            },
            child: Consumer<DataProvider>(
              builder: (context, data, _) {
                if (data.notifications.isNotEmpty) {
                  return badge.Badge(
                    position: badge.BadgePosition.topEnd(),
                    badgeContent: Text(
                      '${data.notifications.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  );
                } else {
                  return const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  );
                }
              },
            ),
          ),
          SizedBox(
            width: 1.5.w,
          ),
          Storage.instance.isLoggedIn
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigation.instance.navigate("/wallet");
                        },
                        child: Icon(
                          FontAwesomeIcons.coins,
                          color: Colors.amber,
                          size: 16.sp,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      GestureDetector(
                        onTap: () {
                          Navigation.instance.navigate("/wallet");
                        },
                        child:
                            Consumer<DataProvider>(builder: (context, data, _) {
                          return Text(
                            "${data.rewardResult?.totalPoints ?? 0}",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          );
                        }),
                      ),
                    ],
                  ),
                )
              : Container(),
          SizedBox(
            width: 2.w,
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
