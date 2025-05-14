import 'package:flutter/material.dart';
import 'package:sharesome/Choose_Role.dart';
import 'package:sharesome/DHistory.dart';
import 'package:sharesome/Donor_select_Donation_Type.dart';
import 'package:sharesome/FoodRecognitionScreen.dart';
import 'package:sharesome/Home_Donar.dart';
import 'package:sharesome/Home_Recipient.dart';

import 'package:sharesome/Mobile_Login.dart';
import 'package:sharesome/OTP.dart';
import 'package:sharesome/Recipient_Select%20Request%20Type.dart';

import 'package:sharesome/Splash_page.dart';
import 'package:sharesome/donor_active_requests.dart';
import 'package:sharesome/donor_oldage_fund.dart';
import 'package:sharesome/donorpersonal.dart';
import 'package:sharesome/maps.dart';

import 'package:sharesome/onboarding1.dart';
import 'package:sharesome/onboarding2.dart';
import 'package:sharesome/onboarding3.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sharesome/recipientpersonal.dart';

import 'Home_NGO.dart';
import 'NGO_Confirmation.dart';
import 'Post_Donation.dart';
import 'Recipient_Request Food.dart';
import 'Resipient_avalable_food_donor.dart';
import 'donor_oldagehome_view.dart';
import 'donorpersonalinfo.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'food_item_details.dart';
import 'ngo_personal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //  initialRoute: '/', // Set the initial route to 'DonorPersonal'
        // routes: {
        //   '/': (context) => DonorPersonal(), // Set initial route to DonorPersonal
        //   '/donorPersonalInfo'+826+: (context) {
        //     final String? documentId = ModalRoute.of(context)?.settings.arguments as String?;
        //     return DonorPersonalInfo(documentId: documentId ?? ''); // Provide a default empty string if documentId is null},
        //     },}
        home: Page1(),
        // ...
        routes: {
          '/home': (context) => HomeDonar(),
          '/history': (context) => ImagePage(),
          '/donate': (context) => DonationTypeScreen(),
          '/maps': (context) => Maps(),
          //'/message': (context) => MessageScreen(),

          '/home1': (context) => HomeRecipient(),

          //'/history1': (context) =>),
          '/donate1': (context) => RequestTypeSelection(),
          '/maps1': (context) => Maps(),
          //'/message1': (context) => MessageScreen(
          // ...
        });
  }
}
