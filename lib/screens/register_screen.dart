import 'package:flutter/material.dart';
import 'package:ki_kati/components/http_servive.dart';
import 'package:ki_kati/components/textfield_component.dart';
import 'package:ki_kati/components/custom_button.dart';
import 'package:ki_kati/screens/otp_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final HttpService httpService = HttpService('https://ki-kati.com/api');
  // Text editing controllers
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  String? selectedGender; // For gender selection

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateOfBirthController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Loading state
  bool _isLoading = false;

  // Password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Error messages
  String? _usernameError;
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _dobError;
  String? _genderError;

  // Validate inputs
  bool _validateInputs() {
    _usernameError =
        usernameController.text.isEmpty ? 'Username cannot be empty' : null;
    _firstNameError =
        firstNameController.text.isEmpty ? 'First name cannot be empty' : null;
    _lastNameError =
        lastNameController.text.isEmpty ? 'Last name cannot be empty' : null;
    _emailError = emailController.text.isEmpty
        ? 'Email cannot be empty'
        : !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)
            ? 'Please enter a valid email'
            : null;
    _passwordError =
        passwordController.text.isEmpty ? 'Password cannot be empty' : null;
    _confirmPasswordError = confirmPasswordController.text.isEmpty
        ? 'Please confirm your password'
        : passwordController.text != confirmPasswordController.text
            ? 'Passwords do not match'
            : null;
    _dobError = dateOfBirthController.text.isEmpty
        ? 'Date of birth cannot be empty'
        : null;
    _genderError = selectedGender == null ? 'Please select your gender' : null;

    return _usernameError == null &&
        _firstNameError == null &&
        _lastNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _dobError == null &&
        _genderError == null;
  }

  // Sign user in method
  void signUserIn() async {
    setState(() {
      _isLoading = true;
    });

    if (!_validateInputs()) {
      setState(() {
        _isLoading = false; // Set loading to false
      });
      return;
    }

    try {
      final response = await httpService.post('/auth/register', {
        'username': usernameController.text,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'gender': selectedGender,
        'password': passwordController.text,
        'dateOfBirth': dateOfBirthController.text,
      });
      print(response);
      if (response['statusCode'] == 201) {
        // Simulate success
        _showSuccessDialog(response['body']['message']);
        _clearFields();
      } else {
        // Handle other status codes
        print(response);
        _showErrorDialog(response['body']['message']);
      }
    } catch (e) {
      print('Error: $e'); // Handle errors here
      _showErrorDialog('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false
      });
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Success",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          content: const Text(
              "Your account has been created and we sent you an access code, check your email!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the pop-up
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OtpScreen(email: emailController.text),
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          content: Text(message,
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the pop-up
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _clearFields() {
    usernameController.clear();
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    dateOfBirthController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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

                    // Username text field
                    TextFieldComponent(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                      suffixIcon:
                          const Icon(Icons.person, color: Color(0xFFBDBDBD)),
                      errorText: _usernameError,
                    ),
                    const SizedBox(height: 10),

                    // First and Last Name text fields in one row
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldComponent(
                            controller: firstNameController,
                            hintText: 'First Name',
                            obscureText: false,
                            errorText: _firstNameError,
                          ),
                        ),
                        const SizedBox(width: 10), // Space between the fields
                        Expanded(
                          child: TextFieldComponent(
                            controller: lastNameController,
                            hintText: 'Last Name',
                            obscureText: false,
                            errorText: _lastNameError,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Email text field
                    TextFieldComponent(
                      controller: emailController,
                      hintText: 'Your Email',
                      obscureText: false,
                      suffixIcon:
                          const Icon(Icons.email, color: Color(0xFFBDBDBD)),
                      errorText: _emailError,
                    ),
                    const SizedBox(height: 10),

                    // Password and Confirm Password text fields in one row
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
                      errorText: _passwordError,
                    ),

                    const SizedBox(height: 10),

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
                      errorText: _confirmPasswordError,
                    ),

                    const SizedBox(height: 10),

                    // Date of Birth text field with calendar picker
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFieldComponent(
                          controller: dateOfBirthController,
                          hintText: 'Date of Birth (YYYY-MM-DD)',
                          obscureText: false,
                          suffixIcon: const Icon(Icons.calendar_today,
                              color: Color(0xFFBDBDBD)),
                          errorText: _dobError,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Gender dropdown
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      hint: const Text('Select Gender'),
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(
                            value: "Female", child: Text("Female")),
                        DropdownMenuItem(value: "Other", child: Text("Other")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      decoration: InputDecoration(
                        errorText: _genderError,
                        //border: InputBorder.none,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
