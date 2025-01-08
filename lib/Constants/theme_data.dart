import 'package:ebook/Constants/constance_data.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
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
      primaryColor: primaryColor,
      // buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: secondaryColor,
      splashFactory: InkRipple.splashFactory,
      // accentColor: secondaryColor,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.black,
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      // cursorColor: primaryColor,
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      // accentTextTheme: _buildTextTheme(base.accentTextTheme),
      platform: TargetPlatform.iOS,
      colorScheme: colorScheme.copyWith(background: Colors.grey[850]),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      titleLarge: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.titleLarge?.color,
        fontSize: 7.sp,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.headlineSmall?.color,
        fontSize: 10.sp,
      ),
      headlineMedium: TextStyle(
          fontFamily: ConstanceData.fontFamily,
          color: base.headlineMedium?.color,
          fontSize: 11.sp),
      displaySmall: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.displaySmall?.color,
        fontSize: 12.sp,
      ),
      displayMedium: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.displayMedium?.color,
        fontSize: 13.sp,
      ),
      displayLarge: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.displayLarge?.color,
        fontSize: 14.sp,
      ),
      titleMedium: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.titleMedium?.color,
        fontSize: 20.sp,
      ),
      titleSmall: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.titleSmall?.color,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.bodyMedium?.color,
        fontSize: 15.sp,
      ),
      bodyLarge: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.bodyLarge?.color,
        fontSize: 12.sp,
      ),
      labelLarge: TextStyle(
          fontFamily: ConstanceData.fontFamily,
          color: base.labelLarge?.color,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600),
      bodySmall: TextStyle(
          fontFamily: ConstanceData.fontFamily,
          color: base.bodySmall?.color,
          fontSize: 10.sp),
      labelSmall: TextStyle(
        fontFamily: ConstanceData.fontFamily,
        color: base.labelSmall?.color,
        fontSize: 6.h,
      ),
    );
  }
}
