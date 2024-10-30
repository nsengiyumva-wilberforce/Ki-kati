import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ki_kati/components/http_servive.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ki_kati/screens/login_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String username;
  const OtpScreen({super.key, required this.email, required this.username});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final secureStorage = const FlutterSecureStorage();
  final HttpService httpService = HttpService('https://ki-kati.com/api');
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  int _start = 30; // Countdown starting value
  Timer? _timer; // Timer instance
  bool isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the countdown when the screen is initialized
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel(); // Stop the timer when it reaches zero
        });
      } else {
        setState(() {
          _start--; // Decrease the countdown value
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void resendCode() {
    for (var controller in controllers) {
      controller.clear();
    }
    FocusScope.of(context).unfocus();

    setState(() {
      _start = 30; // Reset timer to 30 seconds
      isLoading = true; // Set loading state to true
    });
    _timer?.cancel(); // Cancel the existing timer
    startTimer(); // Restart the countdown timer

    // code to resend the OTP here
    print("Resending OTP...");
    resend(widget.username);
  }

  void resend(String username) async {
    try {
      final response = await httpService.post('/auth/resend-code', {
        'username': username,
      });
      print(response);
      if (response['statusCode'] == 200) {
        _showSuccessDialog(response['body']['message'], "resend");
      } else {
        // Handle other status codes
        print(response);
        _showErrorDialog(response['body']['message']);
      }
    } catch (e) {
      print('Error: $e'); // Handle errors here
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(); // Close loading dialog
      _showErrorDialog('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false; // Reset loading state
      });
      print("done!");
    }
  }

  void confirmOtp() async {
    // Gather the OTP values
    String otp = controllers.map((controller) => controller.text).join('');
    print("Entered OTP: $otp");

    // perform post request
    try {
      final response = await httpService.post('/auth/verify-code', {
        'username': widget.username,
        'code': otp,
      });
      print(response);
      if (response['statusCode'] == 200) {
        for (var controller in controllers) {
          controller.clear();
        }
        // ignore: use_build_context_synchronously
        FocusScope.of(context).unfocus();
        _showSuccessDialog(response['body']['message'], "verify");
      } else {
        // Handle other status codes
        print(response);
        _showErrorDialog(response['body']['message']);
      }
    } catch (e) {
      print('Error: $e'); // Handle errors here
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(); // Close loading dialog
      _showErrorDialog('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false; // Reset loading state
      });
      print("done!");
    }
  }

  void _showSuccessDialog(String message, String action) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                if (action == "verify") {
                  await secureStorage.delete(key: 'userOnboarding');
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                }
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
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  String maskEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex <= 1) return email; // Return as is if email is too short

    final localPart = email.substring(0, atIndex);
    final domainPart = email.substring(atIndex);

    // Masking the characters from the second to the second last
    final maskedLocalPart = localPart[0] +
        '*' * (localPart.length - 2) +
        localPart.substring(localPart.length - 1);

    return maskedLocalPart +
        domainPart; // Combine masked local part with domain part
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Image(
                image: AssetImage("images/logo.png"),
                width: 120.0,
              ),
            ),
            const SizedBox(height: 5.0),
            const Text(
              "Verification Code",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
            ),
            const SizedBox(height: 10.0),
            const Text(
              "We have sent a verification code to:",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0),
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                Text(
                  maskEmail(widget.email),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: _start == 0
                      ? resendCode
                      : null, // Enable only when timer reaches 0
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                      color: _start == 0 ? Colors.blue[400] : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    height: 55,
                    width: 60,
                    child: TextField(
                      controller: controllers[index],
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1), // Enabled border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1), // Focused border color
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              "Resend code in $_start seconds...",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _start == 0
                        ? resendCode
                        : null, // Enable only when timer reaches 0
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20), // Increase height
                    ),
                    child: isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20.0, // Adjusted width
                                height: 20.0, // Adjusted height
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth:
                                      2.0, // Keep the stroke width for visibility
                                ),
                              ),
                              SizedBox(
                                  width:
                                      8), // Space between the indicator and the text
                              Text(
                                "Resending...",
                                style: TextStyle(
                                    color:
                                        Colors.white), // Ensure text is visible
                              ),
                            ],
                          )
                        : const Text("Resend"),
                  ),
                ),
                const SizedBox(width: 10), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: confirmOtp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20), // Increase height
                    ),
                    child: const Text("Confirm"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
