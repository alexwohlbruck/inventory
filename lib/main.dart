import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF20CBD8);
    const primaryDark = Color(0xFF19B5C1);
    const accent = Color(0xFFFFF453);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: primaryDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      title: 'Inventory',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primary,
        accentColor: accent,
        fontFamily: 'Lato',
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: GroupDetail(group: widget.group),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('My home', style: textTheme.title.apply(fontWeightDelta: 1)),
              Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 5.0),
                child: Text('6 groups and 3 items', style: textTheme.subtitle),
              ),
              Text('182 total items - \$12,382 value', style: textTheme.caption),
            ],
          ),
        ),
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

    return Column(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: widget.group != null
            ? Firestore.instance
              .collection('groups')
              .where('group', isEqualTo: widget.group)
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
              return Center(
                child: CircularProgressIndicator()
              );
            } else {
              if (snapshot.hasData && snapshot.data.documents.length == 0) {
                // No data, return nothing
                return Container();
              }
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
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
              return Center(
                child: CircularProgressIndicator()
              );
            }
            if (snapshot.connectionState != ConnectionState.waiting && snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return ListTile(
                    leading: document['image'] != null
                      ? CircleAvatar(
                        backgroundImage: NetworkImage(document['image']),
                      )
                      : null,
                    title: Text(document['name']),
                    subtitle: Text('Subtitle'),
                    trailing: Icon(Icons.more_vert)
                  );
                }).toList()
              );  
            }
          }
        ),
      ],
    );
  }
}