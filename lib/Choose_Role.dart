// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:sharesome/donorpersonal.dart';
import 'package:sharesome/ngo_personal.dart';
import 'package:sharesome/recipientpersonal.dart';
// Ensure this path is correct

class UserSelectionPage extends StatefulWidget {
  @override
  State<UserSelectionPage> createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  String _selectedOption =
      ''; // State variable to keep track of selected option

  void _onOptionSelected(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  void _onContinuePressed() {
    if (_selectedOption == 'Donor') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DonorPersonal()), // Adjust as needed
      );
    } else if (_selectedOption == 'NGO / Volunteer') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NgoPersonal()), // Adjust as needed
      );
    } else if (_selectedOption == 'Recipient') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipientPersonal()), // Adjust as needed
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an option')),
      );
    }
  }

  Widget _buildOptionContainer({
    required String title,
    required String subtitle,
    required String optionValue,
    required String assetPath,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => _onOptionSelected(optionValue),
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.55),
              side: BorderSide(
                color: _selectedOption == optionValue
                    ? Color(0xFFFC8019)
                    : Colors.transparent, // Orange border if selected
                width: 2.0,
              ),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x3F000000),
                spreadRadius: 0,
                blurRadius: 5.66,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFFC8019),
                child: Image.asset(assetPath),
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                  color: Color(0xFF9AA2AB),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/Layer 2.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Share Some',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFC8019),
                  fontSize: 48,
                  fontFamily: 'Caveat',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Text(
                'Towards Zero Food Waste',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 1),
              Image.asset(
                'assets/image 1.png', // Ensure the correct path and filename
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 21),
              const Text(
                'What describes you better?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              const SizedBox(height: 11),
              const Text(
                'Choose any one option from below',
                style: TextStyle(
                  color: Color(0xFF9AA2AB),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0.11,
                ),
              ),
              const SizedBox(height: 23),
              Column(
                children: [
                  _buildOptionContainer(
                    title: 'Donor',
                    subtitle: 'To donate to the needy',
                    optionValue: 'Donor',
                    assetPath: 'assets/Frame (6).png',
                  ),
                  _buildOptionContainer(
                    title: 'NGO / Volunteer',
                    subtitle: 'To support delivery and volunteer service',
                    optionValue: 'NGO / Volunteer',
                    assetPath: 'assets/Frame (6).png',
                  ),
                  _buildOptionContainer(
                    title: 'Recipient',
                    subtitle: 'Request for donation and receive donation',
                    optionValue: 'Recipient',
                    assetPath: 'assets/Frame (6).png',
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: ElevatedButton(
                  onPressed: _onContinuePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFC8019), // Orange color
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
