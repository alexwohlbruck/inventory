import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Inventory'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.group}) : super(key: key);

  final String title;
  final DocumentReference group;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GroupDetail(group: widget.group),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class GroupDetail extends StatefulWidget {
  final DocumentReference group;

  GroupDetail({this.group});

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {

  @override
  Widget build(BuildContext context) {
    const gridPadding = 2.5;

    return Container(
      padding: const EdgeInsets.all(gridPadding),
      child: StreamBuilder<QuerySnapshot>(
        stream: widget.group != null
          ? Firestore.instance.collection('groups').where('group', isEqualTo: widget.group).snapshots()
          : Firestore.instance.collection('groups').where('group', isNull: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator()
            );
          } else {
            return GridView.count(
              crossAxisCount: 2,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return Container(
                  padding: const EdgeInsets.all(gridPadding),
                  child: GridTile(
                    child: InkResponse(
                      enableFeedback: true,
                      child: Image.network(
                        document['image'],
                        fit: BoxFit.cover
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(
                          title: document['name'],
                          group: document.reference,
                        )));
                      }
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black38,
                      title: Text(document['name']),
                      subtitle: Text('Subtitle'),
                    )
                  )
                );
              }).toList()
            );  
          }
        }
      )
    );
  }
}