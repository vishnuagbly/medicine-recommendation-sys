import 'package:flutter/material.dart';
import 'package:medicine/components/common_snack_bar.dart';

class Review {
  final int usefulCount;
  final String uid, drugName, condition, review;
  final String? author, updateFrom;
  final double sentimentScore;
  final DateTime date;

  Review.fromMap(Map<String, dynamic> map)
      : this.usefulCount = map['usefulCount'],
        this.uid = map['uniqueID'].toString(),
        this.drugName = map['drugName'],
        this.condition = map['condition'],
        this.review = preProcessReview(map['review']),
        this.author = map['author'],
        this.updateFrom = map['updateFrom'],
        this.sentimentScore = map['sentiment_score'].toDouble(),
        this.date = map['date'].toDate();

  static String preProcessReview(String review) {
    return review.replaceAll('"', '').replaceAll('&#039;', "'");
  }

  static const votes = {
    1000: 'K',
    1000000: 'M',
    1000000000: 'B',
  };

  String get upvotes {
    final keys = votes.keys.toList();
    for (int i = votes.length; i-- > 0;) {
      if (usefulCount > keys[i])
        return (usefulCount ~/ keys[i]).toString() + '${votes[i]}';
    }
    return usefulCount.toString();
  }

  static void _showSnackBar(BuildContext context) {
    final snackBar = commonSnackBar('Your Response has been recorded.');
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget card(BuildContext context) {
    int? maxLines = 4;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        color: sentimentScore > 0.5
            ? Colors.green.withAlpha(70)
            : Colors.red.withAlpha(60),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(
                children: [
                  IconButton(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    icon: Icon(Icons.arrow_upward_rounded),
                    onPressed: () => _showSnackBar(context),
                  ),
                  Text(upvotes),
                  IconButton(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    icon: Icon(Icons.arrow_downward_rounded),
                    onPressed: () => _showSnackBar(context),
                  ),
                ],
              ),
              VerticalDivider(),
              Expanded(
                child: StatefulBuilder(
                  builder: (_, setState) {
                    return InkWell(
                      onTap: () => setState(() {
                        if (maxLines == null)
                          maxLines = 4;
                        else
                          maxLines = null;
                      }),
                      child: Text(review, maxLines: maxLines),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
