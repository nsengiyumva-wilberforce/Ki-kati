import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ki_kati/components/secureStorageServices.dart';
import 'package:ki_kati/screens/home_screen.dart';
import 'package:ki_kati/screens/onboarding_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ki_kati/screens/otp_screen.dart';
import 'dart:convert';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  final secureStorage = const FlutterSecureStorage();
  SecureStorageService storageService = SecureStorageService();

  @override
  void initState() {
    //implement initState
    super.initState();
    //get rid of the top and bottom bars from the ui
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    //check if there is a valid token stored
    checkToken();
  }

  Future<void> checkToken() async {
    // Retrieve user data using the key 'user_data'
    Map<String, dynamic>? retrievedUserData =
        await storageService.retrieveData('user_data');

    final token = retrievedUserData?['token'];

    String? userOnboardingJson =
        await secureStorage.read(key: 'userOnboarding');

    // Navigate based on token presence after a short delay (e.g., 3 seconds)
    Future.delayed(const Duration(seconds: 3), () {
      if (token != null) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (userOnboardingJson != null) {
        Map<String, dynamic> userData = jsonDecode(userOnboardingJson);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) => OtpScreen(
                  email: userData['email'], username: userData['username'])),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    //implement dispose
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("images/logo.png"),
              width: 150.0,
            ),
          ],
        ),
      ),
    );
  }
}
