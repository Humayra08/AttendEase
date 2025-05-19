import 'package:flutter/material.dart';
import 'profile_controller.dart';
import 'loginScreen.dart';

class ProfileScreen extends StatefulWidget {
  final String employeeId;
  const ProfileScreen({Key? key, required this.employeeId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = ProfileController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isDataLoaded = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    var employeeData = await _profileController.getProfileData(widget.employeeId);
    if (employeeData != null) {
      setState(() {
        firstNameController.text = employeeData['firstName'];
        lastNameController.text = employeeData['lastName'];
        dobController.text = employeeData['dob'];
        addressController.text = employeeData['address'];
        emailController.text = employeeData['email'];
        phoneController.text = employeeData['phone'];
        _isDataLoaded = true;
      });
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 100,
            child: Center(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  void saveProfile() async {
    bool success = await _profileController.saveProfileData(
      widget.employeeId,
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      dobController.text.trim(),
      addressController.text.trim(),
      emailController.text.trim(),
      phoneController.text.trim(),
      '',
    );

    if (success) {
      _showDialog('Profile saved successfully');
      setState(() {
        _isEditing = false;
      });
    } else {
      _showDialog('Failed to save profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(222, 245, 229, 0.8),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(158, 213, 197, 1),
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Added space before the profile picture icon
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Employee ID: ${widget.employeeId}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            if (_isDataLoaded) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32), // Increased padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
                  ],
                ),
                child: _isEditing
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: dobController,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: ElevatedButton(
                        onPressed: saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(158, 213, 197, 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Save',
                            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('First Name: ${firstNameController.text}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Last Name: ${lastNameController.text}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Date of Birth: ${dobController.text}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Address: ${addressController.text}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Email: ${emailController.text}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Phone: ${phoneController.text}', style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ] else
              const Center(child: CircularProgressIndicator()),
            if (!_isEditing)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(158, 213, 197, 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Logout',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}