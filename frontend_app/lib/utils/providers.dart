import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine/networks/conditions.dart';

final conditionMap = FutureProvider<Map<String, String>>((ref) async {
  return Conditions.map;
});
