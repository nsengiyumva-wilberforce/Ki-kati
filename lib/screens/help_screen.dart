import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Help & Support',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
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
                color: Colors.black,
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
                color: Colors.black,
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
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.email, color: Colors.black),
              title: Text('Email: support@kikati.com'),
              subtitle: Text('We will respond within 24 hours.'),
            ),
            const ListTile(
              leading: Icon(Icons.phone, color: Colors.black),
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
                iconColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Move Back To Settings',
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
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            _getAnswerForQuestion(question),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Method to get answer based on the question
  String _getAnswerForQuestion(String question) {
    switch (question) {
      case 'How do I start a one-on-one chat?':
        return 'To start a one-on-one chat, go to the "Chats" section and tap on the "New Chat" icon. Select a contact from your list, and start typing your message. You can send text, voice messages, images, and videos during the chat.';
      case 'How do I create a group chat?':
        return 'To create a group chat, navigate to the "Groups" section and tap the "Create Group" button. Add members from your contact list, give the group a name, and customize the group settings. Once done, you can start chatting and sharing media with everyone in the group.';
      case 'How do I make a post?':
        return 'To make a post, go to the "Home" screen and tap the "Create Post" button. You can add text, images, or videos to your post. Once you are happy with it, tap "Post" to share it with your followers and the Ki-Kati community. Posts can be commented on or liked by others.';
      case 'How do I access the marketplace?':
        return 'To access the marketplace, tap on the "Marketplace" tab from the bottom navigation bar. You can browse through different categories of products, list your own items for sale, or make purchases. If you see something you like, you can contact the seller directly through the marketplace chat feature.';
      default:
        return 'Sorry, we don\'t have an answer for this question yet.';
    }
  }
}
