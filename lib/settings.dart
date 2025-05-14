import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _isNotificationEnabled = true; // Manage the switch state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Profile Card
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                elevation: 0,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/Ellipse 9.png'), // Ensure this path is correct
                    radius: 25,
                  ),
                  title: const Text(
                    'Kumaraguru',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  subtitle: const Text(
                    'Hotel Saravana Bhavan',
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
                        'assets/edit.png', // Replace this with your image asset path
                        // Adjust the width as needed
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // General Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'GENERAL'),
                    const SettingsTile(
                      assetPath:
                          'assets/language.svg', // Replace with your asset path
                      title: 'Language',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.orange,
                      ),
                    ),
                    const Divider(height: 0),
                    SettingsTile(
                      assetPath:
                          'assets/noti.svg', // Replace with your asset path
                      title: 'Notification',
                      trailing: Transform.scale(
                        scale: 0.6, // Adjust the scale factor as needed
                        child: Switch(
                          value: _isNotificationEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              _isNotificationEnabled = value;
                            });
                          },
                          activeColor: Colors.white, // Thumb color when ON
                          activeTrackColor: Colors.orange
                              .withOpacity(0.5), // Track color when ON
                          inactiveThumbColor:
                              Colors.white, // Thumb color when OFF
                          inactiveTrackColor: Colors.grey
                              .withOpacity(0.5), // Track color when OFF
                        ),
                      ),
                    ),
                    const Divider(height: 0),
                    const SettingsTile(
                      assetPath:
                          'assets/impact.svg', // Replace with your asset path
                      title: 'My Impact',
                    ),
                    const Divider(height: 0),
                    const SettingsTile(
                      assetPath:
                          'assets/invite.svg', // Replace with your asset path
                      title: 'Invite Friends',
                    ),
                    const SectionHeader(title: 'MORE'),
                    const SettingsTile(
                      assetPath:
                          'assets/rating.svg', // Replace with your asset path
                      title: 'Rating & Feedback',
                    ),
                    const Divider(height: 0),
                    const SettingsTile(
                      assetPath:
                          'assets/about.svg', // Replace with your asset path
                      title: 'About',
                    ),
                    const Divider(height: 0),
                    const SettingsTile(
                      assetPath:
                          'assets/bug.svg', // Replace with your asset path
                      title: 'Report a bug',
                    ),
                    const SectionHeader(title: 'PRIVACY & SUPPORT'),
                    const SettingsTile(
                      assetPath:
                          'assets/privacy.svg', // Replace with your asset path
                      title: 'Privacy & Security',
                    ),
                    const Divider(height: 0),
                    const SettingsTile(
                      assetPath:
                          'assets/contact.svg', // Replace with your asset path
                      title: 'Contact Support',
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                        context, '/home'); // Navigate to the Home screen
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
                          'assets/homegrey.svg',
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
                        '/donate'); // Navigate to the Donate Now screen
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
                        'Donate Now',
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
          )),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final String assetPath;

  const SettingsTile({
    Key? key,
    required this.assetPath,
    required this.title,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
      leading: SvgPicture.asset(
        assetPath,
        width: 24,
        height: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
            color: Colors.orange,
          ),
      onTap: () {
        // Define the navigation to the corresponding page here
      },
    );
  }
}
