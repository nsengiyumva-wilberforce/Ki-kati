import 'package:flutter/material.dart';
import 'package:ki_kati/components/http_servive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key});

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  final secureStorage = const FlutterSecureStorage();
  final HttpService httpService = HttpService("https://ki-kati.com/api/users");

  bool isLoading = false; // Track loading state
  List<Map<String, dynamic>> friendRequests = [];
  String? username;

  Future<void> _initialize() async {
    // Fetch the username asynchronously
    username = await secureStorage.read(key: 'username');
    print("Fetched username: $username");

    // Trigger a rebuild after username is fetched
    setState(() {});
  }

  Future<void> getFriendRequests() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      // Fetch incoming friend requests from API
      final response = await httpService.get('/friend-requests');

      setState(() {
        friendRequests = List<Map<String, dynamic>>.from(response);
      });
      print("Fetched friend requests");
      print(friendRequests);
    } catch (e) {
      setState(() {
        friendRequests = [];
      });
      // Handle any error that occurs
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load friend requests')),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> handleFriendRequest(String targetUsername, bool confirm) async {
    setState(() {
      isLoading = true; // Start loading
    });

    String endpoint =
        confirm ? '/accept-friend-request' : '/reject-friend-request';

    try {
      final response =
          await httpService.post(endpoint, {'senderUsername': targetUsername});

      // After the response, update the list of requests
      getFriendRequests();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response['body']['message']}')),
      );
    } catch (e) {
      // If an error occurs, show an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error handling friend request: $e')),
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
    _initialize();
    getFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: const Text(
          'Friend Requests',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: isLoading && friendRequests.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: getFriendRequests,
              child: friendRequests.isEmpty
                  ? const Center(
                      child: Text("No pending friend requests."),
                    )
                  : ListView.builder(
                      itemCount: friendRequests.length,
                      itemBuilder: (context, index) {
                        var friendRequest = friendRequests[index];
                        String requestUsername =
                            friendRequest['username'] ?? 'Unknown';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.green,
                              child: Text(
                                requestUsername[
                                    0], // Display first letter of the username
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(requestUsername),
                            subtitle:
                                const Text('You have a new friend request'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () => handleFriendRequest(
                                      requestUsername, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Confirm'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () => handleFriendRequest(
                                      requestUsername, false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Deny'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
