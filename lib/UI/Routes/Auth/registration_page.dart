// import 'package:cool_alert/cool_alert.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:ebook/Networking/api_provider.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:intl/intl.dart';

import '../../../Constants/constance_data.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/navigator.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _phoneController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var current = "";

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // var outputFormat = DateFormat('dd/MM/yyyy');
    // var outputDate = outputFormat.format(DateTime.now());
    // current =
    // '${outputDate.toString().split('/')[0]}-${outputDate.toString().split(
    //     '/')[1]}-${outputDate.toString().split('/')[2]}';
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
                // SizedBox(
                //   height: 2.h,
                // ),
                // Image.asset(
                //   ConstanceData.primaryIcon,
                //   fit: BoxFit.fill,
                //   height: 20.h,
                //   width: 34.w,
                // ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Signup",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),

                SizedBox(
                  height: 5.h,
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
                      controller: _fnameController,
                      cursorColor: Colors.white,
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        labelText: 'Enter your first name',
                        hintText: "Firstname",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 10.sp),
                        hintStyle:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                  height: 1.h,
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
                      controller: _lnameController,
                      cursorColor: Colors.white,
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        labelText: 'Enter your Last name',
                        hintText: "Lastname",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 10.sp),
                        hintStyle:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                  height: 1.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 6.5.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      cursorHeight:
                          Theme.of(context).textTheme.headlineSmall?.fontSize,
                      autofocus: false,
                      controller: _phoneController,
                      cursorColor: Colors.white,
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        labelText: 'Enter your phone number',
                        hintText: "Mobile Number",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 10.sp),
                        hintStyle:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                  height: 1.h,
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
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        labelText: 'Enter your Email',
                        hintText: "qwerty@gmail.com",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 10.sp),
                        hintStyle:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                  height: 1.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 6.5.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      keyboardType: TextInputType.visiblePassword,
                      cursorHeight:
                          Theme.of(context).textTheme.headlineSmall?.fontSize,
                      autofocus: false,
                      controller: _passwordController,
                      cursorColor: Colors.white,
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        labelText: 'Enter your password',
                        hintText: "Password",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 10.sp),
                        hintStyle:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                  height: 1.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 6.5.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      keyboardType: TextInputType.visiblePassword,
                      cursorHeight:
                          Theme.of(context).textTheme.headlineSmall?.fontSize,
                      autofocus: false,
                      controller: _confirmPasswordController,
                      cursorColor: Colors.white,
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        labelText: 'Confirm your password',
                        hintText: "Password",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 10.sp),
                        hintStyle:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                  height: 1.h,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  width: double.infinity,
                  height: 6.5.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.,
                    children: [
                      Text(
                        'DOB:',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      SizedBox(
                        width: 40.w,
                        // height: 4.h,
                        child: Center(
                          child: DateTimePicker(
                            // dateLabelText:
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.white),
                            // calendarTitle: 'Select a date',
                            // dateHintText: 'Write a date',
                            // fieldLabelText: 'My',
                            // fieldHintText: 'Heelo',
                            type: DateTimePickerType.date,
                            initialValue: '',
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            // dateLabelText: 'Date',
                            onChanged: (val) {
                              setState(() {
                                current = val;
                              });
                            },
                            validator: (val) {
                              print(val);

                              return null;
                            },
                            onSaved: (val) => print(val),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 6.5.h,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_phoneController.text.isNotEmpty &&
                              _phoneController.text.length > 7 &&
                              _passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty &&
                              _fnameController.text.isNotEmpty &&
                              _lnameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _emailController.text.isValidEmail() &&
                              current != '') {
                            if (_passwordController.text ==
                                _confirmPasswordController.text) {
                              CreateAccount(
                                  _fnameController.text,
                                  _lnameController.text,
                                  _emailController.text,
                                  _phoneController.text,
                                  current,
                                  _passwordController.text);
                            } else {
                              // CoolAlert.show(
                              //   context: context,
                              //   type: CoolAlertType.warning,
                              //   text: "Confirm Password field is wrong",
                              // );
                            }
                          } else {
                            // CoolAlert.show(
                            //   context: context,
                            //   type: CoolAlertType.warning,
                            //   text: "Enter proper credentials",
                            // );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Text(
                          'Sign up',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
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
                  onTap: () {
                    Navigation.instance.navigate('/login');
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void CreateAccount(fname, lname, email, mobile, dob, password) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance
        .addSubscriber(fname, lname, email, mobile, dob, password);
    if (response.status ?? false) {
      Navigation.instance.goBack();
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.error,
      //   text: "Account Created Successfully",
      // );
      Navigation.instance.navigate('/login');
    } else {
      Navigation.instance.goBack();
      // CoolAlert.show(
      //   context: context,
      //   type: CoolAlertType.error,
      //   text: response.message ?? "Something Went Wrong",
      // );
    }
  }
}
