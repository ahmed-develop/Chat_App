import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:my_chat_app/main.dart';

class Component extends StatefulWidget {
  final String email;
  final String password;

  Component({required this.email, required this.password});

  @override
  State<Component> createState() => _ComponentState();
}

class _ComponentState extends State<Component> {
  String imageUrl = 'https://example.com/profile-image.jpg';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _passionController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  Future<void> pickAndUploadImage() async {
  try {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected.')),
      );
      return;
    }

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceToUpload = FirebaseStorage.instance
        .ref()
        .child('Image/$uniqueFilename');

    await referenceToUpload.putFile(File(file.path));
    String downloadUrl = await referenceToUpload.getDownloadURL();

    setState(() {
      imageUrl = downloadUrl;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image uploaded successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error uploading image: $e')),
    );
    print("Error occurred while uploading image: $e");
  }
}

 Future<void> _signUp() async {
  // Check if any of the required fields are empty
  if (_nameController.text.trim().isEmpty ||
      _titleController.text.trim().isEmpty ||
      _descriptionController.text.trim().isEmpty) {
    // Show an error message if any required field is empty
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all the required fields (userName, userId, and Description).')),
    );
    return; // Stop the sign-up process if validation fails
  }

  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: widget.email,
      password: widget.password,
    );

    // Store user data in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
      'userName': _nameController.text.trim(),
      'userId': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'passion': _passionController.text.trim(),
      'nickname': _nicknameController.text.trim(),
      'imageUrl': imageUrl,
      'email': widget.email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Navigate to Chat List Screen
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ChatListScreen(),
    //   ),
    // );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to Sign Up: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Sign Up')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    onPressed: pickAndUploadImage,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'userName',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'userId',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passionController,
              decoration: InputDecoration(
                labelText: 'Passion',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: 'Nickname',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// User Info Screen
class UserInfoScreen extends StatelessWidget {
  final String? userId;

  UserInfoScreen({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Information')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User not found.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(userData['imageUrl']),
                ),
                SizedBox(height: 20),
                Text('userName: ${userData['userName']}'),
                Text('userId: ${userData['userId']}'),
                Text('Description: ${userData['description']}'),
                Text('Passion: ${userData['passion']}'),
                Text('Nickname: ${userData['nickname']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
