import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section 1: Introduction
            const Text(
              'Welcome to the Ki-Kati Help & Support section!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you have any questions, concerns, or need assistance with using Ki-Kati, please check out our FAQs or contact us directly. We\'re here to help you with everything from one-on-one and group chat, making posts, to using the marketplace features.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Section 2: Common FAQs (expandable)
            const Text(
              'Frequently Asked Questions (FAQs)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            _buildFAQTile(context, 'How do I start a one-on-one chat?'),
            _buildFAQTile(context, 'How do I create a group chat?'),
            _buildFAQTile(context, 'How do I make a post?'),
            _buildFAQTile(context, 'How do I access the marketplace?'),
            const SizedBox(height: 20),

            // Section 3: Contact Us
            const Text(
              'Need more help? Contact us directly!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.email, color: Colors.teal),
              title: Text('Email: support@kikati.com'),
              subtitle: Text('We will respond within 24 hours.'),
            ),
            const ListTile(
              leading: Icon(Icons.phone, color: Colors.teal),
              title: Text('Call Us: +123-456-7890'),
              subtitle: Text('Available Monday to Friday, 9AM - 6PM'),
            ),
            const SizedBox(height: 20),

            // Section 4: Back to Home
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              style: ElevatedButton.styleFrom(
                iconColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build FAQ tiles
  Widget _buildFAQTile(BuildContext context, String question) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Here will be the answer or instructions related to the question above. Make sure the content is clear and concise to help users find what they are looking for.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
