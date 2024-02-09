import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackforgood24/pages/admin/admin_dashboard.dart';
import 'package:hackforgood24/pages/admin/admin_events.dart';
import 'package:hackforgood24/pages/admin/admin_profile.dart';
import 'package:hackforgood24/pages/admin/event_registration.dart';
import 'package:hackforgood24/pages/admin/events_database.dart';
import 'package:hackforgood24/pages/admin/events_management.dart';
import 'package:hackforgood24/pages/admin/skills_interests_management.dart';
import 'package:hackforgood24/pages/admin/volunteers_management.dart';
import 'package:hackforgood24/pages/login_page.dart';
import 'package:hackforgood24/pages/volunteer/volunteer_homepage.dart';
import 'package:hackforgood24/pages/volunteer/volunteer_event_dashboard.dart';
import 'package:hackforgood24/pages/volunteer/volunteer_onboarding.dart';
import 'package:hackforgood24/pages/volunteer/volunteer_profile.dart';
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
        OnboardingScreen.routeName: (ctx) => OnboardingScreen(),
        VolunteerHomePage.routeName: (ctx) => VolunteerHomePage(),
        VolunteerEventDashboard.routeName: (ctx) => VolunteerEventDashboard(),
        VolunteerProfile.routeName: (ctx) => VolunteerProfile(),
        AdminDashboard.routeName: (ctx) => AdminDashboard(),
        VolunteersManagement.routeName: (ctx) => VolunteersManagement(),
        EventsManagement.routeName: (ctx) => EventsManagement(),
        AdminProfile.routeName: (ctx) => AdminProfile(),
        AdminEvents.routeName: (ctx) => AdminEvents(),
        EventRegistration.routeName: (ctx) => EventRegistration(),
        EventDatabase.routeName: (ctx) => EventDatabase(),
        SkillsInterestsManagement.routeName: (ctx) =>
            SkillsInterestsManagement(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
