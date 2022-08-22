import 'package:flutter/material.dart';

import '../../../Constants/constance_data.dart';
import 'package:sizer/sizer.dart';
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  var _phoneController=TextEditingController();

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
                  height: 2.h,
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
                  "Signup",
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                    color: Colors.white,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
