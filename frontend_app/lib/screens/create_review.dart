import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine/components/common_snack_bar.dart';
import 'package:medicine/components/row_info.dart';
import 'package:medicine/utils/globals.dart';

class CreateReviewScreen extends StatelessWidget {
  CreateReviewScreen(this.condition, this.drug, {Key? key}) : super(key: key);

  final String condition, drug;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Review')),
      body: Padding(
        padding: Globals.kScreenPadding,
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: Globals.screenWidth),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add a review for the:-',
                          style: Globals.kBodyText1Style,
                        ),
                        SizedBox(height: 10),
                        RowInfo('Condition:', condition, size: 4.w),
                        RowInfo('Drug:', drug, size: 4.w),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        style: Globals.kBodyText1Style,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Write Your Review',
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty)
                            return 'This Field is important';
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (!(_formKey.currentState?.validate() ?? false)) return;
          Modular.to.pop();
          final snackBar = commonSnackBar('Your Review has been recorded.');
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        label: Text('Submit'),
      ),
    );
  }
}
