import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackforgood24/pages/admin/admin_dashboard.dart';
import 'package:hackforgood24/pages/admin/admin_events.dart';
import 'package:hackforgood24/pages/admin/admin_profile.dart';
import 'package:hackforgood24/pages/admin/admin_report_generation.dart';
import 'package:hackforgood24/pages/admin/event_registration.dart';
import 'package:hackforgood24/pages/admin/events_database.dart';
import 'package:hackforgood24/pages/admin/events_management.dart';
import 'package:hackforgood24/pages/admin/reports/activity_participation.dart';
import 'package:hackforgood24/pages/admin/reports/attendance_time_tracking.dart';
import 'package:hackforgood24/pages/admin/reports/certificate_request.dart';
import 'package:hackforgood24/pages/admin/reports/feedback.dart';
import 'package:hackforgood24/pages/admin/reports/financial.dart';
import 'package:hackforgood24/pages/admin/reports/impact_outcome.dart';
import 'package:hackforgood24/pages/admin/reports/performance_efficiency.dart';
import 'package:hackforgood24/pages/admin/reports/volunteer_enrollment.dart';
import 'package:hackforgood24/pages/admin/reports/volunteer_recognition.dart';
import 'package:hackforgood24/pages/admin/skills_interests_management.dart';
import 'package:hackforgood24/pages/admin/volunteers_management.dart';
import 'package:hackforgood24/pages/login_page.dart';
import 'package:hackforgood24/pages/volunteer/volunteer_dashboard.dart';
import 'package:hackforgood24/pages/volunteer/volunteer_event_dashboard.dart';
import 'package:hackforgood24/pages/volunteer/volunteer_onboarding.dart';
import 'package:hackforgood24/pages/volunteer/volunteer_profile.dart';
import 'pages/signup_page.dart';
import 'package:hackforgood24/pages/admin/reports/volunteer_enrollment.dart';

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
        VolunteerDashboard.routeName: (ctx) => VolunteerDashboard(),
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
        AdminReport.routeName: (ctx) => AdminReport(),
        VolunteerEnrollmentPage.routeName: (ctx) =>
            VolunteerEnrollmentPage(), // Add this line
        ActivityParticipationReportPage.routeName: (ctx) =>
            ActivityParticipationReportPage(),
        AttendanceTimeTrackingReportPage.routeName: (ctx) =>
            AttendanceTimeTrackingReportPage(),
        CertificateRequestReportPage.routeName: (ctx) =>
            CertificateRequestReportPage(),
        FeedbackEvaluationReportPage.routeName: (ctx) =>
            FeedbackEvaluationReportPage(),
        ImpactAndOutcomesReportPage.routeName: (ctx) =>
            ImpactAndOutcomesReportPage(),
        FinancialReportPage.routeName: (ctx) => FinancialReportPage(),
        PerformanceEfficiencyReportPage.routeName: (ctx) =>
            PerformanceEfficiencyReportPage(),
        VolunteerRecognitionPage.routeName: (ctx) => VolunteerRecognitionPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
