import 'package:flutter/material.dart';
import 'package:ki_kati/components/http_servive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final secureStorage = const FlutterSecureStorage();
  final HttpService httpService = HttpService("https://ki-kati.com/api/users");

  // Controller to manage the search input
  final TextEditingController _searchController = TextEditingController();

  String? username;

  Future<void> _initialize() async {
    // Fetch the username asynchronously
    username = await secureStorage.read(key: 'username');
    print("Fetched username: $username");

    // Trigger a rebuild after username is fetched
    setState(() {});
  }

  List<Map<String, dynamic>> users = [];

  Future<void> searchFriends() async {
    String query = _searchController.text;
    if (query.isNotEmpty) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (context) => const AlertDialog(
          title: Text('Searching for users...'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Please wait..."),
            ],
          ),
        ),
      );

      try {
        // Call the delete API
        final response = await httpService
            .get('/search?query=$query'); // API endpoint for deleting messages
        //print(response);
        setState(() {
          users = List.from(response);
        });

        print(users);
      } catch (e) {
        print('Error searching: $e');
      } finally {
        // Dismiss the loading dialog after the search is complete
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Search Input Can not be empty'),
      ));
    }
  }

  Future<void> addFriend(String friendUsername) async {
    // Show loading dialog while adding the friend
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (context) => AlertDialog(
        title: const Text('Adding Friend '),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text("Request Friend To $friendUsername ..."),
          ],
        ),
      ),
    );

    try {
      // Simulate an API call to add the friend
      final response = await httpService.post('/send-friend-request', {
        'targetUsername': friendUsername,
      });

      print(response);

      // After adding friend, close the dialog and show a success message
      // ignore: use_build_context_synchronously
      if (mounted) {
        Navigator.pop(context); // Close the loading dialog

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response['body']['message']}')),
        );
      }
    } catch (e) {
      // If an error occurs, close the dialog and show an error message
      // ignore: use_build_context_synchronously
      // In case of an error, close the dialog and show an error message
      if (mounted) {
        Navigator.pop(context); // Close the loading dialog

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding friend: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // get current username from secure storage
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Your Friends"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: () {
          // Unfocus the TextField when tapping outside of it
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /*
              const Text(
                'Search For Friends',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller:
                          _searchController, // Using the controller here
                      //autofocus: true, // Focus the field when modal opens
                      decoration: InputDecoration(
                        hintText: 'Search for users...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20.0,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          iconSize: 20.0,
                          onPressed: () {
                            _searchController
                                .clear(); // Clears the search field
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  TextButton(
                    onPressed: searchFriends,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove padding
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.teal, // Set the color of the icon
                      size: 30.0, // Set the size of the icon
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              // Display the list of users found
              users.isEmpty
                  ? const Text('No users found',
                      style: TextStyle(color: Colors.red))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          // Extract the necessary details
                          var user = users[index];
                          bool isFriend =
                              user['friends']?.contains(username) ?? false;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.green,
                                child: Text(
                                  '${user['firstName']?.substring(0, 1) ?? ''}${user['lastName']?.substring(0, 1) ?? ''}', // Initials from first and last name
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              title: Text(
                                  '${user['firstName']} ${user['lastName']}'),
                              subtitle: Text(
                                  '${user['friends']?.length ?? 0} Friends'),
                              trailing: !isFriend
                                  ? ElevatedButton(
                                      onPressed: () {
                                        addFriend(user[
                                            'username']); // Add friend when pressed
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Add Friend'),
                                    )
                                  : const Text('Friend'),
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
