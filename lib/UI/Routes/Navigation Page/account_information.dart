import 'package:ebook/Helper/navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Storage/data_provider.dart';

class AccountInformation extends StatefulWidget {
  const AccountInformation({Key? key}) : super(key: key);

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Account',
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: Text(
                  'Sign Out',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionInformation(
                'Name',
                ""
                    "${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: true).profile?.f_name ?? ''} ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: true).profile?.l_name ?? ''}"
                    "",
              ),
              SectionInformation(
                'Email',
                Provider.of<DataProvider>(
                            Navigation.instance.navigatorKey.currentContext ??
                                context,
                            listen: true)
                        .profile
                        ?.email ??
                    "",
              ),
              SectionInformation(
                'Mobile No',
                Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ??
                        context,
                    listen: true)
                    .profile
                    ?.mobile ??
                    "",
              ),
            ],
          ),
        ),
      ),
    );
  }

  SectionInformation(String s, String t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(
          height: 0.5.h,
        ),
        Text(
          t,
          style: Theme.of(context).textTheme.headline4?.copyWith(
                fontSize: 18.sp,
              ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        Divider(
          color: Colors.grey.shade200,
          thickness: 0.5,
        ),
        SizedBox(
          height: 1.h,
        ),
      ],
    );
  }
}
