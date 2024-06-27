import 'package:edugalaxy/local_cache.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? _username;
  String? _email;
  String? _profilePicUrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Map? userInfo = LocalCache.userInfo;
    if (userInfo != null) {
      _username = userInfo['username'];
      _email = userInfo['email'];
      _profilePicUrl = userInfo['profilePicUrl'];
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        
        Map<String, dynamic> newUserInfo = {
            'username': _username,
            'email': _email,
            'profilePicUrl': _profilePicUrl
        };

        await LocalCache.updateUserInfo(newUserInfo);
        print('Profile saved: $_username, $_email, $_profilePicUrl');
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
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profilePicUrl != null
                      ? NetworkImage(_profilePicUrl!)
                      : null,
                  child: _profilePicUrl == null
                      ? Icon(Icons.account_circle, size: 50)
                      : null,
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
