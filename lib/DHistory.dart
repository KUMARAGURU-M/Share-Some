import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "My Donations",
          style: TextStyle(fontFamily: 'Inter', fontSize: 20),
        ),
        backgroundColor: const Color(0xFFFFFFFF), // Orange theme
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/DHistory.png', // Replace with your image
            fit: BoxFit.cover,
            width: screenWidth, // Set width to screen width
          ),
        ],
      ),
    );
  }
}
