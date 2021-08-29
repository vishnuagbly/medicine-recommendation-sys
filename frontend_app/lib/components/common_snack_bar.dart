import 'package:flutter/material.dart';
import 'package:medicine/utils/colors_utils.dart';
import 'package:medicine/utils/globals.dart';

SnackBar commonSnackBar(String text) => SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.w)),
      ),
      padding: const EdgeInsets.all(20),
      backgroundColor: ColorsUtils.kSecondaryColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: Globals.kBodyText1Style),
        ],
      ),
    );
