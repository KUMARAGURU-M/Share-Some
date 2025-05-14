import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'NGO_Confirmation.dart';

class HomeNGO extends StatefulWidget {
  const HomeNGO({Key? key}) : super(key: key);

  @override
  State<HomeNGO> createState() => _HomeNGOState();
}

class _HomeNGOState extends State<HomeNGO> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNotificationEnabled = true;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Dynamic data variables
  String NGOname = "Sharath";
  String businessName = "NGO";
  String hotelName = "";
  String distance = "2Km";
  String hotelAddress = "";
  String receiverAddress = "";
  String pickupDateTime = "";

  @override
  void initState() {
    super.initState();
    _fetchNGODetails();
    _fetchDonationData();
    _fetchRecipientRequestData();
  }

  // Fetch NGO details (logged-in user)
  Future<void> _fetchNGODetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      try {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('NGO login')
            .doc(uid)
            .get();

        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          setState(() {
            // NGOname = data['firsr'] ?? '';
            // businessName = data['Name of business'] ?? '';
          });
        }
      } catch (e) {
        print('Error fetching donor data: $e');
      }
    }
  }

  // Fetch donation data from Firestore
  Future<void> _fetchDonationData() async {
    final QuerySnapshot donationSnapshot =
        await _firestore.collection('Donation').get();
    if (donationSnapshot.docs.isNotEmpty) {
      final doc = donationSnapshot.docs.first;
      setState(() {
        hotelName = doc['Business Name']; // Ensure field name matches Firestore
        hotelAddress = doc['Location']; // Ensure field name matches Firestore
        pickupDateTime = doc['Time']; // Ensure field name matches Firestore
      });
    }
  }

  // Fetch recipient request data from Firestore
  Future<void> _fetchRecipientRequestData() async {
    final QuerySnapshot recipientSnapshot =
        await _firestore.collection('Recipient Request').get();
    if (recipientSnapshot.docs.isNotEmpty) {
      final doc = recipientSnapshot.docs.first;
      setState(() {
        receiverAddress =
            doc['location']; // Ensure field name matches Firestore
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      drawer: buildDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileHeader(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildBanner(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildDonationCards(),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: 74,
      //   padding: const EdgeInsets.symmetric(horizontal: 10),
      //   decoration: const BoxDecoration(
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Color(0x1E000000),
      //         blurRadius: 4,
      //         offset: Offset(0, -2),
      //         spreadRadius: 0,
      //       ),
      //     ],
      //   ),
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       // Home
      //       Expanded(
      //         child: GestureDetector(
      //           onTap: () {
      //             Navigator.pushNamed(context, '/home');
      //           },
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Container(
      //                 width: 37,
      //                 height: 37,
      //                 clipBehavior: Clip.antiAlias,
      //                 decoration: const BoxDecoration(),
      //                 child: SvgPicture.asset(
      //                   'assets/home.svg',
      //                   height: 10,
      //                   width: 20,
      //                 ),
      //               ),
      //               const SizedBox(height: 1),
      //               const Text(
      //                 'Home',
      //                 style: TextStyle(
      //                   color: Colors.black,
      //                   fontSize: 10,
      //                   fontFamily: 'Inter',
      //                   fontWeight: FontWeight.w400,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       // My Donation
      //       Expanded(
      //         child: GestureDetector(
      //           onTap: () {
      //             Navigator.pushNamed(context, '/history');
      //           },
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Container(
      //                 width: 39.55,
      //                 height: 39.55,
      //                 clipBehavior: Clip.antiAlias,
      //                 decoration: const BoxDecoration(),
      //                 child: SvgPicture.asset(
      //                   'assets/history.svg',
      //                   height: 10,
      //                   width: 20,
      //                 ),
      //               ),
      //               const SizedBox(height: 1),
      //               const Text(
      //                 'History',
      //                 style: TextStyle(
      //                   color: Colors.black,
      //                   fontSize: 10,
      //                   fontFamily: 'Inter',
      //                   fontWeight: FontWeight.w400,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       // Donate Now
      //       Expanded(
      //         child: GestureDetector(
      //           onTap: () {
      //             Navigator.pushNamed(context, '/donate');
      //           },
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Container(
      //                 width: 39.55,
      //                 height: 39.55,
      //                 clipBehavior: Clip.antiAlias,
      //                 decoration: const BoxDecoration(),
      //                 child: SvgPicture.asset(
      //                   'assets/donatenow.svg',
      //                   height: 10,
      //                   width: 20,
      //                 ),
      //               ),
      //               const SizedBox(height: 1),
      //               const Text(
      //                 'Donate Now',
      //                 style: TextStyle(
      //                   color: Colors.black,
      //                   fontSize: 10,
      //                   fontFamily: 'Inter',
      //                   fontWeight: FontWeight.w400,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       // Maps
      //       Expanded(
      //         child: GestureDetector(
      //           onTap: () {
      //             Navigator.pushNamed(context, '/maps');
      //           },
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Container(
      //                 width: 39.55,
      //                 height: 39.55,
      //                 clipBehavior: Clip.antiAlias,
      //                 decoration: const BoxDecoration(),
      //                 child: SvgPicture.asset(
      //                   'assets/maps.svg',
      //                   height: 10,
      //                   width: 20,
      //                 ),
      //               ),
      //               const SizedBox(height: 1),
      //               const Text(
      //                 'Maps',
      //                 style: TextStyle(
      //                   color: Colors.black,
      //                   fontSize: 10,
      //                   fontFamily: 'Inter',
      //                   fontWeight: FontWeight.w400,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       // Message
      //       Expanded(
      //         child: GestureDetector(
      //           onTap: () {
      //             Navigator.pushNamed(context, '/message');
      //           },
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Container(
      //                 width: 39.55,
      //                 height: 39.55,
      //                 clipBehavior: Clip.antiAlias,
      //                 decoration: const BoxDecoration(),
      //                 child: SvgPicture.asset(
      //                   'assets/message.svg',
      //                   height: 10,
      //                   width: 20,
      //                 ),
      //               ),
      //               const SizedBox(height: 1),
      //               const Text(
      //                 'Message',
      //                 style: TextStyle(
      //                   color: Colors.black,
      //                   fontSize: 10,
      //                   fontFamily: 'Inter',
      //                   fontWeight: FontWeight.w400,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/Ellipse 9.png'),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NGOname,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    businessName,
                    style: const TextStyle(
                      color: Color(0xFF9AA2AB),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/bell_notification.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 125,
      decoration: BoxDecoration(
        color: Colors.white,
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
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 15, 18, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Text
                Text(
                  'End Starvation Struggles',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 7),
                // Subtitle Text
                SizedBox(
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationCards() {
    return Column(
      children: [
        _buildDonationCard(
          isExpanded: true,
          onHoldTap: () {
            // Handle hold pickup button tap
          },
          onDeliveryTap: () {
            // Handle delivery button tap
          },
        ),
        // const SizedBox(height: 16),
        // _buildDonationCard(
        //   isExpanded: true,
        //   onHoldTap: () {
        //     // Handle hold pickup button tap
        //   },
        //   onDeliveryTap: () {
        //     // Handle delivery button tap
        //   },
        //   showDestination: true,
        // ),
      ],
    );
  }

  Widget _buildDonationCard({
    required bool isExpanded,
    bool showDestination = true,
    VoidCallback? onHoldTap,
    VoidCallback? onDeliveryTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/image3.png', // Replace with your actual image
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotelName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                _buildAddressRow(
                  icon: Icons.circle,
                  iconColor: Colors.orange,
                  text: hotelAddress,
                ),
                if (showDestination) ...[
                  const SizedBox(height: 16),
                  _buildAddressRow(
                    icon: Icons.location_on,
                    iconColor: Colors.orange,
                    text: receiverAddress,
                  ),
                ],
                const SizedBox(height: 16),
                _buildPickupTimeRow(),
                if (isExpanded) ...[
                  const SizedBox(height: 16),
                  _buildActionButtons(
                    onHoldTap: onHoldTap,
                    onDeliveryTap: onDeliveryTap,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressRow({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPickupTimeRow() {
    return Row(
      children: [
        const Text(
          'Pick-up Time: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        Expanded(
          child: Text(
            pickupDateTime,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons({
    VoidCallback? onHoldTap,
    VoidCallback? onDeliveryTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onHoldTap,
            icon: const Icon(Icons.delivery_dining),
            label: const Text('Hold Pickup'),
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xFFFC8019),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Color(0xFFFC8019),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NGOConfirmation()),
              );
            },
            icon: const Icon(Icons.delivery_dining),
            label: const Text('Pickup Delivery'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFFFC8019),
              padding: const EdgeInsets.symmetric(vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white, // Set the background color to white
            ),
            accountName: Text(
              NGOname,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            accountEmail: Text(
              businessName,
              style: const TextStyle(
                color: Color(0xFF9AA2AB),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/Ellipse 9.png'),
            ),
          ),
          // Use Expanded to ensure the ListView takes the remaining available space
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/profile.svg', // Replace with your image path
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
                const Divider(
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
                const SizedBox(height: 291),
                const Divider(
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
                  trailing: const Icon(
                    Icons.chevron_right, // Greater than symbol
                    color: Colors.orange, // Set the color to orange
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Setting()), // Adjust as needed
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// This is a placeholder for the Setting class
class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings Page'),
      ),
    );
  }
}

// This is a placeholder for the PostDonation class
class PostDonation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Donation'),
      ),
      body: const Center(
        child: Text('Post Donation Page'),
      ),
    );
  }
}
