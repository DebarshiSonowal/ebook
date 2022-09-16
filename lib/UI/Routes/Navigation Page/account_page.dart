import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Account',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 20.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(5.h), // Image radius
                        child: Image.asset(
                          ConstanceData.primaryIcon,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      'Hi, User',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 65.h,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ConstanceData.pages.length,
                    itemBuilder: (cont, ind) {
                      var data = ConstanceData.pages[ind];
                      return ListTile(
                        onTap: () {
                          if (ind == 0) {
                            Navigation.instance.navigate('/accountInformation');
                          }else if(ind == ConstanceData.pages.length-2){
                            Storage.instance.logout();
                            Navigation.instance.navigateAndRemoveUntil('/login');
                          }else if(ind == 1){
                            // Storage.instance.logout();
                            // Navigation.instance.navigate('/cartPage');
                          }
                        },
                        title: Text(
                          data,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      );
                    }),
              ),
              SizedBox(
                width: double.infinity,
                // height: 20.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      ConstanceData.primaryIcon,
                      fit: BoxFit.fill,
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      'Made in India',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      'version 12.15',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
