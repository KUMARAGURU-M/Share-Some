// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sharesome/onboarding1.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    navigateToLogin();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 800.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {});
    });
    _controller?.forward();
  }

  navigateToLogin() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
      context,
      PageTransition(
        child: Onboarding1(),
        type: PageTransitionType.rightToLeft,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFFFC8019),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.5),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Splash animation behind the text
              Center(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: Container(
                    width: _animation?.value,
                    height: _animation?.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(255, 255, 255, 0.20),
                    ),
                  ),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hand logo
                  Image.asset(
                    'assets/hand logo.png',
                    height: 66.74,
                    width: 66.74,
                  ),
                  // SizedBox(height: 20),

                  Text(
                    'Share Some',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontFamily: 'Caveat',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  // SizedBox(height: 10),

                  Text(
                    'Towards Zero Food Waste',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}