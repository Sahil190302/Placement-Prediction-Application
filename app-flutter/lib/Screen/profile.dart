import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _collegeController = TextEditingController();
  String? _selectedBranch;
  String? _selectedYear;

  bool _isEditing = false;

  // Method to fetch user data from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;

      _nameController.text = data['name'] ?? '';
      _collegeController.text = data['college'] ?? '';
      _selectedBranch = data['branch'];
      _selectedYear = data['year'];
    }
  }

  // Method to update user data
  Future<void> _updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'college': _collegeController.text,
        'branch': _selectedBranch,
        'year': _selectedYear,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.green[800],
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),

            // College Name
            TextFormField(
              controller: _collegeController,
              enabled: _isEditing,
              decoration: InputDecoration(labelText: 'College Name'),
            ),
            SizedBox(height: 16),

            // Branch Dropdown
            DropdownButtonFormField<String>(
              value: _selectedBranch,
              onChanged: _isEditing ? (value) {
                setState(() {
                  _selectedBranch = value;
                });
              } : null,
              decoration: InputDecoration(labelText: 'Branch'),
              items: ['CSE', 'ECE', 'IT', 'AIDS', 'EE', 'ME', 'CE']
                  .map((branch) => DropdownMenuItem<String>(
                value: branch,
                child: Text(branch),
              ))
                  .toList(),
            ),
            SizedBox(height: 16),

            // Year Dropdown
            DropdownButtonFormField<String>(
              value: _selectedYear,
              onChanged: _isEditing ? (value) {
                setState(() {
                  _selectedYear = value;
                });
              } : null,
              decoration: InputDecoration(labelText: 'Year'),
              items: ['1st', '2nd', '3rd', '4th']
                  .map((year) => DropdownMenuItem<String>(
                value: year,
                child: Text(year),
              ))
                  .toList(),
            ),
            SizedBox(height: 16),

            // Update Button (Only visible if editing)
            _isEditing
                ? ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update Profile'),
            )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
