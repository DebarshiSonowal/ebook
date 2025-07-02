import 'dart:io';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:badges/badges.dart' as badge;
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/constance_data.dart';
import '../../Helper/navigator.dart';
import '../../Model/book.dart';
import 'package:sizer/sizer.dart';

import '../../Storage/app_storage.dart';
import '../../Networking/api_provider.dart';

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
          SizedBox(width: 2.w),
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
              : (Platform.isAndroid &&
                      Storage.instance.isLoggedIn &&
                      Provider.of<DataProvider>(
                                  Navigation.instance.navigatorKey
                                          .currentContext ??
                                      context,
                                  listen: false)
                              .profile
                              ?.mobile
                              ?.isEmpty ==
                          true)
                  ? Consumer<DataProvider>(
                      builder: (context, data, _) {
                        return GestureDetector(
                          onTap: () {
                            _showPhoneUpdateDialog(
                                context, data.profile?.mobile ?? '');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                border: Border.all(color: Colors.white)),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.5.w, vertical: 1.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  data.profile?.mobile?.isNotEmpty == true
                                      ? "Update Phone"
                                      : 'Add Phone',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontSize: 14.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
          SizedBox(
            width: 1.w,
          ),
          Spacer(),
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

  void _showPhoneUpdateDialog(BuildContext context, String currentPhoneNumber) {
    TextEditingController _phoneController =
        TextEditingController(text: currentPhoneNumber);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Update Phone Number',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your new phone number',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: ConstanceData.primaryColor),
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                String newPhoneNumber = _phoneController.text.trim();
                if (newPhoneNumber.isNotEmpty) {
                  try {
                    Navigator.of(context).pop();
                    // Show loading dialog
                    Navigation.instance.navigate('/loadingDialog');

                    final dataProvider = Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false);

                    final profile = dataProvider.profile;
                    if (profile != null) {
                      final name =
                          "${profile.f_name ?? ''} ${profile.l_name ?? ''}"
                              .trim();
                      final email = profile.email ?? '';
                      final dob = profile.date_of_birth ?? '';

                      // Call the existing updateProfile API
                      final response = await ApiProvider.instance
                          .updateProfile(name, email, newPhoneNumber, dob);

                      Navigation.instance.goBack(); // Close loading dialog

                      if (response.status == true) {
                        // Refresh profile data
                        final profileResponse =
                            await ApiProvider.instance.getProfile();
                        if (profileResponse.status == true &&
                            profileResponse.profile != null) {
                          dataProvider.setProfile(profileResponse.profile!);
                        }

                        Fluttertoast.showToast(
                            msg: 'Phone number updated successfully');
                      } else {
                        Fluttertoast.showToast(
                            msg: response.message ??
                                'Failed to update phone number');
                      }
                    } else {
                      Navigation.instance.goBack();
                      Fluttertoast.showToast(msg: 'Profile not found');
                    }
                  } catch (e) {
                    Navigation.instance.goBack();
                    Fluttertoast.showToast(msg: 'An error occurred: $e');
                  }
                } else {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: 'Please enter a valid phone number');
                }
              },
              child: Text(
                'Update',
                style: TextStyle(
                  color: ConstanceData.primaryColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
