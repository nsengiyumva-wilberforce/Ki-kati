import 'package:flutter/material.dart';
// import 'package:ki_kati/Widgets/MessageSection.dart';
import 'package:ki_kati/DashBoard.dart';
import 'package:ki_kati/screens/splash_screen.dart';
import 'Theme.dart';


void main() {
  // runApp(const MyApp());
  // runApp(const MaterialApp(home: Splash()));
  runApp(const Splash());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ki-kati',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      home: const Dashboard(),
    );
  }
}


