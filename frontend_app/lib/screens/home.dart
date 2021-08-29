import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:medicine/utils/colors_utils.dart';
import 'package:medicine/utils/globals.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen._(this.gravatar, this.imageUrl, Key? key) : super(key: key);

  factory HomeScreen({Key? key}) {
    final _gravatar = Gravatar(FirebaseAuth.instance.currentUser?.email ?? '');
    final _imageUrl = _gravatar.imageUrl(size: 100, defaultImage: 'robohash');

    return HomeScreen._(_gravatar, _imageUrl, key);
  }

  final Gravatar gravatar;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: Globals.kHeading2Style,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              backgroundColor: ColorsUtils.kElevationColor,
              foregroundImage: NetworkImage(imageUrl),
              radius: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: Globals.kScreenPadding,
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: Globals.screenWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'condition_search',
                  child: Card(
                    child: TextField(
                      style: Globals.kBodyText1Style,
                      decoration: InputDecoration(
                        hintText: 'Search Condition',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (text) =>
                          Modular.to.pushNamed('/condition_search/$text'),
                    ),
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
