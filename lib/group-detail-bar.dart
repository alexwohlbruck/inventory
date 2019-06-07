
import 'package:flutter/material.dart';
import 'package:inventory/navigation-model.dart';
import 'package:scoped_model/scoped_model.dart';

class GroupDetailBar extends StatelessWidget {
  const GroupDetailBar({
    Key key,
    @required this.textTheme,
  }) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(25.0),

        // * App bar contents
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            // * Left text
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                // * Breadcrumbs
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Breadcrumbs(),
                ),

                // * Group details
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

            // * Star button
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

class Breadcrumbs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NavigationModel>(
      builder: (context, child, model){
        
        // * Build breadcrumbs for navigation
        var breadcrumbs = model.navigationStack.map((item) {
          return Breadcrumb(text: item['name'], isLast: false);
        }).toList();

        breadcrumbs.insert(0, Breadcrumb(text: 'Home', isLast: false));

        return Row(
          children: breadcrumbs,
        );
      }
    );
  }
}

class Breadcrumb extends StatelessWidget {
  const Breadcrumb({
    Key key,
    @required this.text,
    @required this.isLast,
  }) : super(key: key);

  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NavigationModel>(
      builder: (context, child, model) {
        return InkWell(
          onTap: () {
            model.regressHistory();            
          },
          child: Row(
            children: <Widget>[
              Text(text),
              Icon(isLast ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 16.0),
            ],
          ),
        );
      }
    );
  }
}