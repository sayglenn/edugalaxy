import 'package:edugalaxy/local_cache.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
    String? _username;
    String? _email; 
    File? _profileImage;
    final _formKey = GlobalKey<FormState>();

    @override
    void initState() {
        super.initState();
        Map<String, dynamic> userInfo = LocalCache.userInfo;
        if (userInfo != null) {
            _username = userInfo['username'];
            _email = userInfo['email'];
        }
        
    }

    Future<void> _pickImage() async {
        final ImagePicker _picker = ImagePicker();
        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

        setState(() {
        if (pickedFile != null) {
            _profileImage = File(pickedFile.path);
        } else {
            print('No image selected.');
        }
        });
    }

    Future<void> _saveProfile() async {
        if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        
        Map<String, dynamic> newUserInfo = {
            'username': _username,
            'email': _email,
        };

        await LocalCache.updateUserInfo(newUserInfo);
        print('Profile saved: $_username, $_email, $_profileImage');
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            title: Text('Edit Profile'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
            key: _formKey,
            child: ListView(
                children: [
                Center(
                    child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? Icon(Icons.add_a_photo, size: 50)
                            : null,
                    ),
                    ),
                ),
                SizedBox(height: 16),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Username'),
                    initialValue: _username,
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                    }
                    return null;
                    },
                    onSaved: (value) {
                    _username = value;
                    },
                ),
                SizedBox(height: 16),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    initialValue: _email,
                    readOnly: true,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                    onPressed: _saveProfile,
                    child: Text('Save'),
                ),
                ],
            ),
            ),
        ),
        );
    }
}
