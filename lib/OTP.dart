import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sharesome/Choose_Role.dart'; // Import FirebaseAuth for OTP verification

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId; // Add verificationId parameter here

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.verificationId, // Include it in the constructor
  });

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // List of TextEditingControllers for each TextField
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  // List of FocusNodes for each TextField
  final List<FocusNode> _focusNodes = List.generate(7, (index) => FocusNode());

  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Initialize FirebaseAuth instance

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 6) {
      // Move focus to the next text field if not the last field
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 6) {
      // Move focus to the previous text field if the current field is empty
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  Future<void> _verifyOtp() async {
    String otp = _controllers.map((controller) => controller.text).join();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, // Use widget.verificationId
        smsCode: otp,
      );

      // Sign in using the OTP
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // OTP verified successfully, navigate to the next page or show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP Verified Successfully!')),
        );
        // Add your navigation logic here
        // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {
      // Handle errors (e.g., invalid OTP)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use an Image as a back button
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
            children: [
              const SizedBox(height: 0.2),
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
              const SizedBox(height: 2),
              Image.asset(
                'assets/image 1.png',
                fit: BoxFit.cover, // Added to ensure the image fits well
              ),
              const SizedBox(height: 13),
              const Text(
                "India’s #1 Food Redistribution",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Play',
                  color: Colors.black,
                ),
              ),
              const Text(
                "and Management App",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Play',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 55),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'OTP Verification',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter the One-Time Password sent via SMS to ${widget.phoneNumber}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Flexible(
                    child: Container(
                      width: 51,
                      height: 51,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 6,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: index < 5 ? _focusNodes[index] : null,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) => _onOtpChanged(value, index),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 24), // Added to improve visibility
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Haven’t received the OTP?',
                    style: TextStyle(
                      color: Color(0xFF9AA2AB),
                      fontSize: 12.0,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Add code to resend OTP
                    },
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                        color: Color(0xFFFC8019),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 110),
              ElevatedButton(
                onPressed: () {
                  _verifyOtp();
                  Text('OTP verified'); // This is incorrect
                  Navigator.push(
                    context,
                    PageTransition(
                      child: UserSelectionPage(),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFC8019),
                  minimumSize: Size(double.infinity, 55),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 69, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadowColor: const Color(0x3F000000),
                  elevation: 4,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Text(
                'By continuing, you agree to our Terms of Service',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9AA2AB),
                  fontSize: 11,
                ),
              ),
              const Text(
                'and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9AA2AB),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
