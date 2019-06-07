
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'tile.dart';

class GroupDetail extends StatefulWidget {
  DocumentSnapshot group;

  GroupDetail({
    @required this.group,
  });

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  @override
  Widget build(BuildContext context) {
    const gridPadding = 4.0;

    return Column(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
					stream: widget.group != null
						? Firestore.instance
							.collection('groups')
							.where('group', isEqualTo: widget.group.reference)
							.snapshots()
						: Firestore.instance
							.collection('groups')
							.where('group', isNull: true)
							.snapshots(),
					builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
						if (snapshot.hasError) {
							return Text('Error: ${snapshot.error}');
						}
						if (snapshot.connectionState == ConnectionState.waiting) {
							return Center(child: CircularProgressIndicator());
						}
						else {
							if (snapshot.hasData && snapshot.data.documents.length == 0) {
								// No data, return nothing
								return Container();
							}
							return GridView.count(
								crossAxisCount: 2,
								childAspectRatio: 1.5,
								shrinkWrap: true,
								primary: false,
								children: snapshot.data.documents.map((DocumentSnapshot document) {
									return Container(
										padding: const EdgeInsets.all(gridPadding),
										child: Tile(
											item: document,
											type: "group",),
									);
								}).toList()
							);
						}
					}
				),
        StreamBuilder<QuerySnapshot>(
					stream: widget.group != null
						? Firestore.instance
							.collection('items')
							.where('group', isEqualTo: widget.group)
							.snapshots()
						: Firestore.instance
							.collection('items')
							.where('group', isNull: true)
							.snapshots(),

					builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
						if (snapshot.hasError) {
							return Text('Error: ${snapshot.error}');
						}
						if (snapshot.connectionState == ConnectionState.waiting) {
							return Center(child: CircularProgressIndicator());
						}
						if (snapshot.connectionState != ConnectionState.waiting && snapshot.hasData) {
							return GridView.count(
								crossAxisCount: 3,
								shrinkWrap: true,
								primary: false,
								children: snapshot.data.documents.map((DocumentSnapshot document) {
									return Padding(
										padding: const EdgeInsets.all(gridPadding),
										child: Tile(
											item: document,
											type: "item",
										),
									);
								}).toList(),
							);
						}
					}
				),
      ],
    );
  }
}
