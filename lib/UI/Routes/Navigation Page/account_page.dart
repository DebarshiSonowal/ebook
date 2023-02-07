import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/Storage/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
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
                        'Hi, ${data.profile?.f_name ?? "Subscriber"}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: Storage.instance.isLoggedIn
                          ? ConstanceData.pages.length
                          : ConstanceData.pages2.length,
                      itemBuilder: (cont, ind) {
                        var current = Storage.instance.isLoggedIn
                            ? ConstanceData.pages[ind]
                            : ConstanceData.pages2[ind];
                        return ListTile(
                          onTap: () {
                            Storage.instance.isLoggedIn
                                ? LoggedInAction(ind)
                                : UnauthorizedAction(ind);
                          },
                          title: Text(
                            ind == 0
                                ? ((data.profile == null ||
                                        !Storage.instance.isLoggedIn)
                                    ? "Sign In"
                                    : current)
                                : current,
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
          );
        }),
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  LoggedInAction(int ind) {
    switch (ind) {
      case 0:
        Navigation.instance.navigate('/accountInformation');
        break;
      case 1:
        Provider.of<DataProvider>(context, listen: false).clearAllData();
        Storage.instance.logout();
        Navigation.instance.navigate('/main');
        break;
      case 2:
        Share.share('https://play.google.com/store/apps/details?id=com.tsinfosec.ebook.ebook');
        break;
      case 3:
        _launchUrl(Uri.parse('https://tratri.in/refund-and-cancellation'));
        break;
      case 5:
        _launchUrl(Uri.parse('https://tratri.in/privacy-policy'));
        break;
      case 6:
        _launchUrl(Uri.parse('https://tratri.in/contact-us'));
        break;
      case 7:
        _launchUrl(Uri.parse('https://tratri.in/https://tratri.in/about-us'));
        break;
      default:
        break;
    }
  }

  UnauthorizedAction(int ind) {
    switch (ind) {
      case 0:
        // Provider.of<DataProvider>(context, listen: false).clearAllData();
        // Storage.instance.logout();
        Navigation.instance.navigate('/login');
        break;
      case 1:
        Share.share('https://play.google.com/store/apps/details?id=com.tsinfosec.ebook.ebook');
        break;
      case 2:
        _launchUrl(Uri.parse('https://tratri.in/refund-and-cancellation'));
        break;
      case 4:
        _launchUrl(Uri.parse('https://tratri.in/privacy-policy'));
        break;
      case 5:
        _launchUrl(Uri.parse('https://tratri.in/contact-us'));
        break;
      case 6:
        _launchUrl(Uri.parse('https://tratri.in/https://tratri.in/about-us'));
        break;
      default:
        break;
    }
  }
}
