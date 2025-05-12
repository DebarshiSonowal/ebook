import 'dart:io';

import 'package:awesome_icons/awesome_icons.dart';

// import 'package:cool_alert/cool_alert.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:ebook/Storage/app_storage.dart';
import 'package:ebook/UI/Routes/Auth/text_field_dialog.dart';
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
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
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 3.h),
                  Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      ConstanceData.primaryIcon,
                      fit: BoxFit.contain,
                      height: 20.h,
                      width: 34.w,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  _buildTextField(
                    context: context,
                    controller: _emailController,
                    hintText: "Email Address",
                    labelText: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                  ),
                  SizedBox(height: 2.h),
                  _buildTextField(
                    context: context,
                    controller: _passwordController,
                    hintText: "Password",
                    labelText: "Enter your password",
                    isObscure: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  SizedBox(height: 4.h),
                  _buildLoginButton(context),
                  SizedBox(height: 2.5.h),
                  GestureDetector(
                    onTap: () {
                      _launchUrl(
                          Uri.parse("https://tratri.in/app-forget-password"));
                    },
                    child: Text(
                      "Forgot Password?",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  GestureDetector(
                    onTap: () {
                      Navigation.instance.navigate('/signup');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 15.sp,
                                ),
                        children: [
                          TextSpan(
                            text: "Signup",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Divider(color: Colors.white.withOpacity(0.5)),
                  SizedBox(height: 1.h),
                  if (Platform.isAndroid)
                    Text(
                      "Or continue with",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 15.sp,
                                color: Colors.white.withOpacity(0.8),
                              ),
                    ),
                  SizedBox(height: 2.h),
                  if (Platform.isAndroid)
                    SizedBox(
                      width: 60.w,
                      child: SocialLoginButton(
                        backgroundColor: Colors.white70,
                        height: 5.5.h,
                        text: 'Sign in with Google',
                        borderRadius: 8,
                        fontSize: 14.sp,
                        buttonType: SocialLoginButtonType.google,
                        onPressed: _handleGoogleSignIn,
                      ),
                    ),
                  // if (Platform.isIOS) ...[
                  //   SizedBox(height: 2.h),
                  //   SizedBox(
                  //     width: 60.w,
                  //     child: SignInWithAppleButton(
                  //       height: 5.5.h,
                  //       borderRadius:
                  //           const BorderRadius.all(Radius.circular(8)),
                  //       onPressed: signInWithApple,
                  //     ),
                  //   ),
                  // ],
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
    IconData? prefixIcon,
  }) {
    return Container(
      width: double.infinity,
      height: 6.5.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        keyboardType: keyboardType,
        cursorHeight: Theme.of(context).textTheme.headlineSmall?.fontSize,
        autofocus: false,
        controller: controller,
        cursorColor: Colors.white,
        obscureText: isObscure,
        style:
            Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16.sp),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.white70)
              : null,
          labelStyle:
              Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14.sp),
          hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey.shade400,
                fontSize: 15.sp,
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            gapPadding: 0.0,
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 5.5.h,
      child: ElevatedButton(
        onPressed: () {
          if (_emailController.text.isNotEmpty &&
              _passwordController.text.isNotEmpty &&
              _emailController.text.isValidEmail()) {
            Login();
          } else {
            Fluttertoast.showToast(
              msg: "Please enter valid credentials",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'LOGIN',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
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
      Fluttertoast.showToast(
        msg: response.message ?? "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
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
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url, mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $_url';
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final response = await signInWithGoogle();
      loginSocial(
        response.user?.displayName?.split(" ")[0] ?? "",
        (response.user?.displayName?.split(" ").length ?? 0) > 1
            ? response.user?.displayName?.split(" ")[1] ?? ""
            : "",
        response.user?.email ?? "",
        "",
        "google",
        response.user?.phoneNumber ?? "",
        "",
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Google Sign In failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void loginSocial(
    String fname,
    String lname,
    String email,
    String password,
    String provider,
    String mobile,
    String apple_id,
  ) async {
    Navigation.instance.navigate("/loadingDialog");
    final response = await ApiProvider.instance.socialLogin(
      fname,
      lname,
      email,
      password,
      provider,
      mobile,
      apple_id,
    );
    if (response.status ?? false) {
      Navigation.instance.goBack();
      await Storage.instance.setUser(response.access_token ?? "");
      fetchProfile();
    } else {
      Navigation.instance.goBack();
      Fluttertoast.showToast(
        msg: response.message ?? "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.userIdentifier?.isNotEmpty ?? false) {
        if (!mounted) return;

        // Extract name from Apple credentials
        final firstName = credential.givenName ?? "";
        final lastName = credential.familyName ?? "";
        final email = credential.email ?? "";

        // Directly use the data provided by Apple without prompting the user again
        Navigation.instance.navigate("/loadingDialog");
        try {
          loginSocial(
            firstName,
            lastName,
            email,
            "",
            "apple",
            "",
            credential.userIdentifier ?? "",
          );
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Apple Sign In failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void showTextFieldDialog(
    BuildContext context,
    String title,
    String hintText,
    String? nameText,
    String? emailText,
    String? mobileText,
    Function(String? name, String? email, String mobile) onSubmit,
  ) {
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

    if (googleUser == null) {
      throw Exception("Google sign in aborted by user");
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
