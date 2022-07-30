import 'package:ebook/Constants/constance_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AppTheme {
  static ThemeData getTheme() {
    Color primaryColor = ConstanceData.primaryColor;
    Color secondaryColor = ConstanceData.secondaryColor;
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: secondaryColor,
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      backgroundColor: Colors.grey[850],
      scaffoldBackgroundColor: Colors.black,
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      cursorColor: primaryColor,
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS,
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline6: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.headline6?.color,
        fontSize: 1.h,
        fontWeight: FontWeight.w500,
      ),
      subtitle1: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.subtitle1?.color,
        fontSize: 12.h,
      ),
      subtitle2: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.subtitle2?.color,
        fontSize: 12.h,
        fontWeight: FontWeight.w500,
      ),
      bodyText2: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.bodyText2?.color,
        fontSize: 1.7.h,
      ),
      bodyText1: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.bodyText1?.color,
        fontSize: 2.h,
      ),
      button: TextStyle(
          fontFamily: ConstanceData.fontFamily,
          color: base.button?.color,
          fontSize: 10.h,
          fontWeight: FontWeight.w600),
      caption: TextStyle(
          fontFamily: ConstanceData.fontFamily,
          color: base.caption?.color,
          fontSize: 8.h),
      headline4: TextStyle(
          fontFamily: ConstanceData.fontFamily,
          color: base.headline4?.color,
          fontSize: 3.5.h),
      headline3: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.headline3?.color,
        fontSize: 6.h,
      ),
      headline2: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.headline2?.color,
        fontSize: 8.h,
      ),
      headline1: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.headline1?.color,
        fontSize: 10.h,
      ),
      headline5: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.headline5?.color,
        fontSize: 2.h,
      ),
      overline: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.overline?.color,
        fontSize: 6.h,
      ),
    );
  }
}
