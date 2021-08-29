import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicine/objects/condition.dart';
import 'package:http/http.dart' as http;

abstract class Conditions {
  static final firestore = FirebaseFirestore.instance;
  static const apiLink = "http://20.204.149.133/api";

  static final Future<Map<String, String>> map = FirebaseFirestore.instance
      .doc('meta_data/conditions_map')
      .get()
      .then((value) => Map<String, String>.from(value.data() ?? {}))
      .catchError((error) => throw error);

  static Future<List<String>> list(String condition) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.post(
      Uri.parse(apiLink + '/search'),
      headers: {
        'token': token ?? '',
      },
      body: jsonEncode(<String, dynamic>{
        'values': [condition],
      }),
    );

    print(response.body);

    final body = jsonDecode(response.body);

    if (response.statusCode != 200) throw body['error'];

    final conditions = <String>[];

    for (var value in body['data'][condition]) conditions.add(value.first);

    return conditions;
  }

  static Future<Condition?> get(String condition) async {
    final _condition = (await map)[condition.toLowerCase()];
    if (_condition == null) return null;
    return firestore
        .collection('ranking')
        .where('condition', isEqualTo: _condition)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty)
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'Got no condition with provided name',
        );
      final _map = snapshot.docs.first.data();
      return Condition.fromMap(_map);
    });
  }
}
