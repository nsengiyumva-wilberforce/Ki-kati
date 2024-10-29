import 'package:flutter/material.dart';
import 'package:ki_kati/components/http_servive.dart';
import 'package:ki_kati/components/textfield_component.dart';
import 'package:ki_kati/components/social_icon_button.dart';
import 'package:ki_kati/components/custom_button.dart';
import 'package:ki_kati/screens/forgot_password_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final secureStorage = const FlutterSecureStorage();
  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _secureText = true; // To hold secure boolean either as true or false
  bool _isLoading = false; // Loading state
  String? _usernameError; // Variable to hold username error message
  String? _passwordError; // Variable to hold password error message
  String? _generalError; // Variable to hold general error message

  final HttpService httpService =
      HttpService('https://jsonplaceholder.typicode.com');

  String _data = 'Fetching data...';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await httpService.get('/posts/1');
      print(data);
      setState(() {
        _data = data['title']; // Update state with the fetched data
      });
    } catch (e) {
      print(e);
      setState(() {
        _data = 'Error: $e';
      });
    }
  }

  Future<void> postData() async {
    try {
      final data = await httpService.post('/posts', {
        'title': 'foo',
        'body': 'bar',
        'userId': 1,
      });
      print(data); // Handle your posted data
    } catch (e) {
      print('Error: $e'); // Handle errors here
    }
  }

  // Sign user in method
  void signUserIn() async {
    fetchData();
    setState(() {
      _isLoading = true; // Set loading to true
      _usernameError = null; // Clear previous username error
      _passwordError = null; // Clear previous password error
      _generalError = null; // Clear previous general error
    });

    // Validate username and password fields
    if (usernameController.text.isEmpty) {
      setState(() {
        _isLoading = false; // Set loading to false
        _usernameError =
            'Please enter your username'; // Set username error message
      });
      return; // Exit the method if validation fails
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        _isLoading = false; // Set loading to false
        _passwordError =
            'Please enter your password'; // Set password error message
      });
      return; // Exit the method if validation fails
    }

    // Simulate a network request
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful login
    if (usernameController.text == "engdave" &&
        passwordController.text == "engdave") {
      //print(usernameController.text);
      //print(passwordController.text);
      await secureStorage.write(
          key: 'authToken', value: "123"); // Save token securely
      print("Token saved:");
      setState(() {
        _isLoading = false; // Set loading to false
        // Reset the input fields
        usernameController.clear();
        passwordController.clear();
        _generalError = null;
      });
    } else {
      setState(() {
        _isLoading = false; // Set loading to false
        _generalError =
            'Invalid username or password'; // Set general error message
      });
    }
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
                mainAxisSize:
                    MainAxisSize.min, // Ensure it takes minimum height
                children: [
                  const Center(
                    child: Image(
                      image: AssetImage("images/logo.png"),
                      width: 120.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    "Log in to Ki-Kati",
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
                    "Welcome back! Sign in using your social account or email to continue us",
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

                  // Social icons
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

                  const SizedBox(height: 10),

                  // OR divider
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

                  // Username text field
                  TextFieldComponent(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                    suffixIcon:
                        const Icon(Icons.person, color: Color(0xFFBDBDBD)),
                    errorText: _usernameError, // Pass username error
                  ),

                  const SizedBox(height: 10),

                  // Password text field
                  TextFieldComponent(
                    controller: passwordController,
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

                  const SizedBox(height: 10),
                ],
              ),

              Column(
                children: [
                  // Bottom group with the login button
                  CustomButton(
                    onTap: () {
                      signUserIn(); // Call the sign-in method
                    },
                    buttonText: _isLoading ? "Logging in ..." : "Log in",
                    isLoading: _isLoading,
                    color: _isLoading
                        ? const Color.fromARGB(255, 38, 34, 34)
                        : Colors.black,
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPassword()),
                      );
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: Colors.blue[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
