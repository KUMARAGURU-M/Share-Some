// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharesome/Post_Donation.dart';
import 'package:sharesome/Recipient_Select%20Request%20Type.dart';
import 'package:sharesome/Resipient_avalable_food_donor.dart';
import 'package:sharesome/card.dart';
import 'package:sharesome/card1.dart';
import 'package:sharesome/donor_oldage_fund.dart';
import 'package:sharesome/donor_oldagehome_view.dart';
import 'package:sharesome/header.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeRecipient extends StatefulWidget {
  const HomeRecipient({super.key});

  @override
  State<HomeRecipient> createState() => _HomeRecipientState();
}

class _HomeRecipientState extends State<HomeRecipient> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNotificationEnabled = true;
  String recipientFirstName = '';
  String organizationName = '';

  @override
  void initState() {
    super.initState();
    _fetchRecipientData();
  }

  Future<void> _fetchRecipientData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      try {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('recipient')
            .doc(uid)
            .get();

        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          setState(() {
            recipientFirstName = data['First'] ?? '';
            organizationName = data['Organization Name'] ?? '';
          });
        }
      } catch (e) {
        print('Error fetching donor data: $e');
      }
    }
  }

  // Function to return the drawer widget
  Drawer buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color to white
            ),
            accountName: Text(
              recipientFirstName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            accountEmail: Text(
              organizationName,
              style: TextStyle(
                color: Color(0xFF9AA2AB),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/Profile_resipi.png'),
            ),
          ),
          // Use Expanded to ensure the ListView takes the remaining available space
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Image.asset(
                    'assets/profile.png', // Replace with your image path
                    width: 24,
                    height: 24,
                  ),
                  title: const Text('Your Profile'),
                  onTap: () {
                    // Action for Profile
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/plant_nature_flower.png', // Replace with your image path
                    width: 24,
                    height: 24,
                  ),
                  title: const Text('Past Donation'),
                  onTap: () {
                    // Action for Past Donations
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/bell.png', // Replace with your image path
                    width: 24,
                    height: 24,
                  ),
                  title: const Text('Notification'),
                  trailing: Transform.scale(
                    scale: 0.6, // Adjust the scale to make the switch smaller
                    child: Switch(
                      value:
                          _isNotificationEnabled, // Set this according to your app's logic
                      onChanged: (bool value) {
                        setState(() {
                          _isNotificationEnabled = value;
                        });
                      },
                      activeTrackColor:
                          Colors.orange.withOpacity(0.5), // Track color when ON
                      inactiveThumbColor: Colors.grey, // Thumb color when OFF
                      inactiveTrackColor: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
                Divider(
                  color: Color(0x339AA2AB), // Add color to the divider here
                  thickness: 1.0, // Optional: customize thickness
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/privacy.png', // Replace with your image path
                    width: 24,
                    height: 24,
                  ),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    // Action for Privacy Policy
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/about.png', // Replace with your image path
                    width: 24,
                    height: 24,
                  ),
                  title: const Text('About'),
                  onTap: () {
                    // Action for About
                  },
                ),
                SizedBox(height: 291),
                Divider(
                  color: Color(0x339AA2AB), // Add color to the divider here
                  thickness: 1.5, // Optional: customize thickness
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/settingsD.png', // Replace with your image path
                    width: 24,
                    height: 24,
                  ),
                  title: const Text('Settings'),
                  trailing: Icon(
                    Icons.chevron_right, // Greater than symbol
                    color: Colors.orange, // Set the color to orange
                  ),
                  onTap: () {
                    // Action for Settings
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: buildDrawer(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User Profile Card
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 0,
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          // Open the drawer programmatically when tapped
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: const CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/Profile_resipi.png'), // Ensure this path is correct
                          radius: 25,
                        ),
                      ),
                      title: Text(
                        recipientFirstName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      subtitle: Text(
                        organizationName,
                        style: TextStyle(
                          color: Color(0xFF9AA2AB),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      trailing: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            'assets/Frame (4).png', // Replace this with your image asset path
                            // Adjust the width as needed
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 18), // Space between profile card and search bar
                // Search Bar Container
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    height: 33,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFF9AA2AB)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Image.asset(
                            'assets/Frame (5).png',
                            height: 17,
                            width: 17,
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search for Donor',
                                hintStyle: TextStyle(
                                  color: Color(0xFF9AA2AB),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 359,
                    height: 125,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7FC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        // Image aligned to the right and overflowing
                        Align(
                          alignment: Alignment.centerRight,
                          child: OverflowBox(
                            alignment: Alignment.centerRight,
                            maxWidth: double.infinity,
                            maxHeight: double.infinity,
                            child: Container(
                              width: 184,
                              height: 184,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/image3.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title Text
                              const Text(
                                'End Starvation Struggles',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 7),
                              // Subtitle Text
                              const SizedBox(
                                width: 152,
                                child: Text(
                                  'Quickly improve, increase and solve urgent food shortages and problems.',
                                  style: TextStyle(
                                    color: Color(0xFF9AA2AB),
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              // Button
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RequestTypeSelection(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  height: 24,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFC8019),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Request Food',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Explore food requests" and "See all" Row
                      SectionHeader(title: 'Explore food donors'),
                      const SizedBox(height: 15),
                      // First row of cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RecipientAvailableFoodDonor()),
                                );
                              },
                              child: FoodRequestCard1(),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Space between the containers
                        ],
                      ),
                      const SizedBox(height: 15),
                      // "NGO’s near you" and "See all" Row
                      SectionHeader(title: 'NGO’s near you'),
                      const SizedBox(height: 15),
                      // Second row of cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RecipientAvailableFoodDonor()),
                                );
                              },
                              child: FoodRequestCard1(),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Space between the containers
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    height:
                        10), // Space between search bar and bottom navigation
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 74,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x1E000000),
                blurRadius: 4,
                offset: Offset(0, -2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Home
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/home1'); // Navigate to the Home screen
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 37,
                        height: 37,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: SvgPicture.asset(
                          'assets/home.svg',
                          height: 10,
                          width: 20,
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // My Donation
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/history'); // Navigate to the History screen
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 39.55,
                        height: 39.55,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: SvgPicture.asset(
                          'assets/history.svg',
                          height: 10,
                          width: 20,
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        'History',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Donate Now
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context,
                        '/donate1'); // Navigate to the Donate Now screen
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 39.55,
                        height: 39.55,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: SvgPicture.asset(
                          'assets/donatenow.svg',
                          height: 10,
                          width: 20,
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        'Request Now',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Favorites
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/maps'); // Navigate to the Maps screen
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 39.55,
                        height: 39.55,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: SvgPicture.asset(
                          'assets/maps.svg',
                          height: 10,
                          width: 20,
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        'Maps',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Account
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/message'); // Navigate to the Message screen
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 39.55,
                        height: 39.55,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: SvgPicture.asset(
                          'assets/message.svg',
                          height: 10,
                          width: 20,
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        'Message',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF4A4A4A),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipientAvailableFoodDonor()),
            );
          },
          child: const Text(
            'See all',
            style: TextStyle(
              color: Color(0xFFFC8019),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
