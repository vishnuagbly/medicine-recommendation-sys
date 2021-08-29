import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine/utils/globals.dart';

class Rank {
  Rank.from(this.condition, Map<String, dynamic> map)
      : name = map['name'] ?? '',
        rank = map['rank'],
        score = map['score'].toDouble();

  final String name;
  final String condition;
  final int rank;
  final double score;

  static const rankColors = [
    Colors.amber,
    Colors.grey,
    Colors.brown,
    Colors.white,
  ];

  ListTile get tile => ListTile(
        onTap: () => Modular.to.pushNamed('/medicine', arguments: this),
        title: Wrap(
          children: [
            Text(
              name,
              style: Globals.kBodyText1Style.copyWith(
                color: rankColors[min(rank, rankColors.length - 1)],
              ),
            ),
            if (score < 0.5)
              Text(
                ' (not recommended)',
                style: Globals.kBodyText1Style.copyWith(
                  color: Colors.red,
                ),
              ),
          ],
        ),
      );
}
