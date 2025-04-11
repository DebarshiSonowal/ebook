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

class _TextFieldDialogState extends State<TextFieldDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  bool showEmail = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _name.text = widget.nameText ?? "";
    _email.text = widget.emailText ?? "";
    _mobile.text = widget.mobileText ?? "";

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    _animationController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    IconData? prefixIcon,
    bool hasCounter = false,
  }) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;

    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide:
            BorderSide(color: primaryColor.withOpacity(0.6), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: accentColor, width: 2.0),
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: Color(0xFF7E7E7E),
        fontWeight: FontWeight.w500,
      ),
      fillColor: Colors.white.withOpacity(0.97),
      filled: true,
      counterText: hasCounter ? null : "",
      prefixIcon: prefixIcon != null
          ? Container(
              margin: EdgeInsets.only(left: 2.w, right: 1.w),
              child: Icon(prefixIcon, color: primaryColor, size: 18.sp))
          : null,
      prefixIconConstraints: BoxConstraints(minWidth: 8.w, minHeight: 5.h),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color textLightColor = Colors.white.withOpacity(0.95);
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final Color backgroundColor = Color(0xFF2A2D3E);

    return ScaleTransition(
      scale: _animation,
      child: AlertDialog(
        backgroundColor: backgroundColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: primaryColor.withOpacity(0.6), width: 1.5),
        ),
        titlePadding:
            EdgeInsets.only(left: 6.w, right: 6.w, top: 3.h, bottom: 1.h),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            color: textLightColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        content: Container(
          width: 85.w,
          constraints: BoxConstraints(maxWidth: 85.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.hintText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: textLightColor.withOpacity(0.8),
                  height: 1.3,
                ),
              ),
              SizedBox(height: 3.h),
              TextField(
                controller: _name,
                decoration: _buildInputDecoration(
                  labelText: "Please enter your name (optional)",
                  prefixIcon: Icons.person_outline,
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                decoration: BoxDecoration(
                  color: Color(0xFF363B4D),
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: showEmail
                            ? Colors.white
                            : Colors.white.withOpacity(0.7),
                        fontWeight:
                            showEmail ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: 4.h,
                      width: 12.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: showEmail
                            ? accentColor.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            left: showEmail ? 6.w : 0,
                            right: showEmail ? 0 : 6.w,
                            top: 0.3.h,
                            bottom: 0.3.h,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showEmail = !showEmail;
                                  if (showEmail) {
                                    _mobile.clear();
                                  } else {
                                    _email.clear();
                                  }
                                });
                              },
                              child: Container(
                                width: 6.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: showEmail ? accentColor : primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Mobile",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: !showEmail
                            ? Colors.white
                            : Colors.white.withOpacity(0.7),
                        fontWeight:
                            !showEmail ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.5.h),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: child,
                    ),
                  );
                },
                child: showEmail
                    ? TextField(
                        key: ValueKey("email"),
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(
                          labelText: "Please enter your email",
                          prefixIcon: Icons.email_outlined,
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : TextField(
                        key: ValueKey("mobile"),
                        controller: _mobile,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: _buildInputDecoration(
                          labelText: "Please enter your mobile number",
                          prefixIcon: Icons.phone_android,
                          hasCounter: true,
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    backgroundColor: Colors.grey.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSubmit(_name.text, _email.text, _mobile.text);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    backgroundColor: primaryColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
