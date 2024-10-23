import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  int _start = 30; // Countdown starting value
  Timer? _timer; // Timer instance

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
    setState(() {
      _start = 30; // Reset timer to 30 seconds
    });
    _timer?.cancel(); // Cancel the existing timer
    startTimer(); // Restart the countdown timer
    // Add your code to resend the OTP here
    print("Resending OTP...");
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
                const Text(
                  "kinyonyidavid@gmail.com",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
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
                children: List.generate(4, (index) {
                  return SizedBox(
                    height: 55,
                    width: 50,
                    child: TextField(
                      controller: controllers[index],
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
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
                    child: const Text("Resend"),
                  ),
                ),
                const SizedBox(width: 10), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Gather the OTP values
                      String otp = controllers
                          .map((controller) => controller.text)
                          .join('');
                      print("Entered OTP: $otp");
                      // Add further logic to verify the OTP
                    },
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
