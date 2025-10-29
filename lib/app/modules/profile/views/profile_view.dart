import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Profile"), backgroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: Colors.grey),
            SizedBox(height: 10),
            Text("Nama: Damai Putra Yudha", style: TextStyle(fontSize: 18)),
            Text("Posisi: Software Engineer", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
