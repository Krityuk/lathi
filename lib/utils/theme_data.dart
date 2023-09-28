import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'constants.dart';

ThemeData themeData = ThemeData(
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kScaffoldColor,
  // useMaterial3: true,
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
  // applyElevationOverlayColor: true,

  appBarTheme: AppBarTheme(
    toolbarHeight: 7.h,
    backgroundColor: k1,
    elevation: 0,
    iconTheme: IconThemeData(
      color: kSecondaryColor,
      size: 20.sp,
    ),
    titleTextStyle: GoogleFonts.mulish(
      color: k2,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.normal,
      fontSize: 16.sp,
    ),
  ),
  textTheme: TextTheme(
    displaySmall: TextStyle(
      fontSize: 28.sp,
      color: kSecondaryColor,
      fontWeight: FontWeight.w500,
    ),
    headlineMedium: TextStyle(
      fontSize: 24.sp,
      color: kTextColor,
      fontWeight: FontWeight.w800,
    ),
    titleSmall: GoogleFonts.poppins(fontSize: 12.sp, color: kTextColor),
    bodySmall: GoogleFonts.poppins(
      fontSize: 9.sp,
      fontWeight: FontWeight.w400,
      color: kPrimaryColor,
    ),
    labelMedium: TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w500,
      color: kTextColor,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: kTextLightColor,
        width: 0.7,
      ),
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: kTextLightColor),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: kPrimaryColor),
    ),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: kScaffoldColor,
    hourMinuteColor: kTextColor,
    hourMinuteTextColor: kScaffoldColor,
    dayPeriodColor: kTextColor,
    dayPeriodTextColor: kScaffoldColor,
    dialBackgroundColor: kTextColor,
    dialHandColor: kPrimaryColor,
    dialTextColor: kScaffoldColor,
    entryModeIconColor: kOtherColor,
    dayPeriodTextStyle: GoogleFonts.aBeeZee(
      fontSize: 8.sp,
    ),
  ),
);
