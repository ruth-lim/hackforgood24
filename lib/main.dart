import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackforgood24/pages/admin_dashboard.dart';
import 'package:hackforgood24/pages/login_page.dart';
import 'package:hackforgood24/pages/volunteer_dashboard.dart';
import 'pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        SignUpScreen.routeName: (ctx) => SignUpScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        VolunteerDashboard.routeName: (ctx) => VolunteerDashboard(),
        AdminDashboard.routeName: (ctx) => AdminDashboard(),
      },
    );
  }
}
