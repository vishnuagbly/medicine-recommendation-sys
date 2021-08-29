import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RowInfo extends StatelessWidget {
  RowInfo(
    this.firstText,
    this.secondText, {
    this.firstStyle,
    this.secondStyle,
    this.firstColor,
    this.secondColor,
    double? size,
  })  : firstWidget = null,
        secondWidget = null,
        firstSize = size,
        secondSize = size;

  RowInfo.raw({
    this.firstWidget,
    this.secondWidget,
    this.firstText,
    this.secondText,
    this.firstStyle,
    this.secondStyle,
    this.firstColor,
    this.secondColor,
    this.firstSize,
    this.secondSize,
  });

  final Widget? firstWidget, secondWidget;
  final String? firstText, secondText;
  final TextStyle? firstStyle, secondStyle;
  final Color? firstColor, secondColor;
  final double? firstSize, secondSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        firstWidget ??
            Text(
              firstText ?? "",
              style: firstStyle ??
                  GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400,
                    fontSize: firstSize,
                    color:
                        firstColor ?? DefaultTextStyle.of(context).style.color,
                  ),
            ),
        secondWidget ??
            Text(
              secondText ?? "",
              style: secondStyle ??
                  GoogleFonts.montserrat(
                    fontWeight: FontWeight.w300,
                    fontSize: secondSize,
                    color:
                        secondColor ?? DefaultTextStyle.of(context).style.color,
                  ),
            ),
      ],
    );
  }
}
