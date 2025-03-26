import 'dart:io';

import 'package:awesome_icons/awesome_icons.dart';
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

class LoginPageReturn extends StatefulWidget {
  const LoginPageReturn({Key? key}) : super(key: key);

  @override
  State<LoginPageReturn> createState() => _LoginPageReturnState();
}

class _LoginPageReturnState extends State<LoginPageReturn> {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigation.instance.goBack(),
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
                SizedBox(height: 3.h),
                Image.asset(
                  ConstanceData.primaryIcon,
                  fit: BoxFit.fill,
                  height: 20.h,
                  width: 34.w,
                ),
                SizedBox(height: 6.h),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                ),
                SizedBox(height: 4.h),
                _buildEmailTextField(),
                SizedBox(height: 1.5.h),
                _buildPasswordTextField(),
                SizedBox(height: 3.h),
                _buildLoginButton(),
                SizedBox(height: 2.h),
                _buildForgotPasswordButton(),
                SizedBox(height: 2.h),
                _buildSocialLoginButtons(),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return SizedBox(
      width: double.infinity,
      height: 6.5.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          cursorColor: Colors.white,
          style:
              Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14.sp),
          decoration: InputDecoration(
            labelText: 'Enter your email',
            hintText: "Email Address",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.white, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.white, width: 1.5),
            ),
            labelStyle: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 14.sp),
            hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey.shade400,
                  fontSize: 13.sp,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return SizedBox(
      width: double.infinity,
      height: 6.5.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: TextField(
          controller: _passwordController,
          obscureText: true,
          cursorColor: Colors.white,
          style:
              Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14.sp),
          decoration: InputDecoration(
            labelText: 'Enter your password',
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.white, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.white, width: 1.5),
            ),
            labelStyle: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 14.sp),
            hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey.shade400,
                  fontSize: 13.sp,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 5.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: ElevatedButton(
          onPressed: () {
            if (_emailController.text.isNotEmpty &&
                _passwordController.text.isNotEmpty &&
                _emailController.text.isValidEmail()) {
              Login();
            } else {
              Fluttertoast.showToast(msg: "Please enter valid credentials");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Login',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 18.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return GestureDetector(
      onTap: () =>
          _launchUrl(Uri.parse("https://tratri.in/app-forget-password")),
      child: Text(
        "Forgot Password",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 13.sp,
            ),
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        if (Platform.isAndroid)
          SizedBox(
            width: 60.w,
            child: SocialLoginButton(
              backgroundColor: Colors.white70,
              height: 40,
              text: 'Sign in',
              borderRadius: 5,
              fontSize: 15.sp,
              buttonType: SocialLoginButtonType.google,
              onPressed: _handleGoogleSignIn,
            ),
          ),
        if (Platform.isIOS) ...[
          SizedBox(height: 1.h),
          SizedBox(
            width: 60.w,
            child: SocialLoginButton(
              backgroundColor: Colors.white70,
              height: 40,
              text: 'Sign in',
              borderRadius: 5,
              fontSize: 15.sp,
              buttonType: SocialLoginButtonType.apple,
              onPressed: signInWithApple,
            ),
          ),
        ],
      ],
    );
  }

  void Login() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.socialLogin(
      "",
      "",
      _emailController.text,
      _passwordController.text,
      "normal",
      "",
      "",
    );
    if (response.status ?? false) {
      await Storage.instance.setUser(response.access_token ?? "");
      fetchProfile();
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: response.message ?? "Something went wrong");
    }
  }

  void fetchProfile() async {
    final response = await ApiProvider.instance.getProfile();
    if (response.status ?? false) {
      Provider.of<DataProvider>(
        Navigation.instance.navigatorKey.currentContext ?? context,
        listen: false,
      ).setProfile(response.profile!);
      Navigation.instance.goBack();
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final response = await signInWithGoogle();
    loginSocial(
      response.user?.displayName?.split(" ")[0] ?? "",
      response.user?.displayName?.split(" ").length == null
          ? ""
          : response.user!.displayName!.split(" ").length > 1
              ? response.user!.displayName!.split(" ")[1]
              : "",
      response.user?.email ?? "",
      "",
      "google",
      response.user?.phoneNumber ?? "",
      "",
    );
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
      Fluttertoast.showToast(msg: response.message ?? "Something went wrong");
    }
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $_url';
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

      // Check if we received a valid user identifier
      if (credential.userIdentifier?.isNotEmpty ?? false) {
        if (!mounted) return;

        // Format the name correctly from Apple credentials
        final fullName = _formatAppleFullName(credential);

        // Show dialog to collect additional user information
        showTextFieldDialog(
          context,
          "Complete Your Profile",
          "Please verify your information to continue",
          fullName,
          credential.email,
          "",
          (String? name, String? email, String mobile) {
            if (_isValidMobile(mobile)) {
              // Process the social login
              _processSocialLogin(
                  name, email, mobile, credential.userIdentifier);
            } else {
              Navigation.instance.goBack();
              Fluttertoast.showToast(
                msg: "Please enter a valid 10-digit mobile number",
                toastLength: Toast.LENGTH_SHORT,
              );
            }
          },
        );
      } else {
        Fluttertoast.showToast(
          msg: "Sign in failed. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Sign in with Apple failed: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  // Helper method to format Apple name credentials
  String _formatAppleFullName(AuthorizationCredentialAppleID credential) {
    if (credential.givenName == null) return "";

    return credential.familyName == null
        ? credential.givenName!
        : "${credential.givenName} ${credential.familyName}";
  }

  // Validate mobile number
  bool _isValidMobile(String mobile) {
    return mobile.isNotEmpty &&
        mobile.length == 10 &&
        int.tryParse(mobile) != null;
  }

  // Process the social login with user information
  void _processSocialLogin(
      String? name, String? email, String mobile, String? appleId) {
    final firstName = name?.split(" ")[0] ?? "";
    final lastName =
        (name?.split(" ").length ?? 0) > 1 ? name!.split(" ")[1] : "";

    loginSocial(
      firstName,
      lastName,
      email ?? "",
      "",
      "ios",
      mobile,
      appleId ?? "",
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

Future<void> showTextFieldDialog(
  BuildContext context,
  String title,
  String description,
  String? name,
  String? email,
  String? mobile,
  Function(String?, String?, String) onSubmit,
) async {
  final nameController = TextEditingController(text: name);
  final emailController = TextEditingController(text: email);
  final mobileController = TextEditingController(text: mobile);

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
        ),
        elevation: 8,
        title: Column(
          children: [
            Icon(
              Icons.person_outline_rounded,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14.sp,
                      ),
                ),
                SizedBox(height: 2.5.h),
                _buildTextField(
                  context,
                  nameController,
                  'Name',
                  Icons.person,
                ),
                SizedBox(height: 2.h),
                _buildTextField(
                  context,
                  emailController,
                  'Email',
                  Icons.email,
                ),
                SizedBox(height: 2.h),
                _buildTextField(
                  context,
                  mobileController,
                  'Mobile',
                  Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigation.instance.goBack(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onSubmit(
                      nameController.text,
                      emailController.text,
                      mobileController.text,
                    );
                    Navigation.instance.goBack();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

      // Helper function for consistent text field styling
    },
  );
}

Widget _buildTextField(
  BuildContext context,
  TextEditingController controller,
  String label,
  IconData icon, {
  TextInputType keyboardType = TextInputType.text,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      controller: controller,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 15.sp,
            color: Colors.white,
          ),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14.sp,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    ),
  );
}
