import 'dart:io';

import 'package:awesome_icons/awesome_icons.dart';

// import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Storage/data_provider.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

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
        backgroundColor: Colors.black,
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
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 20.sp,
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
                          Theme.of(context).textTheme.headlineSmall?.fontSize,
                      autofocus: false,
                      controller: _emailController,
                      cursorColor: Colors.white,
                      // style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        labelText: 'Enter your email',
                        hintText: "Email Address",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 14.sp),
                        hintStyle:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.grey.shade400,
                                  fontSize: 15.sp,
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
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 16.sp),
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
                          Theme.of(context).textTheme.headlineSmall?.fontSize,
                      autofocus: false,
                      controller: _passwordController,
                      cursorColor: Colors.white,
                      obscureText: true,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 16.sp),
                      decoration: InputDecoration(
                        labelText: 'Enter your password',
                        hintText: "password",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 14.sp),
                        hintStyle:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.grey.shade400,
                                  fontSize: 15.sp,
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
                  height: 5.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty &&
                              _emailController.text.isValidEmail()) {
                            Login();
                          } else {
                            // CoolAlert.show(
                            //   context: context,
                            //   type: CoolAlertType.warning,
                            //   text: "Enter proper credentials",
                            // );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        child: Text(
                          'Login',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 13.sp,
                        ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                // GestureDetector(
                //   onTap: () {
                //     Navigation.instance.navigate('/signup');
                //   },
                //   child: Text(
                //     "Don't have an account? Signup",
                //     style: Theme
                //         .of(context)
                //         .textTheme
                //         .headline5,
                //   ),
                // ),
                SizedBox(
                  height: 3.h,
                ),
                Platform.isAndroid
                    ? SizedBox(
                        width: 60.w,
                        child: SocialLoginButton(
                          backgroundColor: Colors.white70,
                          height: 40,
                          text: 'Sign in',
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
                                ((response.user?.displayName
                                                ?.split(" ")
                                                .length ??
                                            0) >
                                        1)
                                    ? response.user?.displayName?.split(" ")[1]
                                    : "",
                                response.user?.email ?? "",
                                "",
                                "google",
                                response.user?.phoneNumber ?? "",
                                "");
                            // loginEmail();
                          },
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: Platform.isIOS ? 1.h : 0,
                ),
                // SignInWithAppleButton(
                //   onPressed: () async {
                //     final credential =
                //         await SignInWithApple.getAppleIDCredential(
                //       scopes: [
                //         AppleIDAuthorizationScopes.email,
                //         AppleIDAuthorizationScopes.fullName,
                //       ],
                //     );
                //
                //     print(credential);
                //
                //     // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                //     // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                //   },
                // ),
                // Platform.isIOS
                //     ? SizedBox(
                //         width: 60.w,
                //         child: SocialLoginButton(
                //           backgroundColor: Colors.white70,
                //           height: 40,
                //           text: 'Sign in',
                //           borderRadius: 5,
                //           fontSize: 15.sp,
                //           buttonType: SocialLoginButtonType.apple,
                //           // imageWidth: 20,
                //           // imagepath: "assets/file.png",
                //           // imageURL: "URL",
                //           onPressed: () async {
                //             await signInWithApple();
                //             //
                //             // print(response);
                //             // print(response.user);
                //             // print(response.additionalUserInfo);
                //             // print(response.credential);
                //
                //             // print(credential);
                //             // Fluttertoast.showToast(msg: "${response.user} ${response.additionalUserInfo} ${response.credential} ${credential}");
                //             // loginSocial(
                //             //   response.user?.displayName?.split(" ")[0] ?? "",
                //             //   ((response.user?.displayName?.split(" ").length ?? 0) >
                //             //           1)
                //             //       ? response.user?.displayName?.split(" ")[1]
                //             //       : "",
                //             //   response.user?.email ?? "",
                //             //   "",
                //             //   "google",
                //             //   response.user?.phoneNumber ?? "",
                //             // );
                //             // loginEmail();
                //           },
                //         ),
                //       )
                //     : Container(),
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
    final response = await ApiProvider.instance.socialLogin("", "",
        _emailController.text, _passwordController.text, "normal", "", "");
    if (response.status ?? false) {
      await Storage.instance.setUser(response.access_token ?? "");
      fetchProfile();
    } else {
      Navigation.instance.goBack();
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.error,
      //   text: response.message ?? "Something went wrong",
      // );
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
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.error,
      //   text: "Something went wrong",
      // );
    }
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url, mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $_url';
    }
  }

  void loginSocial(
      fname, lname, email, password, provider, mobile, apple_id) async {
    Navigation.instance.navigate("/loadingDialog");
    final response = await ApiProvider.instance
        .socialLogin(fname, lname, email, password, provider, mobile, apple_id);
    if (response.status ?? false) {
      Navigation.instance.goBack();
      await Storage.instance.setUser(response.access_token ?? "");
      fetchProfile();
    } else {
      Navigation.instance.goBack();
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.error,
      //   text: response.message ?? "Something went wrong",
      // );
    }
  }

  Future<void> signInWithApple() async {
    // final appleProvider = AppleAuthProvider();
    // debugPrint("${appleProvider.parameters}");
    // // if (kIsWeb) {
    // //   await FirebaseAuth.instance.signInWithPopup(appleProvider);
    // // } else {
    //   return await FirebaseAuth.instance.signInWithProvider(appleProvider);
    // // }

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (credential.userIdentifier?.isNotEmpty ?? false) {
      if (!mounted) return;
      showTextFieldDialog(
        context,
        "Please Enter Your Credentials",
        "We need your details to provide you better services",
        credential.givenName == null
            ? ""
            : credential.familyName == null
                ? credential.givenName
                : "${credential.givenName} ${credential.familyName}",
        credential.email,
        "",
        (String? name, String? email, String mobile) {
          if (mobile.isNotEmpty && mobile.length == 10) {
            loginSocial(
              name?.split(" ")[0] ?? "",
              ((name?.split(" ").length ?? 0) > 1) ? name?.split(" ")[1] : "",
              email ?? "",
              "",
              "ios",
              mobile ?? "",
              credential.userIdentifier,
            );
          } else {
            Navigation.instance.goBack();
            // CoolAlert.show(
            //   context: context,
            //   type: CoolAlertType.error,
            //   text: "Please Enter Details",
            // );
          }
        },
      );
    }

    // if(credential)
  }

  void showTextFieldDialog(
      BuildContext context,
      String title,
      String hintText,
      String? nameText,
      String? emailText,
      String? mobileText,
      Function(String? name, String? email, String mobile) onSubmit) {
    showDialog(
      context: context,
      builder: (context) => TextFieldDialog(
        title: title,
        hintText: hintText,
        nameText: nameText,
        emailText: emailText,
        mobileText: mobileText,
        onSubmit: onSubmit,
      ),
    );
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

class TextFieldDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String? nameText;
  final String? emailText;
  final String? mobileText;
  final Function(String? name, String? email, String mobile) onSubmit;

  const TextFieldDialog({
    Key? key,
    required this.title,
    required this.hintText,
    required this.onSubmit,
    this.nameText,
    this.emailText,
    this.mobileText,
  }) : super(key: key);

  @override
  State<TextFieldDialog> createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _name.text = widget.nameText ?? "";
      _email.text = widget.emailText ?? "";
      _mobile.text = widget.mobileText ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 15.sp,
              color: Colors.white,
            ),
      ),
      content: Container(
        width: 80.w,
        padding: EdgeInsets.symmetric(
          horizontal: 1.w,
          vertical: 1.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.hintText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 11.sp,
                    color: Colors.white70,
                  ),
            ),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              width: 90.w,
              child: TextField(
                controller: _name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "Please enter your name (optional)",
                  labelStyle:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 10.sp,
                            color: Colors.black45,
                          ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 12.sp,
                      color: Colors.black,
                    ),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              width: 90.w,
              child: TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "Please enter your email (optional)",
                  labelStyle:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 10.sp,
                            color: Colors.black45,
                          ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 12.sp,
                      color: Colors.black,
                    ),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              width: 90.w,
              child: TextField(
                controller: _mobile,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Please enter your mobile number ",
                    labelStyle:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 10.sp,
                              color: Colors.black45,
                            ),
                    fillColor: Colors.white,
                    filled: true,
                    counterText: ""),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 12.sp,
                      color: Colors.black,
                    ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 10.sp,
                  color: Colors.white54,
                ),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onSubmit(_name.text, _email.text, _mobile.text);
            Navigator.of(context).pop();
          },
          child: Text(
            'Submit',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 10.sp,
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}
