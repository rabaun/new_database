import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_database/screens/account_screen.dart';
import 'package:new_database/screens/login_screen.dart';
import 'package:new_database/screens/nav_drawer_screen.dart';
import 'package:new_database/screens/profil_list_screen.dart';
import 'package:new_database/screens/reset_password_screen.dart';
import 'package:new_database/screens/signup_screen.dart';
import 'package:new_database/screens/verify_email_screen.dart';
import 'package:new_database/services/firebase_streem.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      routes: {
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/account': (context) => const AccountScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
      },
      initialRoute: '/',
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Долговая книжка'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                if ((user == null)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountScreen()),
                  );
                }
              },
              icon: Icon(
                Icons.person,
                color: (user == null) ? Colors.white : Colors.yellow,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: (user == null)
                ? const Text("Контент для НЕ зарегистрированных в системе")
                : const ProfilesList(),
            //child: Text('Контент для НЕ зарегистрированных в системе'),
          ),
        ),
        drawer: NavDrawer());
  }
}
