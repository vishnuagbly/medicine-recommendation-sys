import 'dart:math';
import 'dart:ui' show window;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicine/utils/colors_utils.dart';

extension AsyncGlobal<T> on AsyncValue {
  Widget globalWhen({required Widget Function(T? data) data}) {
    return when<Widget>(
      data: (_) => data(_),
      loading: () => Center(
        child: CircularProgressIndicator(
          color: ColorsUtils.kPrimaryColor,
        ),
      ),
      error: (err, __) {
        String text = "SOME ERR OCCURRED";
        if (err is String)
          text = err;
        else if (err is Exception) text = err.toString();
        return Center(
          child: Text(
            text,
            style: GoogleFonts.montserrat(fontSize: 4.w),
          ),
        );
      },
    );
  }
}

extension GlobalValue on num {
  double get w => (Globals.screenWidth * this) / 100;

  double get h => (Globals.rawScreenHeight * this) / 100;
}

abstract class Globals {
  static double get rawScreenHeight =>
      window.physicalSize.height / window.devicePixelRatio;

  static double get rawScreenWidth =>
      window.physicalSize.width / window.devicePixelRatio;

  static double get screenWidth => min(rawScreenWidth, 500);

  static double get platformWidth => kIsWeb ? screenWidth : rawScreenWidth;

  //Constants from here
  static final ButtonStyle kElevatedButtonStyle = ElevatedButton.styleFrom(
    primary: ColorsUtils.kPrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: kBorderRadius,
    ),
    textStyle: GoogleFonts.montserrat(
      fontSize: 4.w,
    ),
  );

  static final kBorderRadius = BorderRadius.circular(3.5.w);

  static final kBodyText1Style = GoogleFonts.montserrat(fontSize: 4.5.w);
  static final kBodyText2Style = GoogleFonts.montserrat(fontSize: 3.w);
  static final kHeading2Style = GoogleFonts.montserrat(fontSize: 5.w);
  static final kHeading1Style = GoogleFonts.montserrat(fontSize: 6.w);

  static final kInputDecorationTheme = InputDecorationTheme(
    fillColor: ColorsUtils.kBackgroundColor,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
    ),
    hintStyle: kBodyText1Style,
  );

  static const kScreenPadding = const EdgeInsets.all(20);
}
