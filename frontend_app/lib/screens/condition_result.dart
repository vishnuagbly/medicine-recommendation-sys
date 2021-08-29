import 'package:flutter/material.dart';
import 'package:medicine/components/common_snapshot_responses.dart';
import 'package:medicine/networks/conditions.dart';
import 'package:medicine/objects/condition.dart';
import 'package:medicine/utils/globals.dart';

class ConditionSearchScreen extends StatefulWidget {
  ConditionSearchScreen(String searchText, {Key? key})
      : _searchText = TextEditingController(text: searchText),
        super(key: key);

  final TextEditingController _searchText;

  @override
  _ConditionSearchScreenState createState() =>
      _ConditionSearchScreenState(_searchText.text);
}

class _ConditionSearchScreenState extends State<ConditionSearchScreen> {
  Future<List<String>> _condition;
  List<Widget> _conditions = [];

  _ConditionSearchScreenState(String conditionName)
      : _condition = Conditions.list(conditionName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: Globals.screenWidth),
            padding: Globals.kScreenPadding,
            child: Column(
              children: [
                Hero(
                  tag: 'condition_search',
                  child: Card(
                    child: TextField(
                      style: Globals.kBodyText1Style,
                      controller: widget._searchText,
                      decoration: InputDecoration(
                        hintText: 'Search Condition',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (text) {
                        setState(() {
                          _conditions.clear();
                          _condition = Conditions.list(text);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FutureBuilder<List<String>>(
                  future: _condition,
                  builder: (context, snapshot) =>
                      CommonAsyncSnapshotResponses<List<String>>(
                    snapshot,
                    builder: (conditions) {
                      if (_conditions.isEmpty)
                        for (int i = 0; i < conditions.length; i++) {
                          final val = conditions[i];
                          _conditions.add(Card(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: InkWell(
                              onTap: () {
                                final _card = FutureBuilder<Condition?>(
                                  future: Conditions.get(val),
                                  builder: (_, snapshot) =>
                                      CommonAsyncSnapshotResponses<Condition?>(
                                    snapshot,
                                    builder: (condition) => condition!.card,
                                    onLoading: Card(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                    ),
                                  ),
                                );
                                setState(() {
                                  _conditions[i] = _card;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Center(
                                    child: Text(val,
                                        style: Globals.kHeading1Style)),
                              ),
                            ),
                          ));
                        }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _conditions,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
