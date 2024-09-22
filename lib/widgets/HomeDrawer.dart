import 'package:flutter/material.dart';

import '../pages/Profile.dart';
import '../pages/statisticsPage.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Image.asset(
              'assets/images/pie-chart.png',
              width: 200,
            ),
          ),
          ListTile(
            title: const Text('Profile'),
            leading: Icon(Icons.person, color: Colors.blueAccent),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
          ),
          ListTile(
            title: const Text('Statistics'),
            leading: const Icon(Icons.bar_chart, color: Colors.deepOrange),
            onTap: () {
              // Handle Statistics tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatisticsPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings, color: Colors.green),
            onTap: () {
              // Handle Settings tap
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              // Handle Sign Out tap
            },
          ),
        ],
      ),
    );
  }
}
