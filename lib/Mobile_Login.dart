import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sharesome/OTP.dart';
import 'package:sharesome/Square_Tail.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController();
  String? completePhoneNumber; // Store complete phone number

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              _buildHeader(),
              const SizedBox(height: 13),
              Image.asset('assets/image 1.png'),
              const SizedBox(height: 13),
              _buildTagline(),
              const SizedBox(height: 34),
              _buildLoginDivider(),
              const SizedBox(height: 24),
              _buildPhoneNumberField(),
              const SizedBox(height: 7),
              _buildContinueButton(),
              const SizedBox(height: 24),
              _buildOrDivider(),
              const SizedBox(height: 18),
              _buildSocialButtons(),
              const SizedBox(height: 45),
              _buildFooterText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: const [
        Text(
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
        Text(
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
      ],
    );
  }

  Widget _buildTagline() {
    return Column(
      children: const [
        Text(
          "India’s #1 Food Redistribution",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'Play',
            color: Colors.black,
          ),
        ),
        Text(
          "and Management App",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'Play',
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Login or Sign up',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter-Regular',
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: IntlPhoneField(
        controller: phoneController,
        decoration: const InputDecoration(
          labelText: 'Enter Phone Number',
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
        initialCountryCode: 'IN',
        onChanged: (phone) {
          // Store the complete phone number (including the country code)
          completePhoneNumber = phone.completeNumber;
        },
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () async {
        if (completePhoneNumber != null && completePhoneNumber!.isNotEmpty) {
          try {
            await _auth.verifyPhoneNumber(
              phoneNumber: completePhoneNumber!, // Use complete phone number
              verificationCompleted: (PhoneAuthCredential credential) async {
                // Auto-retrieve the code or automatically sign the user in.
                await _auth.signInWithCredential(credential);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login successful!')),
                );
              },
              verificationFailed: (FirebaseAuthException e) {
                // Handle verification failure
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to verify phone number: ${e.message}')),
                );
              },
              codeSent: (String verificationId, int? resendToken) {
                // Navigate to the OTP page and pass the verification ID.
                Navigator.push(
                  context,
                  PageTransition(
                    child: OtpVerificationPage(
                      phoneNumber: completePhoneNumber!,
                      verificationId: verificationId,
                    ),
                    type: PageTransitionType.rightToLeft,
                  ),
                );
              },
              codeAutoRetrievalTimeout: (String verificationId) {
                // Handle auto-retrieval timeout.
              },
            );
          } catch (e) {
            print('Error: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('An error occurred. Please try again.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid phone number.')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFC8019),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(width: 1, color: Color(0xFFF97100)),
        ),
        minimumSize: const Size(340, 52),
      ),
      child: const Text(
        'Continue',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'or',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButtons() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SquareTile(imagePath: 'assets/google.png'),
        SizedBox(width: 20),
        SquareTile(imagePath: 'assets/fb.png'),
      ],
    );
  }

  Widget _buildFooterText() {
    return Column(
      children: const [
        Text(
          'By continuing, you agree to our Terms of Service',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF9AA2AB),
            fontSize: 10,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        Text(
          'Privacy Policy, Content Policy',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF9AA2AB),
            fontSize: 10,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ],
    );
  }
}
