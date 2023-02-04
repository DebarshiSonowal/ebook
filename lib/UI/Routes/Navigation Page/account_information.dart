import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Storage/data_provider.dart';
import '../../Components/section_information.dart';

class AccountInformation extends StatefulWidget {
  const AccountInformation({Key? key}) : super(key: key);

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  String version = "";
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final dateController = TextEditingController();
  var date = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        date = Jiffy(Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .profile
                    ?.date_of_birth ??
                "")
            .format("dd-MM-yyyy");
        nameController.text = ""
            "${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.f_name ?? ''} "
            "${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.l_name ?? ''}"
            "";
        emailController.text = Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .profile
                ?.email ??
            "";
        mobileController.text = Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .profile
                ?.mobile ??
            "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Account',
          style: Theme.of(context).textTheme.headline3,
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
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionInformation(
                  name: 'Name',
                  data: ""
                      "${data.profile?.f_name ?? ''} ${data.profile?.l_name ?? ''}"
                      "",
                  controller: nameController,
                  type: 0,
                  dateChanged: (String date) {},
                ),
                SectionInformation(
                  name: 'Email',
                  data: data.profile?.email ?? "",
                  controller: emailController,
                  type: 1,
                  dateChanged: (String date) {},
                ),
                SectionInformation(
                  name: 'Mobile No',
                  data: data.profile?.mobile ?? "",
                  controller: mobileController,
                  type: 2,
                  dateChanged: (String date) {},
                ),
                SectionInformation(
                  name: 'Date of Birth',
                  data: date,
                  controller: dateController,
                  type: 3,
                  dateChanged: (String date) {
                    setState(() {
                      this.date = date;
                    });
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 5.h,
                  child: ElevatedButton(
                    onPressed: () {
                      updateProfile(nameController.text, emailController.text,
                          mobileController.text, date);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 50, vertical: 20),
                      textStyle:
                          Theme.of(context).textTheme.headline5?.copyWith(
                                fontSize: 17.sp,
                                color: Colors.black,
                              ),
                    ),
                    child: Text(
                      'Update',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontSize: 15.sp,
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void updateProfile(
      String name, String email, String mobile, String date) async {
    final response =
        await ApiProvider.instance.updateProfile(name, email, mobile, date);
    if (response.status ?? false) {
      Fluttertoast.showToast(msg: "Profile updated");
    } else {
      Fluttertoast.showToast(msg: response.message ?? "Something went wrong");
    }
  }

// SectionInformation(
//     String s, String t, TextEditingController controller, int type) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         s,
//         style: Theme.of(context).textTheme.headline5,
//       ),
//       SizedBox(
//         height: 0.5.h,
//       ),
//       (type == 0 || type == 1 || type == 2 || type == 3)
//           ? TextField(
//               controller: controller,
//               keyboardType: type == 1
//                   ? TextInputType.name
//                   : (type == 2
//                       ? TextInputType.emailAddress
//                       : TextInputType.phone),
//             )
//           : GestureDetector(
//               onTap: () {},
//               child: Text(
//                 t,
//                 style: Theme.of(context).textTheme.headline5?.copyWith(
//                       fontSize: 18.sp,
//                     ),
//               ),
//             ),
//       SizedBox(
//         height: 0.5.h,
//       ),
//       Divider(
//         color: Colors.grey.shade200,
//         thickness: 0.5,
//       ),
//       SizedBox(
//         height: 1.h,
//       ),
//     ],
//   );
// }
}
