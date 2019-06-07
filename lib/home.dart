import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'group-detail-bar.dart';
import 'group-detail.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.group}) : super(key: key);

  final String title;
  final DocumentSnapshot group;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final Queue navigationStack = new Queue();

    return Scaffold(
      body: GroupDetail(group: widget.group),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: new GroupDetailBar(
        textTheme: textTheme
			),
    );
  }
}

