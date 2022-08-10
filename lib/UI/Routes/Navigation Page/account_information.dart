import 'package:ebook/Helper/navigator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
                  horizontal: 2.w,
                ),
                child: Text(
                  'SIGN OUT',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                'xyz@gmail.com',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontSize: 18.sp,
                    ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Divider(
                color: Colors.grey.shade200,
                thickness: 0.5,
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Membership',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                'None',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                'Become a Subscriber',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  fontSize: 12.sp,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Divider(
                color: Colors.grey.shade200,
                thickness: 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
