import 'package:cema_mobile/app/modules/dashboard/views/dahsboard_view.dart';
import 'package:cema_mobile/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [DashboardPage(), ProfilePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 41, 37, 37),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomNavButton(
              icon: Icons.home,
              label: "Dashboard",
              isSelected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            CustomNavButton(
              icon: Icons.stacked_bar_chart,
              label: "Project",
              isSelected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            CustomNavButton(
              icon: Icons.person,
              label: "Profile",
              isSelected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
    );
  }
}
