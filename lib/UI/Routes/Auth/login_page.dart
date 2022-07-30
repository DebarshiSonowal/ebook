import 'package:awesome_icons/awesome_icons.dart';
import 'package:ebook/Constants/constance_data.dart';
import 'package:ebook/Helper/navigator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
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
                        hintText: "example@gmail.com",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontSize: 1.7.h),
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
                          Navigation.instance.navigate('/main');
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
                Text(
                  "OR",
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.google,
                          color: Colors.red,
                          size: 5.h,
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(5.0),
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     shape: BoxShape.circle,
                      //   ),
                      //   child: Icon(
                      //     FontAwesomeIcons.facebook,
                      //     color: Colors.blueAccent,
                      //     size: 5.h,
                      //   ),
                      // ),
                    ],
                  ),
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
}
