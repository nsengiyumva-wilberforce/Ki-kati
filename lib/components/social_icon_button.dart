import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  final String imagePath;
  const ImageTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(100),
        color: Colors.grey[200],
      ),
      child: Image.asset(
        imagePath,
        height: 30,
      ),
    );
  }
}
