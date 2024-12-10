import 'package:flutter/material.dart';
import 'package:ki_kati/components/http_servive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final secureStorage = const FlutterSecureStorage();
  final HttpService httpService = HttpService("https://ki-kati.com/api/users");
  bool isLoading = false; // Track loading state

  String? username;

  Future<void> _initialize() async {
    // Fetch the username asynchronously
    username = await secureStorage.read(key: 'username');
    print("Fetched username: $username");

    // Trigger a rebuild after username is fetched
    setState(() {});
  }

  List<Map<String, dynamic>> friends = [];

  Future<void> getFriends() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      // Call the delete API
      final response = await httpService
          .get('/friends'); // API endpoint for deleting messages
      //print(response);
      setState(() {
        friends = List.from(response);
      });
      print("These are my friends");
      print(friends);
    } catch (e) {
      setState(() {
        friends = [];
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load friends')),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // get current username from secure storage
    _initialize();
    getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: isLoading && friends.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator(), // Show loading only at the start
            )
          : RefreshIndicator(
              onRefresh: getFriends, // Trigger the refresh when user pulls down
              child: friends.isEmpty
                  ? const Center(
                      child: Text("You have no friends!"),
                    )
                  : ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        var friend = friends[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              '${friend['firstName']?[0] ?? ''}${friend['lastName']?[0] ?? ''}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                              '${friend['firstName']} ${friend['lastName']}'),
                          subtitle:
                              Text('${friend['friends']?.length ?? 0} friends'),
                        );
                      },
                    ),
            ),
    );
  }
}
