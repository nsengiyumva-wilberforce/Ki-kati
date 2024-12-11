import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // List of notifications as Map<String, dynamic> - this is your raw data
  final List<Map<String, dynamic>> notificationsData = [
    {
      'title': 'New Comment on Your Post',
      'body': 'Someone commented on your recent post. Check it out!',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'title': 'Friend Request',
      'body': 'You have a new friend request.',
      'time': DateTime.now().subtract(const Duration(minutes: 15)),
    },
    {
      'title': 'New Message',
      'body': 'You received a new message.',
      'time': DateTime.now().subtract(const Duration(minutes: 30)),
    },
    {
      'title': 'Event Reminder',
      'body': 'Don\'t forget about the event tomorrow!',
      'time': DateTime.now().subtract(const Duration(minutes: 60)),
    },
    {
      'title': 'Security Alert',
      'body': 'We noticed a new login from a different device.',
      'time': DateTime.now().subtract(const Duration(minutes: 120)),
    },
  ];

  // Converting the raw data into List<NotificationItem>
  late List<NotificationItem> notifications;

  @override
  void initState() {
    super.initState();
    // Convert Map to NotificationItem objects
    notifications = notificationsData
        .map((notification) => NotificationItem.fromMap(notification))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(
                notification.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(notification.body),
              trailing: Text(
                '${notification.time.hour}:${notification.time.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Model class to represent a notification
class NotificationItem {
  final String title;
  final String body;
  final DateTime time;

  NotificationItem({
    required this.title,
    required this.body,
    required this.time,
  });

  // Factory constructor to create a NotificationItem from a Map<String, dynamic>
  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      title: map['title'],
      body: map['body'],
      time: map['time'] is DateTime ? map['time'] : DateTime.parse(map['time']),
    );
  }
}
