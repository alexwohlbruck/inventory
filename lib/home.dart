import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'group-detail-bar.dart';
import 'group-detail.dart';
import 'navigation-model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ScopedModel<NavigationModel>(
      model: NavigationModel(),
      child: new Group(textTheme: textTheme),
    );
  }
}

class Group extends StatelessWidget {
  const Group({
    Key key,
    @required this.textTheme,
  }) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NavigationModel>(
      builder: (context, child, model) {
        return WillPopScope(
          onWillPop: () {
            model.regressHistory();
          },
          child: Scaffold(
            body: GroupDetail(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: new GroupDetailBar(
              textTheme: textTheme
            ),
          ),
        );
      },
    );
  }
}
