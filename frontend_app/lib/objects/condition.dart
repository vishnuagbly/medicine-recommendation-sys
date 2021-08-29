import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine/utils/colors_utils.dart';
import 'package:medicine/utils/globals.dart';

import 'rank.dart';

class Condition {
  Condition.fromMap(Map<String, dynamic> map)
      : name = map['condition'],
        ranks = List<Map<String, dynamic>>.from(map['ranks'] ?? [])
            .map((elem) => Rank.from(map['condition'], elem))
            .toList();

  final String name;
  final List<Rank> ranks;

  Widget get card => _Card(this);
}

class _Card extends StatefulWidget {
  const _Card(this._condition, {Key? key}) : super(key: key);

  final Condition _condition;

  @override
  __CardState createState() => __CardState();
}

class __CardState extends State<_Card> with TickerProviderStateMixin {
  bool opened = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => opened = !opened),
      child: AnimatedSize(
        alignment: Alignment.topCenter,
        vsync: this,
        duration: Duration(milliseconds: 400),
        child: Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: BoxConstraints(
              maxHeight: 70.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          widget._condition.name,
                          style: Globals.kHeading1Style.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.check_circle_outline,
                        color: ColorsUtils.kSecondaryColor,
                      ),
                    ],
                  ),
                ),
                if (opened) ...[
                  SizedBox(height: 10),
                  Text('Ranking', style: Globals.kHeading2Style),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: widget._condition.ranks
                          .map((elem) => elem.tile)
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
