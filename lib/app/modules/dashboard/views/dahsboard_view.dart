import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Dashboard"), backgroundColor: Colors.white),
      body: Center(
        child: Text(
          "Ini adalah halaman Dashboard",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
