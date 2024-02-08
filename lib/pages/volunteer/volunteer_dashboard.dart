import 'package:flutter/material.dart';
import 'package:hackforgood24/pages/admin/bottom_navigation_bar.dart';

class VolunteerDashboard extends StatefulWidget {
  static const routeName = '/volunteer_dashboard';

  @override
  State<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/volunteer_dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/volunteer_event_dashboard');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/volunteer_profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Volunteer Dashboard"),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.red[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Text(
                "Recommended Events",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  _buildCard("Card 1"),
                  SizedBox(width: 20),
                  _buildCard("Card 2"),
                  SizedBox(width: 20),
                  _buildCard("Card 3"),
                  SizedBox(width: 20),
                  // Add more cards as needed
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 20), // Adjust padding as needed
              child: Divider(
                color: Colors.white,
                thickness: 5, // Adjust thickness as needed
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Events',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Filter button pressed
                      },
                      icon: Icon(Icons.filter_list),
                      label: Text('Filter'),
                    ),
                  ),
                  SizedBox(width: 1), // Add spacing between buttons
                  Expanded(
                    child: ElevatedButton.icon(
                        onPressed: () {
                          // Sort button pressed
                        },
                        icon: Icon(Icons.sort),
                        label: Text('Sort')),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildCardList(["Event 1", "Event 2", "Event 3", "Event 4"]),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  Widget _buildCardList(List<String> titles) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 256,
          childAspectRatio: 0.5),
      itemCount: titles.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildCard(titles[index]);
      },
    );
  }

  Widget _buildCard(String title) {
    return Container(
      width: 200, // Width of each card
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 100, // Placeholder height for image
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Placeholder color for image
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "XX spots left", // Placeholder text
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Event Title", // Placeholder title
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.business), // Placeholder icon for organization
                SizedBox(width: 5),
                Text("Organisation"), // Placeholder text for organization
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.calendar_today), // Placeholder icon for date
                SizedBox(width: 5),
                Text("X/X/X"), // Placeholder text for date
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 5,
                children: [
                  _buildSkillChip("Skill 1"),
                  _buildSkillChip("Skill 2"),
                  _buildSkillChip("Skill 3"),
                  // Add more skill chips as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(skill), // Placeholder text for skill
      backgroundColor: Colors.white, // Placeholder color for skill chip
      labelStyle: TextStyle(color: Colors.black),
    );
  }
}
