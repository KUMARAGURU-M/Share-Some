// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'Home_Recipient.dart';

class CustomPopup2 extends StatelessWidget {
  final VoidCallback onClose;

  const CustomPopup2({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        width: 400, // Keep width fixed if required
        // Removed fixed height to avoid overflow
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.1), // Subtle shadow to elevate popup
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        // Use SingleChildScrollView to avoid overflow in case of smaller screens
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              Image.asset(
                'assets/thumbs up 1.png', // Corrected asset path (no spaces)
                height: 200,
                width: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 15),
              Text(
                'Success! Your food donation is now Accepted.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF111213),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.2, // Adjusted line height for better spacing
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Thank you!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF111213),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.2, // Adjusted line height for better spacing
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFC8019),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

void showCustomPopup2(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Rounded corners for popup
        ),
        backgroundColor: Colors.transparent, // Make the background transparent
        child: CustomPopup2(
          onClose: () {
            Navigator.of(context).pop(); // Close the popup
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeRecipient(), // Navigate to HomeDonar after closing popup
              ),
            );
          },
        ),
      );
    },
  );
}
