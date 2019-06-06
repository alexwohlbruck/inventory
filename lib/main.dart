import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'dart:collection';

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
    final Queue navigationStack = new Queue();

    return Scaffold(
      body: GroupDetail(group: widget.group),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: new GroupDetailBar(textTheme: textTheme, navigationStack: navigationStack),
    );
  }
}

class GroupDetailBar extends StatelessWidget {
  const GroupDetailBar({
    Key key,
    @required this.textTheme,
    @required this.navigationStack,
  }) : super(key: key);

  final TextTheme textTheme;
  final Queue navigationStack;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(25.0),

        // App bar contents
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            
            // Left text
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                // Breadcrumbs
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    children: navigationStack.map((group) {
                      return Text(group['name']);
                    })
                    .toList(),
                    /*<Widget>[
                      Text('Home'),
                      Icon(Icons.keyboard_arrow_right, size: 16.0),
                      Text('Bedroom'),
                      Icon(Icons.keyboard_arrow_right, size: 16.0),
                      Text('Dresser'),
                      Icon(Icons.keyboard_arrow_down, size: 16.0),
                    ]*/
                  ),
                ),
                
                // Group details
                Text('My home',
                    style: textTheme.title.apply(fontWeightDelta: 1)),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 6.0),
                  child:
                      Text('6 groups and 3 items', style: textTheme.subtitle),
                ),
                Text('182 total items - \$12,382 value',
                    style: textTheme.caption),
              ],
            ),

            // Star button
            IconButton(
              icon: Icon(Icons.star_border),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class GroupDetail extends StatefulWidget {
  DocumentReference group;

  GroupDetail({this.group});

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  @override
  Widget build(BuildContext context) {
    const gridPadding = 4.0;

    // return Padding(
    //   padding: const EdgeInsets.all(50.0),
    //   child: Container(
    //     width: 150.0,
    //     height: 150.0,

    //     child: new Tile(),
    //   ),
    // );

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
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData && snapshot.data.documents.length == 0) {
                  // No data, return nothing
                  return Container();
                }
                return GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    shrinkWrap: true,
                    primary: false,
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return Container(
                        padding: const EdgeInsets.all(gridPadding),
                        child: Tile(item: document, type: "group"),
                      );
                      return Container(
                          padding: const EdgeInsets.all(gridPadding),
                          child: InkResponse(
                            onTap: () {
                              setState(() => widget.group = document.reference);
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(
                              //   title: document['name'],
                              //   group: ,
                              // )));
                            },
                            enableFeedback: true,
                            child: GridTile(
                                child: Image.network(document['image'],
                                    fit: BoxFit.cover),
                                footer: GridTileBar(
                                  backgroundColor: Colors.black38,
                                  title: Text(document['name']),
                                  subtitle: Text('Subtitle'),
                                )),
                          ));
                    }).toList());
              }
            }),
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
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState != ConnectionState.waiting &&
                  snapshot.hasData) {
                return GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    primary: false,
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return Padding(
                        padding: const EdgeInsets.all(gridPadding),
                        child: Tile(item: document, type: "item"),
                      );
                    }).toList());
              }
            }),
      ],
    );
  }
}

// A tile that displays a group or item
class Tile extends StatelessWidget {
  const Tile({
    Key key,
    @required this.item,
    @required this.type, // 'group', 'item'
  }) : super(key: key);

  final DocumentSnapshot item;
  final String type;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        // TODO: Add current group to navigationStack
      },
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black45,
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 1.5))
        ]),
        child: ClipRRect(
          // Round corners
          borderRadius: BorderRadius.circular(7.0),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              // Background image
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(item['image']),
                  fit: BoxFit.fill,
                )),
              ),
              // Gradient scrim
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        colors: [Color(0x00000000), Color(0xAA000000)])),
              ),
              // Text layout
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.star_border)),
                    Spacer(),
                    Padding(  
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item['name'], 
                            style: textTheme.subtitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('4 groups - 24 items', style: textTheme.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
