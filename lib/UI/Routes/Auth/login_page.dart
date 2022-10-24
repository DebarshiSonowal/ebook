import 'package:awesome_icons/awesome_icons.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Storage/data_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 6.h,
                ),
                Image.asset(
                  ConstanceData.primaryIcon,
                  fit: BoxFit.fill,
                  height: 20.h,
                  width: 34.w,
                ),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.white,
                      ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 6.5.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      cursorHeight:
                          Theme.of(context).textTheme.headline5?.fontSize,
                      autofocus: false,
                      controller: _phoneController,
                      cursorColor: Colors.white,
                      style: Theme.of(context).textTheme.headline5,
                      decoration: InputDecoration(
                        labelText: 'Enter your registered phone number',
                        hintText: "Mobile number",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontSize: 10.sp),
                        hintStyle:
                            Theme.of(context).textTheme.headline5?.copyWith(
                                  color: Colors.grey.shade400,
                                ),
                        // prefixIcon: Icon(Icons.star,color: Colors.white,),
                        // suffixIcon: Icon(Icons.keyboard_arrow_down,color: Colors.white,),
                        // contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 6.5.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      cursorHeight:
                          Theme.of(context).textTheme.headline5?.fontSize,
                      autofocus: false,
                      controller: _passwordController,
                      cursorColor: Colors.white,
                      style: Theme.of(context).textTheme.headline5,
                      decoration: InputDecoration(
                        labelText: 'Enter your password',
                        hintText: "password",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontSize: 10.sp),
                        hintStyle:
                            Theme.of(context).textTheme.headline5?.copyWith(
                                  color: Colors.grey.shade400,
                                ),
                        // prefixIcon: Icon(Icons.star,color: Colors.white,),
                        // suffixIcon: Icon(Icons.keyboard_arrow_down,color: Colors.white,),
                        // contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                //   width: double.infinity,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Text(
                //         "Forgot Password ?",
                //         style: Theme.of(context).textTheme.headline6,
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 4.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 6.5.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_phoneController.text.isNotEmpty&&_phoneController.text.length==10&&_passwordController.text.isNotEmpty) {
                            Login();
                          } else {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.warning,
                              text: "Enter proper credentials",
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Text(
                          'Login',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    fontSize: 3.h,
                                    color: Colors.black,
                                  ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                GestureDetector(
                  onTap: (){
                    Navigation.instance.navigate('/signup');
                  },
                  child: Text(
                    "Don't have an account? Signup",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                // Text('Signup'),
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Container(
                //         padding: EdgeInsets.all(5.0),
                //         decoration: const BoxDecoration(
                //           color: Colors.white,
                //           shape: BoxShape.circle,
                //         ),
                //         child: Icon(
                //           FontAwesomeIcons.google,
                //           color: Colors.red,
                //           size: 5.h,
                //         ),
                //       ),
                //       // Container(
                //       //   padding: EdgeInsets.all(5.0),
                //       //   decoration: const BoxDecoration(
                //       //     color: Colors.white,
                //       //     shape: BoxShape.circle,
                //       //   ),
                //       //   child: Icon(
                //       //     FontAwesomeIcons.facebook,
                //       //     color: Colors.blueAccent,
                //       //     size: 5.h,
                //       //   ),
                //       // ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void Login() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance
        .loginSubscriber(_phoneController.text, _passwordController.text);
    if (response.status ?? false) {

      await Storage.instance.setUser(response.access_token ?? "");
      fetchProfile();

    }else{
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Something went wrong",
      );
    }
  }
  void fetchProfile() async {
    final response = await ApiProvider.instance.getProfile();
    if (response.status ?? false) {
      Provider.of<DataProvider>(
          Navigation.instance.navigatorKey.currentContext ?? context,
          listen: false)
          .setProfile(response.profile!);
      Navigation.instance.goBack();
      Navigation.instance.navigate('/main');
    }else{
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Something went wrong",
      );
    }
  }
}
