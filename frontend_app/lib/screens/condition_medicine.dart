import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine/objects/rank.dart';
import 'package:medicine/objects/review.dart';
import 'package:medicine/utils/globals.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen(this.rank, this.reviews, {Key? key}) : super(key: key);

  final Rank rank;
  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        rank.name,
        style: Globals.kHeading2Style,
      )),
      body: Padding(
        padding: Globals.kScreenPadding.copyWith(bottom: 0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: Globals.screenWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Container(
                    color: Colors.white10,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Following are the top reviews for this drug:-',
                      style: Globals.kBodyText1Style,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: reviews.map((elem) => elem.card(context)).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Modular.to.pushNamed('/add-review', arguments: rank),
        label: Icon(Icons.add),
      ),
    );
  }
}
