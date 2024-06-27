import 'package:edugalaxy/database_functions.dart';
import 'package:edugalaxy/pages/login_page.dart';
import 'package:edugalaxy/pages/navbar.dart';
import 'package:edugalaxy/local_cache.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduGalaxy',
      home: AuthWrapper(), // Use the AuthWrapper as the home
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          final userId = snapshot.data?.uid;

          if (userId != null) {
            LocalCache.set_uid(userId);
            // Fetch and cache tasks before navigating to NavBar
            return FutureBuilder(
              future: LocalCache.fetchAndCacheTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading tasks'));
                }
                return NavBar();
              },
            );
          } else {
            return Center(child: Text('Error: User ID is null'));
          }
        } else {
          return LoginPage();
        }
      },
    );
  }
}
