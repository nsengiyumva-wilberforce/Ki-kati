import 'package:flutter/material.dart';
import 'package:ki_kati/screens/chat_screen.dart';
import 'package:ki_kati/screens/friend_requests_screen.dart';
import 'package:ki_kati/screens/friends_screen.dart';
import 'package:ki_kati/screens/group_screen.dart';
import 'package:ki_kati/screens/search_screen.dart';
import 'package:ki_kati/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // To track the currently selected index
  final List<Widget> _screens = [
    const ChatScreen(),
    const KikatiGroup(),
    const FriendsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
    /*
    if (index == 3) {
      // Profile tab index
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    }
    */
  }

  @override
  void initState() {
    super.initState();
    // get current username from secure storage
  }

  void _onActionSelected(String action) {
    print("Action selected: $action");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.search, color: Colors.white), // Search icon
          onPressed: () {
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          }, // Open the search modal on press
          padding: const EdgeInsets.all(6.0), // Adjust padding for smaller size
          splashColor: Colors.transparent, // Remove splash color
          highlightColor: Colors.transparent, // Remove highlight color
        ),
        title: const Text(
          "Ki-Kati",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.people, color: Colors.white),
            label: const Text(
              'Requests',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (context) => const FriendRequestScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: _screens[_selectedIndex], // Display the selected screen

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Set the current index
        selectedItemColor: Colors.green, // Color for the selected item
        onTap: _onItemTapped, // Handle item tap
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
