
import 'package:flutter/material.dart';
import 'package:inventory/navigation-model.dart';
import 'package:scoped_model/scoped_model.dart';

class GroupDetailBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(25.0),

        // * App bar contents
        child: new GroupDetailInfo(),
      ),
    );
  }
}

class GroupDetailInfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final navigationStack = ScopedModel.of<NavigationModel>(context, rebuildOnChange: true).navigationStack;
    final onHomePage = navigationStack.length == 0;

    return Row(
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
            onHomePage ? Container() : Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Breadcrumbs(),
            ),

            // * Group details
            Text(
              onHomePage ? 'Home' : navigationStack.last['name'],
              style: textTheme.title.apply(fontWeightDelta: 1),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 6.0),
              child: Text(
                '5 groups and 3 items',
                style: textTheme.subtitle,
              ),
            ),
            Text(
              '182 total items - \$12,382 value',
              style: textTheme.caption,
            ),
          ],
        ),

        // * Star button
        IconButton(
          icon: Icon(Icons.star_border),
          onPressed: () {},
        )
      ],
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
        breadcrumbs.removeLast(); // Don't show current group in breadcrumbs

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