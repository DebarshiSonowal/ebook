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
        backgroundColor: Colors.transparent,
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
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
                Colors.black.withOpacity(0.9),
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      ConstanceData.primaryIcon,
                      fit: BoxFit.contain,
                      height: 15.h,
                      width: 30.w,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "Welcome Back",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "Sign in to continue",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14.sp,
                        ),
                  ),
                  SizedBox(height: 3.h),

                  // Social Login Section
                  // if (Platform.isAndroid) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Quick Sign In",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: double.infinity,
                            height: 6.h,
                            child: SocialLoginButton(
                              backgroundColor: Colors.white,
                              height: 6.h,
                              text: 'Continue with Google',
                              borderRadius: 12,
                              fontSize: 16.sp,
                              buttonType: SocialLoginButtonType.google,
                              onPressed: _handleGoogleSignIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Divider with text
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Text(
                            "OR",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                  // ],

                  // Regular Login Form
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign in with Email",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 3.h),
                        _buildTextField(
                          context: context,
                          controller: _emailController,
                          hintText: "Email Address",
                          labelText: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                        ),
                        SizedBox(height: 2.5.h),
                        _buildTextField(
                          context: context,
                          controller: _passwordController,
                          hintText: "Password",
                          labelText: "Enter your password",
                          isObscure: true,
                          prefixIcon: Icons.lock_outline,
                        ),
                        SizedBox(height: 3.h),
                        _buildLoginButton(context),
                        SizedBox(height: 2.h),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _launchUrl(Uri.parse(
                                  "https://tratri.in/app-forget-password"));
                            },
                            child: Text(
                              "Forgot Password?",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigation.instance.navigate('/signup');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 15.sp,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
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
      height: 7.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
      ),
      child: TextField(
        keyboardType: keyboardType,
        cursorHeight: Theme.of(context).textTheme.headlineSmall?.fontSize,
        autofocus: false,
        controller: controller,
        cursorColor: Colors.white,
        obscureText: isObscure,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 16.sp,
              color: Colors.white,
            ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.white.withOpacity(0.8))
              : null,
          labelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.8),
              ),
          hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white.withOpacity(0.6),
                fontSize: 15.sp,
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            gapPadding: 0.0,
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
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
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'SIGN IN',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 17.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
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

      // Check if sign-in was successful
      if (response.user != null) {
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
      }
    } on GoogleSignInException catch (e) {
      // Handle Google Sign-In specific exceptions
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // User cancelled - don't show error, just silently return
        debugPrint("Google Sign-In cancelled by user");
        return;
      } else {
        debugPrint("Google Sign-In error: ${e}");
        Fluttertoast.showToast(
          msg: "Google Sign In failed: ${e}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      debugPrint("Unexpected error during Google Sign-In: $e");
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

  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;

      // Define scopes you need (required for getting accessToken in v7)
      const List<String> scopes = [
        'email',
        'profile',
      ];

      // Check if the platform supports authenticate method
      if (googleSignIn.supportsAuthenticate()) {
        // Trigger the authentication flow
        final GoogleSignInAccount googleUser =
        await googleSignIn.authenticate();

        // Request authorization for the scopes to get accessToken
        final authorization =
        await googleUser.authorizationClient.authorizeScopes(scopes);

        // Get the idToken from authentication
        final googleAuth = googleUser.authentication;

        // Create Firebase credential with both tokens
        final credential = GoogleAuthProvider.credential(
          accessToken: authorization.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        // For web, you need to use platform-specific approach
        throw Exception(
            'Platform does not support authenticate(). Use Google button renderer for web.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
