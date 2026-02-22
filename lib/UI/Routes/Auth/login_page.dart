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
                  if (Platform.isAndroid || Platform.isIOS) ...[
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
                          if (Platform.isAndroid)
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
                          if (Platform.isIOS)
                            SizedBox(
                              width: double.infinity,
                              height: 6.h,
                              child: SignInWithAppleButton(
                                height: 6.h,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                onPressed: signInWithApple,
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
                  ],

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
    try {
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
    } catch (e) {
      Navigation.instance.goBack();
      Fluttertoast.showToast(
        msg: "Login failed: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void fetchProfile() async {
    try {
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
    } catch (e) {
      Navigation.instance.goBack();
      Fluttertoast.showToast(
        msg: "Failed to fetch profile: $e",
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
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      if (googleUser != null) {
        Navigation.instance.navigate("/loadingDialog");

        // Request authorization for the scopes to get accessToken
        const List<String> scopes = ['email', 'profile'];
        final authorization =
            await googleUser.authorizationClient.authorizeScopes(scopes);
        final googleAuth = await googleUser.authentication;

        // Create Firebase credential with both tokens
        final credential = GoogleAuthProvider.credential(
          accessToken: authorization.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          loginSocial(
            userCredential.user?.displayName?.split(" ")[0] ?? "",
            (userCredential.user?.displayName?.split(" ").length ?? 0) > 1
                ? userCredential.user?.displayName?.split(" ")[1] ?? ""
                : "",
            userCredential.user?.email ?? "",
            "",
            "google",
            userCredential.user?.phoneNumber ?? "",
            "",
          );
        } else {
          Navigation.instance.goBack();
          Fluttertoast.showToast(msg: "Failed to get user info");
        }
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        debugPrint("Google Sign-In cancelled by user");
      } else {
        debugPrint("Google Sign-In error: $e");
        Fluttertoast.showToast(msg: "Google Sign In failed: $e");
      }
    } catch (e) {
      // If we already showed the loader, pop it
      try {
        if (Navigation.instance.navigatorKey.currentState?.canPop() ?? false) {
          Navigation.instance.goBack();
        }
      } catch (_) {}

      debugPrint("Unexpected error during Google Sign-In: $e");
      Fluttertoast.showToast(msg: "Google Sign In failed. Please try again.");
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
    try {
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
    } catch (e) {
      Navigation.instance.goBack();
      Fluttertoast.showToast(
        msg: "Social login failed: $e",
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

      debugPrint("--- Apple Sign In Credential ---");
      debugPrint("userIdentifier: ${credential.userIdentifier}");
      debugPrint("givenName: ${credential.givenName}");
      debugPrint("familyName: ${credential.familyName}");
      debugPrint("email: ${credential.email}");
      debugPrint("identityToken: ${credential.identityToken}");
      debugPrint("authorizationCode: ${credential.authorizationCode}");
      debugPrint("--------------------------------");

      if (credential.userIdentifier?.isNotEmpty ?? false) {
        if (!mounted) return;

        // Use the name and email directly from Apple's credentials
        String firstName = credential.givenName ?? "";
        String lastName = credential.familyName ?? "";
        String email = credential.email ?? "";

        // Apple only provides user details on the first sign-in.
        // For subsequent sign-ins, we need fallback values to satisfy backend requirements.
        if (firstName.isEmpty) firstName = "Apple";
        if (lastName.isEmpty) lastName = "User";
        if (email.isEmpty) email = "${credential.userIdentifier}@apple.com";

        Navigation.instance.navigate("/loadingDialog");

        // Sign in directly with the data provided by Apple
        loginSocial(
          firstName,
          lastName,
          email,
          "",
          "ios",
          "",
          credential.userIdentifier ?? "",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Apple Sign In failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }
}
