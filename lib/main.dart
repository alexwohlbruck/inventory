import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'home.dart';

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