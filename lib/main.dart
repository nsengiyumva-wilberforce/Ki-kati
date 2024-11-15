import 'package:flutter/material.dart';
import 'package:ki_kati/services/socket_service.dart';
import 'package:provider/provider.dart';
import 'package:ki_kati/screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SocketService(),
      child:
          const MaterialApp(debugShowCheckedModeBanner: false, home: Splash()),
    ),
  );
}
