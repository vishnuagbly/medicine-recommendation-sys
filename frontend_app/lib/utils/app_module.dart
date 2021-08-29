import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine/components/loading_screen.dart';
import 'package:medicine/networks/reviews.dart';
import 'package:medicine/objects/rank.dart';
import 'package:medicine/objects/review.dart';
import 'package:medicine/screens/auth_state.dart';
import 'package:medicine/screens/condition_result.dart';
import 'package:medicine/screens/condition_medicine.dart';
import 'package:medicine/screens/create_review.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, __) => AuthState()),
        ChildRoute(
          '/condition_search/:text',
          child: (_, args) => ConditionSearchScreen(
            Uri.decodeComponent(args.params['text'] ?? ''),
          ),
        ),
        ChildRoute(
          '/medicine',
          child: (_, args) {
            Rank _rank = args.data;
            return LoadingScreen<List<Review>>(
              future: Reviews.get(condition: _rank.condition, drug: _rank.name),
              func: (reviews) => MedicineScreen(_rank, reviews ?? []),
            );
          },
        ),
        ChildRoute('/add-review', child: (_, args) {
          final Rank _rank = args.data;
          final _condition = _rank.condition;
          final _drug = _rank.name;
          return CreateReviewScreen(_condition, _drug);
        }),
      ];
}
