import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sharesome/onboarding3.dart';

class Onboarding2 extends StatefulWidget {
  const Onboarding2({super.key});

  @override
  State<Onboarding2> createState() => _Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Share Some',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFC8019),
                      fontSize: 48,
                      fontFamily: 'Caveat',
                      fontWeight: FontWeight.w400,
                      height: 0,
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
                      height: 0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/food donation 2.png', // Replace with your image path
                    // width: MediaQuery.of(context)
                    //     .size
                    //     .width, // Set width to full screen
                    fit: BoxFit.cover, // Cover the available space
                  ),
                  Image.asset(
                    'assets/Group 15.png', // Replace with your image path
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set width to full screen// Cover the available space
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'NGO Co-ordination',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'Play',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  const SizedBox(height: 13),
                  const Text(
                    'Aims to streamline the process of surplus food',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF99A2AA),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    'redistribution, ensuring that excess food',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF99A2AA),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    'reaches those who need it most.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF99A2AA),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 31, right: 31, bottom: 59),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Implement Skip functionality
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFFFC8019),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: Onboarding3(),
                        type: PageTransitionType.rightToLeft,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFC8019),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
