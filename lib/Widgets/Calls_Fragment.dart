import 'package:flutter/material.dart';
import 'package:ki_kati/Widgets/Calls_Lists.dart';

class Calls_Screen extends StatefulWidget {
  const Calls_Screen({Key? key}) : super(key: key);

  @override
  State<Calls_Screen> createState() => _Calls_ScreenState();
}

class _Calls_ScreenState extends State<Calls_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CallList(),
    );
  }
}
