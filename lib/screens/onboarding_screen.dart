import 'package:flutter/material.dart';
import 'package:ki_kati/components/custom_button.dart';
import 'package:ki_kati/components/social_icon_button.dart';
import 'package:ki_kati/screens/login_screen.dart';
import 'package:ki_kati/screens/register_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Image(
                    image: AssetImage("images/logo.png"),
                    width: 120.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Connect \nfriends",
                  style: TextStyle(
                      fontSize: 50.0,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      letterSpacing: 2),
                ),

                const Text(
                  "easily",
                  style: TextStyle(
                      fontSize: 50.0,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2),
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Stay connected with friends and family with Ki-Kati",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic),
                ),

                const SizedBox(height: 30),

                // icons

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageTile(imagePath: 'images/facebook.jpg'),
                    SizedBox(width: 20),
                    ImageTile(imagePath: 'images/google.png'),
                    SizedBox(width: 20),
                    ImageTile(imagePath: 'images/apple.png'),
                  ],
                ),

                const SizedBox(height: 30),

                // or continue with
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                CustomButton(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    )
                  },
                  buttonText: "Sign Up with Email",
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Have account ? ",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
