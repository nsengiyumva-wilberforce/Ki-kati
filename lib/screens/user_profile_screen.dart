import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Mock user data (replace with actual API or state management)
  final Map<String, dynamic> user = {
    "_id": "6733e770ef99b681bdfc4979",
    "username": "engdave",
    "firstName": "kinyonyi",
    "lastName": "david hope",
    "email": "kinyonyidavid@gmail.com",
    "gender": "Male",
    "dateOfBirth": DateTime.parse("2024-11-13T00:00:00.000Z"),
    "phoneNumber": "0787270058",
    "isEmailConfirmed": true,
    "groups": [
      "6733f51aef99b681bdfc49dd",
      "6733f676ef99b681bdfc49e9",
      "6733f6eeef99b681bdfc49ef",
      "6733f9e3ef99b681bdfc49fa"
    ],
  };

  // Controllers for the form fields
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _dateOfBirthController;
  String? _gender;

  // To manage whether the user is editing or viewing the profile
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    _usernameController = TextEditingController(text: user["username"]);
    _firstNameController = TextEditingController(text: user["firstName"]);
    _lastNameController = TextEditingController(text: user["lastName"]);
    _emailController = TextEditingController(text: user["email"]);
    _phoneNumberController = TextEditingController(text: user["phoneNumber"]);
    _dateOfBirthController = TextEditingController(
        text:
            "${user['dateOfBirth'].day}/${user['dateOfBirth'].month}/${user['dateOfBirth'].year}");
    _gender = user["gender"];
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  // Save function to handle saving of updated data (usually make an API call)
  void _saveProfile() {
    final updatedUserData = {
      "username": _usernameController.text,
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "email": _emailController.text,
      "phoneNumber": _phoneNumberController.text,
      "dateOfBirth": _dateOfBirthController.text,
      "gender": _gender,
    };

    // For demonstration purposes, print the updated user data
    print(updatedUserData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );

    // Toggle the editing mode back to view
    setState(() {
      isEditing = false;
    });
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime initialDate = user["dateOfBirth"];
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        _dateOfBirthController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Header with Avatar and User Info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(user["profilePicture"] ??
                        'https://via.placeholder.com/150'),
                    child: user["profilePicture"] == null
                        ? const Icon(
                            Icons.person,
                            size: 60.0,
                            color: Colors.white,
                          )
                        : null, // Default icon if no picture is available
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${user['firstName']} ${user['lastName']}",
                    style: const TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "@${user['username']}",
                    style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Username Field
            _buildProfileField("Username", _usernameController, isEditing),
            const SizedBox(height: 16),

            // First Name Field
            _buildProfileField("First Name", _firstNameController, isEditing),
            const SizedBox(height: 16),

            // Last Name Field
            _buildProfileField("Last Name", _lastNameController, isEditing),
            const SizedBox(height: 16),

            // Email Field
            _buildProfileField("Email", _emailController, isEditing),
            const SizedBox(height: 16),

            // Phone Number Field
            _buildProfileField(
                "Phone Number", _phoneNumberController, isEditing),
            const SizedBox(height: 16),

            // Date of Birth Field with Calendar
            _buildDateOfBirthField(isEditing),
            const SizedBox(height: 16),

            // Gender Field
            const Text(
              'Gender',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (isEditing)
              Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  const Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  const Text('Female'),
                  Radio<String>(
                    value: 'Others',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  const Text('Others'),
                ],
              )
            else
              Text(_gender ?? "Not specified"),

            const SizedBox(height: 20),

            // Toggle Edit Button or Save Button
            isEditing
                ? ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save Profile',
                        style: TextStyle(fontSize: 16)),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Edit Profile',
                        style: TextStyle(fontSize: 16)),
                  ),
          ],
        ),
      ),
    );
  }

  // Helper function to build either a text or text field based on editing mode
  Widget _buildProfileField(
      String label, TextEditingController controller, bool isEditing) {
    if (isEditing) {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            controller.text,
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider()
        ],
      );
    }
  }

  // Date of Birth Field with Calendar Button
  Widget _buildDateOfBirthField(bool isEditing) {
    if (isEditing) {
      return GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextField(
            controller: _dateOfBirthController,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Date of Birth', style: TextStyle(fontSize: 16.0)),
          Text(
            _dateOfBirthController.text,
            style: const TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
        ],
      );
    }
  }
}
