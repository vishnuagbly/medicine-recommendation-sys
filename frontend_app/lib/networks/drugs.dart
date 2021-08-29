import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Drugs {
  static final firestore = FirebaseFirestore.instance;

  static final Future<Map<String, String>> map = firestore
      .doc('meta_data/drugName_map')
      .get()
      .then((snapshot) => Map<String, String>.from(snapshot.data() ?? {}));
}
