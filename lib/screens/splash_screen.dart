import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ki_kati/screens/home_screen.dart';
import 'package:ki_kati/screens/onboarding_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  final secureStorage = const FlutterSecureStorage();

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
    // Attempt to retrieve the token
    final token = await secureStorage.read(key: 'authToken');

    // Navigate based on token presence after a short delay (e.g., 3 seconds)
    Future.delayed(const Duration(seconds: 3), () {
      if (token != null) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
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
