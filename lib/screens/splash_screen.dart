import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ki_kati/screens/onboarding_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    //implement initState
    super.initState();
    //get rid of the top and bottom bars from the ui
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    //create a timer for the splash screen
    Future.delayed(const Duration(seconds: 5), () {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()));
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
