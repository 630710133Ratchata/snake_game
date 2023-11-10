import 'package:flutter/material.dart';
import 'package:snake_game/screen/home_page.dart';
import 'package:snake_game/screen/menu_page.dart';
import 'package:snake_game/screen/rating_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MenuPage(),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}




