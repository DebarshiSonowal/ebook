import 'package:awesome_icons/awesome_icons.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Storage/data_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigation.instance.goBack();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 3.h,
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
                  height: 4.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 6.5.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      cursorHeight:
                          Theme.of(context).textTheme.headline5?.fontSize,
                      autofocus: false,
                      controller: _emailController,
                      cursorColor: Colors.white,
                      style: Theme.of(context).textTheme.headline5,
                      decoration: InputDecoration(
                        labelText: 'Enter your email',
                        hintText: "Email Address",
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
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.5),
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
                      obscureText: true,
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
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.5),
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
                  height: 3.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 6.5.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
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
                  height: 2.h,
                ),
                GestureDetector(
                  onTap: () {
                    _launchUrl(
                        Uri.parse("https://tratri.in/app-forget-password"));
                  },
                  child: Text(
                    "Forgot Password",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontSize: 9.sp,
                        ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigation.instance.navigate('/signup');
                  },
                  child: Text(
                    "Don't have an account? Signup",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  width: 60.w,
                  child: SocialLoginButton(
                    backgroundColor: Colors.amber,
                    height: 40,
                    text: 'Sign In',
                    borderRadius: 5,
                    fontSize: 15.sp,
                    buttonType: SocialLoginButtonType.google,
                    // imageWidth: 20,
                    // imagepath: "assets/file.png",
                    // imageURL: "URL",
                    onPressed: () async {
                      final response = await signInWithGoogle();
                      loginSocial(
                        response.user?.displayName?.split(" ")[0] ?? "",
                        ((response.user?.displayName?.split(" ").length ?? 0) >
                                1)
                            ? response.user?.displayName?.split(" ")[1]
                            : "",
                        response.user?.email ?? "",
                        "",
                        "google",
                        response.user?.phoneNumber ?? "",
                      );
                      // loginEmail();
                    },
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
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
    final response = await ApiProvider.instance.socialLogin(
        "", "", _emailController.text, _passwordController.text, "normal","");
    if (response.status ?? false) {
      await Storage.instance.setUser(response.access_token ?? "");
      fetchProfile();
    } else {
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: response.message ?? "Something went wrong",
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
    } else {
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Something went wrong",
      );
    }
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url, mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $_url';
    }
  }

  void loginSocial(fname, lname, email, password, provider, mobile) async {
    Navigation.instance.navigate("/loadingDialog");
    final response = await ApiProvider.instance
        .socialLogin(fname, lname, email, password, provider, mobile);
    if (response.status ?? false) {
      Navigation.instance.goBack();
      await Storage.instance.setUser(response.access_token ?? "");
      fetchProfile();
    } else {
      Navigation.instance.goBack();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: response.message ?? "Something went wrong",
      );
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
