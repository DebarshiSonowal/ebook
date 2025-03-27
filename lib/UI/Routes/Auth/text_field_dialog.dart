import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
