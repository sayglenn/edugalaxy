import 'package:firebase_auth/firebase_auth.dart';
import 'package:edugalaxy/pages/navbar.dart';
import 'package:edugalaxy/database_functions.dart';
import 'package:edugalaxy/local_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        bool user_exists = await DatabaseService.dataExists('Users', user.uid);
        print(user_exists);
        if (user_exists) {
          print(LocalCache.uid);
          // Map? user_data = await DatabaseService.readData('Users/${user.uid}');
          LocalCache.set_uid(user.uid);
          print(LocalCache.uid);
          await LocalCache.fetchAndCacheTasks();
        } else {
          LocalCache.set_uid(user.uid);
          String? user_name = user.displayName;
          String? user_email = user.email;
          await DatabaseService.updateData('Users/${user.uid}',
              {'username': user_name, 'email': user_email});
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavBar()),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 7, 5, 34),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/login_page.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "EduGalaxy",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 56.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 3,
                        color: Color.fromARGB(255, 255, 212, 212),
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    padding: EdgeInsets.all(20.0),
                  ),
                  onPressed: _signInWithGoogle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'lib/assets/google_logo.svg',
                        height: 24.0,
                        width: 24.0,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
