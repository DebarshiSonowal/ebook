import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String version = "1.0";

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Account',
          style: Theme.of(context).textTheme.headline4,
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
                height: 15.h,
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
                      'Hi, ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.f_name}',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ConstanceData.pages.length,
                    itemBuilder: (cont, ind) {
                      var data = ConstanceData.pages[ind];
                      return ListTile(
                        onTap: () {
                          if (ind == 0) {
                            Navigation.instance.navigate('/accountInformation');
                          } else if (ind == 1) {
                            Storage.instance.logout();
                            Navigation.instance.navigate('/login');
                          } else if (ind == 5) {
                            // Storage.instance.logout();
                            // Navigation.instance.navigate('/cartPage');
                            _launchUrl(
                                Uri.parse('https://tratri.in/privacy-policy'));
                          } else if (ind == 6) {
                            // Storage.instance.logout();
                            // Navigation.instance.navigate('/cartPage');
                            _launchUrl(
                                Uri.parse('https://tratri.in/contact-us'));
                          } else if (ind == 3) {
                            // Storage.instance.logout();
                            // Navigation.instance.navigate('/cartPage');
                            _launchUrl(Uri.parse(
                                'https://tratri.in/refund-and-cancellation'));
                          } else if (ind == 7) {
                            // Storage.instance.logout();
                            // Navigation.instance.navigate('/cartPage');
                            _launchUrl(Uri.parse(
                                'https://tratri.in/https://tratri.in/about-us'));
                          }
                        },
                        title: Text(
                          ind == 1
                              ? (Provider.of<DataProvider>(Navigation.instance
                                              .navigatorKey.currentContext!)
                                          .profile ==
                                      null
                                  ? "Sign In"
                                  : data)
                              : data,
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
                    // Image.asset(
                    //   ConstanceData.primaryIcon,
                    //   fit: BoxFit.fill,
                    //   height: 10.h,
                    // ),
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
                      'version ${version}',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 5.h,
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

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
