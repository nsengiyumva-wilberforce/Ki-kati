import 'package:flutter/material.dart';
import 'package:ki_kati/components/textfield_component.dart';
import 'package:ki_kati/components/custom_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  bool _isLoading = false; // Loading state
  String? _errorMessage; // Variable to hold error message
  String? _successMessage; // Variable to hold success message

  // Method to handle password reset
  void resetPassword() async {
    setState(() {
      _isLoading = true; // Set loading to true
      _successMessage = null; // Clear any previous success message
      _errorMessage = null;
    });

    // Simulate a network request
    await Future.delayed(const Duration(seconds: 2));

    // Validate email
    final email = emailController.text;
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _isLoading = false; // Set loading to false
        _errorMessage =
            'Please enter a valid email address'; // Set error message
      });
      return; // Exit the method if validation fails
    }

    // Simulate successful reset
    setState(() {
      _isLoading = false; // Set loading to false
      emailController.clear();
      _successMessage =
          'A reset link has been sent to your email!'; // Success message
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Reset Your Password",
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                "Enter your email address to receive a password reset link.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20.0),

              // Display success message if it exists
              if (_successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _successMessage!,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),

              // Email text field
              TextFieldComponent(
                controller: emailController,
                hintText: 'Email Address',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                suffixIcon: const Icon(Icons.email, color: Color(0xFFBDBDBD)),
                errorText: _errorMessage, // Display error message if exists
              ),

              const SizedBox(height: 20.0),

              // Reset password button
              CustomButton(
                onTap: () {
                  resetPassword(); // Call the reset password method
                },
                buttonText: _isLoading ? "Sending..." : "Send Reset Link",
                isLoading: _isLoading,
                color: _isLoading ? Colors.blue : Colors.black,
              ),

              const SizedBox(height: 20.0),

              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Navigate back to the login screen
                },
                child: const Text(
                  "Back to Login",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
