
// * A tile that displays a group or item
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
	
  final DocumentSnapshot item;
  final String type;

  const Tile({
		Key key,
		@required this.item,
		@required this.type, // 'group', 'item'
	}) : super(key: key);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        if (widget.type == 'group') {
          // Group pressed, add it to nav history and reload state with new group
          // navigationStack.addLast(item);
        }
      },
      child: Container(

				// * Tile shadow
        decoration: BoxDecoration(
					boxShadow: [
          	BoxShadow(
              color: Colors.black45,
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 1.5)
						)
        	]
				),

        child: ClipRRect(
          // * Round corners
          borderRadius: BorderRadius.circular(7.0),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              
							// * Background image
              Container(
                decoration: BoxDecoration(
                	image: DecorationImage(
										image: NetworkImage(widget.item['image']),
										fit: BoxFit.fill,
                	),
								),
              ),
              
							// * Gradient scrim
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
									gradient: LinearGradient(
										begin: Alignment.topCenter,
										end: Alignment.bottomCenter,
										stops: [0.0, 1.0],
										colors: [Color(0x00000000), Color(0xAA000000)]
									)
								),
              ),
              
							// * Text layout
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
											icon: Icon(Icons.star_border),
											onPressed: () {
												// TODO: Handle tile star clicked
											},
										),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
												vertical: 15.0
											),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.item['name'],
                            style: textTheme.subtitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('4 groups - 24 items', style: textTheme.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
