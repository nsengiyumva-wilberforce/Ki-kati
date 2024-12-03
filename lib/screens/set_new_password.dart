import 'package:flutter/material.dart';
import 'package:ki_kati/components/custom_button.dart';
import 'package:ki_kati/components/http_servive.dart';
import 'package:ki_kati/components/secureStorageServices.dart';
import 'package:ki_kati/components/textfield_component.dart';
import 'package:ki_kati/screens/login_screen.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  SecureStorageService storageService = SecureStorageService(); //servi
  final HttpService httpService = HttpService('https://ki-kati.com/api/auth');
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _secureText = true;
  String? _errorCode;
  String? _passwordError;
  String? _generalError;

  Future<String> _setNewPassword(String password) async {
    Map<String, dynamic>? retrievedResetEmail =
        await storageService.retrieveData('passwordReset');
    final email = retrievedResetEmail?['email'];
    try {
      final response = await httpService.post('/reset-password',
          {'email': email.trim(), 'password': password.trim()});

      if (response['statusCode'] == 200) {
        return response['body']['message'];
      } else {
        return response['body']['message'];
      }
    } catch (e) {
      return '$e';
    }
  }

  Future<String> _verifyCode(String code) async {
    Map<String, dynamic>? retrievedResetEmail =
        await storageService.retrieveData('passwordReset');
    final email = retrievedResetEmail?['email'];
    print(email);
    try {
      final response = await httpService.post(
          '/verify-reset-code', {'email': email.trim(), 'code': code.trim()});

      if (response['statusCode'] == 200) {
        return response['body']['message'];
      } else {
        return response['body']['message'];
      }
    } catch (e) {
      print('Error: $e'); // Handle errors here\
      /*
      setState(() {
        _generalError = '$e'; // Set general error message
      });
      */
      return "$e";
    } /*finally {
      setState(() {
        _isLoading = false; // Set loading to false
      });
    }      */
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
      _passwordError = null;
      _errorCode = null;
    });

    // Validate code and username fields
    if (_codeController.text.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorCode = 'Please Enter The Code';
      });
      return; // Exit the method if validation fails
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _isLoading = false;
        _passwordError = 'Please enter your password';
      });
      return; // Exit the method if validation fails
    }

    // submission logic here
    final code = _codeController.text.trim();
    final newPassword = _passwordController.text.trim();

    String verifyCodeResponse = await _verifyCode(code);
    if (verifyCodeResponse.contains("Code verified successfully")) {
      String resultSetNewPassword = await _setNewPassword(newPassword);
      if (resultSetNewPassword.contains("Password reset successfully")) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully!')),
        );
        setState(() {
          _isLoading = false;
          _codeController.clear();
          _passwordController.clear();
          _generalError = null;
        });
        //delete the passwordReset key pair from secure storage
        await storageService.deleteData('passwordReset');
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        });
      } else {
        setState(() {
          _isLoading = false;
          _generalError = resultSetNewPassword;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _generalError = verifyCodeResponse;
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display general error message if it exists
              if (_generalError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _generalError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 10),
              TextFieldComponent(
                controller: _codeController,
                hintText: 'Enter the Code Sent to You',
                obscureText: false,
                keyboardType: TextInputType.number,
                suffixIcon: const Icon(Icons.email, color: Color(0xFFBDBDBD)),
                errorText: _errorCode, // Display error message if exists
              ),
              const SizedBox(height: 16.0),
              TextFieldComponent(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: _secureText,
                suffixIcon: IconButton(
                  icon: Icon(
                      _secureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade400),
                  onPressed: () {
                    setState(() {
                      _secureText = !_secureText;
                    });
                  },
                ),
                errorText: _passwordError, // Pass password error
              ),
              const SizedBox(height: 24.0),
              CustomButton(
                onTap: () {
                  _submit(); // Call the sign-in method
                },
                buttonText:
                    _isLoading ? "Resetting Password ..." : "Reset Password",
                isLoading: _isLoading,
                color: _isLoading
                    ? const Color.fromARGB(255, 38, 34, 34)
                    : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
