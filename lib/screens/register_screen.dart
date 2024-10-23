import 'package:flutter/material.dart';
import 'package:ki_kati/components/textfield_component.dart';
import 'package:ki_kati/components/custom_button.dart';
import 'package:ki_kati/screens/otp_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Loading state
  bool _isLoading = false;

  // Password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Error messages
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Sign user in method
  void signUserIn() async {
    setState(() {
      _isLoading = true; // Set loading to true
      // Reset error messages
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    // Simulate a network request
    await Future.delayed(const Duration(seconds: 2));

    // Validate input
    if (nameController.text.isEmpty) {
      _nameError = 'Name cannot be empty';
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (emailController.text.isEmpty) {
      _emailError = 'Email cannot be empty';
    } else if (!emailRegex.hasMatch(emailController.text)) {
      _emailError = 'Please enter a valid email';
    }

    if (passwordController.text.isEmpty) {
      _passwordError = 'Password cannot be empty';
    }

    if (confirmPasswordController.text.isEmpty) {
      _confirmPasswordError = 'Please confirm your password';
    } else if (passwordController.text != confirmPasswordController.text) {
      _confirmPasswordError = 'Passwords do not match';
    }

    // If there are errors, stop the loading and show messages
    if (_nameError != null ||
        _emailError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      setState(() {
        _isLoading = false; // Set loading to false
      });
      return;
    }

    // Simulate success
    setState(() {
      _isLoading = false; // Set loading to false
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    });

    // Show success pop-up
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Success",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          content: const Text(
              "Your account has been created and we sent you an access code, check you email!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the pop-up
                //route the user to the otp screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OtpScreen(
                          email:
                              "kinyonyidavid@gmail.com") //emailController.text
                      ),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top group of widgets
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Image(
                      image: AssetImage("images/logo.png"),
                      width: 120.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    "Sign up with Email",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "Get Vibe with friends and family today by signing up for our chat app!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[400],
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Name text field
                  TextFieldComponent(
                    controller: nameController,
                    hintText: 'Your Name',
                    obscureText: false,
                    suffixIcon:
                        const Icon(Icons.person, color: Color(0xFFBDBDBD)),
                    errorText: _nameError, // Show error after submission
                  ),

                  const SizedBox(height: 10),

                  // Email text field
                  TextFieldComponent(
                    controller: emailController,
                    hintText: 'Your Email',
                    obscureText: false,
                    suffixIcon:
                        const Icon(Icons.email, color: Color(0xFFBDBDBD)),
                    errorText: _emailError, // Show error after submission
                  ),

                  const SizedBox(height: 10),

                  // Password text field
                  TextFieldComponent(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    errorText: _passwordError, // Show error after submission
                  ),

                  const SizedBox(height: 10),

                  // Confirm Password text field
                  TextFieldComponent(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: !_isConfirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    errorText:
                        _confirmPasswordError, // Show error after submission
                  ),

                  const SizedBox(height: 10),
                ],
              ),

              Column(
                children: [
                  // Bottom group with the create account button
                  CustomButton(
                    onTap: _isLoading ? null : signUserIn,
                    buttonText: _isLoading
                        ? "Creating account..."
                        : "Create an account",
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 10),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
