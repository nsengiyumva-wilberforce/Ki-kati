import 'package:flutter/material.dart';
import 'package:ki_kati/components/http_servive.dart';
import 'package:ki_kati/screens/onboarding_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final HttpService httpService = HttpService('https://ki-kati.com/api');
  final secureStorage = const FlutterSecureStorage();

  bool _isLoading = false; // Loading state

  void logout() async {
    setState(() {
      _isLoading = true; // Set loading to true
    });

    //perform network request
    try {
      final response = await httpService.post('/auth/logout', {});
      print(response);
      if (response['statusCode'] == 200) {
        // successful reset
        setState(() {
          _isLoading = false; // Set loading to false
        });

        await secureStorage.delete(key: 'authToken');
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      } else {
        // Handle other status codes
        setState(() {
          _isLoading = false; // Set loading to false
        });
      }
    } catch (e) {
      print('Error: $e'); // Handle errors here\
      setState(() {
        _isLoading = false; // Set loading to false
      });
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      /*
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      */
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgF2suM5kFwk9AdFjesEr8EP1qcyUvah8G7w&s'), // Replace with actual image URL or Asset
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    'Bassirou Gueye',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SettingItem(
              icon: Icons.color_lens,
              title: "Account",
              subtitle: "privacy, settings, change number",
              onTap: () {},
            ),
            SettingItem(
              icon: Icons.lock,
              title: "Chat",
              subtitle: "Chat history, theme, wallpapers",
              onTap: () {},
            ),
            /*
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: const Text("Dark mode"),
              subtitle: const Text("Automatic"),
              value: false,
              onChanged: (bool value) {},
            ),
            */
            SettingItem(
              icon: Icons.info,
              title: "Notifications",
              subtitle: "Messages, group and other",
              onTap: () {},
            ),
            SettingItem(
              icon: Icons.help,
              title: "Help",
              subtitle: "Help center, contact us, privacy policy",
              onTap: () {},
            ),
            SettingItem(
              icon: Icons.storage,
              title: "Storage and data",
              subtitle: "Network usage, storage usage",
              onTap: () {},
            ),
            SettingItem(
              icon: Icons.group,
              title: "Invite a friend",
              subtitle: "Help center, contact us, privacy policy",
              onTap: () {},
            ),
            const Divider(height: 40),
            Text(
              "Account",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text("Sign Out"),
              onTap: _isLoading ? null : logout, // Disable if loading
              trailing: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ) // Show spinning indicator if loading
                  : null,
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.black),
              title: const Text("Change email"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
