import 'package:flutter/material.dart';
import 'package:ki_kati/components/custom_button.dart';
import 'package:ki_kati/components/http_servive.dart';

class KikatiGroup extends StatefulWidget {
  const KikatiGroup({super.key});

  @override
  State<KikatiGroup> createState() => _KikatiGroupState();
}

class _KikatiGroupState extends State<KikatiGroup> {
  final TextEditingController _groupNameController = TextEditingController();
  final HttpService httpService = HttpService("https://ki-kati.com/api");

  bool _isLoading = false;
  bool isLoading = false;

  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> myGroups = []; // Stores the user's groups
  List<Map<String, dynamic>> availableGroups =
      []; // Stores other available groups
  Set<String> selectedFriends = {}; // Set to track selected friends by userId
  Set<String> selectedUsernames = {}; // Set to track selected usernames

  bool isMyGroups = true; // Track if the "My Groups" button is selected

  // Fetch the user's friends
  Future<void> getFriends() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await httpService.get('/users/friends');
      setState(() {
        friends = List.from(response);
      });
    } catch (e) {
      setState(() {
        friends = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load friends')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch the user's groups
  Future<void> getMyGroups() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await httpService.get('/users/myGroups');
      setState(() {
        myGroups = List.from(response);
      });
    } catch (e) {
      setState(() {
        myGroups = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load groups')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch the other available groups
  Future<void> getAvailableGroups() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await httpService.get('/groups/available');
      setState(() {
        availableGroups = List.from(response);
      });
    } catch (e) {
      setState(() {
        availableGroups = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load available groups')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Handle user selection for group creation
  void _toggleUserSelection(String userId, String username) {
    setState(() {
      if (selectedFriends.contains(userId)) {
        selectedFriends.remove(userId);
      } else {
        selectedFriends.add(userId);
      }

      // Remove and add usernames
      if (selectedUsernames.contains(username)) {
        selectedUsernames.remove(username);
      } else {
        selectedUsernames.add(username);
      }
    });
  }

  // Get initials from the user's name
  String _getInitials(String firstName, String lastName) {
    return '${firstName[0]}${lastName[0]}'.toUpperCase();
  }

  // Handle the group creation action
  Future<void> _createGroup() async {
    String groupName = _groupNameController.text.trim();

    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group name cannot be empty')));
    } else if (selectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one user')));
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await httpService.post('/groups/create', {
          'name': groupName,
          'members': selectedFriends.toList(),
        });

        if (response['statusCode'] == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Group "$groupName" created with members: ${selectedUsernames.join(", ")}')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create group')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getFriends(); // Fetch friends on initialization
    getMyGroups(); // Fetch the user's groups
    getAvailableGroups(); // Fetch available groups
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Need a group?",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isMyGroups = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      foregroundColor: Colors.white, // Text color (foreground)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Set border radius here
                      ),
                    ),
                    child: const Text("My Groups"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isMyGroups = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Background color
                      foregroundColor: Colors.white, // Text color (foreground)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Set border radius here
                      ),
                    ),
                    child: const Text("Other Groups"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(
                labelText: "Group Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Select Users to Add:",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      final userId = friend['_id'];
                      final username = friend['username'];
                      final firstName = friend['firstName'];
                      final lastName = friend['lastName'];
                      final fullName = '$firstName $lastName';
                      final initials = _getInitials(firstName, lastName);

                      return GestureDetector(
                        onTap: () => _toggleUserSelection(userId, username),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35.0,
                              backgroundImage:
                                  const AssetImage('images.user.png'),
                              backgroundColor: selectedFriends.contains(userId)
                                  ? Colors.blue
                                  : Colors.grey,
                              child: selectedFriends.contains(userId)
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : Text(
                                      initials,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fullName,
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            isMyGroups
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: myGroups.length,
                    itemBuilder: (context, index) {
                      final group = myGroups[index];
                      return ListTile(
                        title: Text(group['name']),
                        subtitle: Text("Members: ${group['members'].length}"),
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableGroups.length,
                    itemBuilder: (context, index) {
                      final group = availableGroups[index];
                      return ListTile(
                        title: Text(group['name']),
                        subtitle: Text("Members: ${group['members'].length}"),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            CustomButton(
              onTap: _createGroup,
              buttonText: _isLoading
                  ? "Creating the group, please wait ..."
                  : "Create Group",
              isLoading: _isLoading,
              color: _isLoading
                  ? const Color.fromARGB(255, 38, 34, 34)
                  : Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
