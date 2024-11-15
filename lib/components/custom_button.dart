import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText; // Variable for button text
  final Color color; // Variable for button color
  final bool isLoading; // Variable for loading state

  const CustomButton({
    super.key,
    required this.onTap,
    required this.buttonText, // Make buttonText a required parameter
    this.color = Colors.black, // Default color
    this.isLoading = false, // Default loading state
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap, // Disable onTap if loading
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: isLoading // Check if loading
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20, // Set the width of the progress indicator
                      height: 20, // Set the height of the progress indicator
                      child: CircularProgressIndicator(
                        color:
                            Colors.white, // Customize loading indicator color
                        strokeWidth:
                            2.0, // Adjust stroke width for smaller indicator
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Loading, please wait...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              : Text(
                  buttonText, // Use the buttonText variable
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
        ),
      ),
    );
  }
}
