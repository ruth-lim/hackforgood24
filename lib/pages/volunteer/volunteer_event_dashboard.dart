import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackforgood24/pages/volunteer/volunteer_bottom_navigation_bar.dart';
import 'package:hackforgood24/pages/volunteer/certificate_request.dart'; // Import the CertificateRequestForm widget

class VolunteerEventDashboard extends StatefulWidget {
  static const routeName = '/volunteer_event_dashboard';

  @override
  _VolunteerEventDashboardState createState() =>
      _VolunteerEventDashboardState();
}

class _VolunteerEventDashboardState extends State<VolunteerEventDashboard> {
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/volunteer_homepage');
        break;
      case 1:
        // No need to navigate if already on the same page
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/volunteer_profile');
        break;
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double hoursClocked = 1.092; // Example hours clocked
  double goalHours = 100; // Goal is 100 hours

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Event Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedProgressCard(
              hoursClocked: hoursClocked,
              goalHours: goalHours,
            ),
            SizedBox(height: 16), // Add some space between the cards
            SizedBox(
              height: 200, // Set the height of the card
              child: EventCard(
                title: 'Upcoming Events',
                color: Colors.red[100]!,
              ),
            ),
            SizedBox(height: 16), // Add some space between the cards
            SizedBox(
              height: 200, // Set the height of the card
              child: EventCard(
                title: "Past events",
                color: Colors.red[100]!,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}

class AnimatedProgressCard extends StatefulWidget {
  final double hoursClocked;
  final double goalHours;

  const AnimatedProgressCard({
    Key? key,
    required this.hoursClocked,
    required this.goalHours,
  }) : super(key: key);

  @override
  _AnimatedProgressCardState createState() => _AnimatedProgressCardState();
}

class _AnimatedProgressCardState extends State<AnimatedProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.hoursClocked / widget.goalHours,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the animation when the widget updates
    if (oldWidget.hoursClocked != widget.hoursClocked) {
      _animation = Tween<double>(
        begin: 0.0,
        end: widget.hoursClocked / widget.goalHours,
      ).animate(_controller);
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hoursLeft = widget.goalHours - widget.hoursClocked;

    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You're off to a great start!",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8.0),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                var profilePictureURL =
                    snapshot.data!['profilePictureURL'] ?? '';
                return CircleAvatar(
                  radius: 40,
                  backgroundImage: profilePictureURL.isNotEmpty
                      ? NetworkImage(profilePictureURL)
                      : AssetImage('assets/images/bigatheartavatar.jpg')
                          as ImageProvider,
                );
              },
            ),
            SizedBox(height: 8.0),
            Text(
              'Hours left to defeat ${hoursLeft.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: _animation.value,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
            SizedBox(height: 8.0),
            Text(
              '${widget.hoursClocked.toStringAsFixed(1)} hours clocked',
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(height: 16.0), // Add space between progress bar and button
            ElevatedButton(
              onPressed: () {
                // Navigate to the certificate request form
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CertificateRequestForm(),
                  ),
                );
              },
              child: Text('Request Certificate'),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final Color color;

  const EventCard({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.all(16.0),
      child: SizedBox(
        height: double.infinity,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Volunteer Event Dashboard Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: VolunteerEventDashboard(),
  ));
}
