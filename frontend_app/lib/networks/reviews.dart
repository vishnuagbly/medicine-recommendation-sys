import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicine/networks/conditions.dart';
import 'package:medicine/networks/drugs.dart';
import 'package:medicine/objects/review.dart';

abstract class Reviews {
  static final firestore = FirebaseFirestore.instance;

  ///Need to provide at least one of the parameters.
  static Future<List<Review>> get(
      {String? condition, String? drug, int limit = 10}) async {
    assert(
        condition != null || drug != null, 'Any one value should be provided');
    late String? _condition, _drugName;
    if (condition != null) {
      _condition = (await Conditions.map)[condition.toLowerCase()];
      if (_condition == null)
        throw ArgumentError('No condition named "$condition" exists.');
    }
    if (drug != null) {
      _drugName = (await Drugs.map)[drug.toLowerCase()];
      if (_drugName == null)
        throw ArgumentError('No drug named "$drug" exists.');
    }
    print('condition: $_condition drugName: $_drugName');
    return firestore
        .collection('review')
        .where('condition', isEqualTo: _condition)
        .where('drugName', isEqualTo: _drugName)
        .orderBy('normalized_score', descending: true)
        .limit(limit)
        .get()
        .then((snapshot) =>
            snapshot.docs.map((elem) => Review.fromMap(elem.data())).toList());
  }
}
