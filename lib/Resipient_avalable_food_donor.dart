import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'donor_oldage_fund.dart'; // Import the detailed donor page

class RecipientAvailableFoodDonor extends StatefulWidget {
  const RecipientAvailableFoodDonor({super.key});

  @override
  State<RecipientAvailableFoodDonor> createState() => _DonorActiveReqState();
}

class _DonorActiveReqState extends State<RecipientAvailableFoodDonor> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNotificationEnabled = true;

  // Fetch data from Firestore
  Stream<List<Map<String, dynamic>>> getRecipientRequests() {
    return FirebaseFirestore.instance
        .collection('Donation')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var request = doc.data();
              request['documentId'] = doc.id; // Include the document ID
              return request;
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Active food donors',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: getRecipientRequests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No donor found'));
            }

            var requests = snapshot.data!;

            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                var request = requests[index]; // Already a Map<String, dynamic>

                String hotelName = request['Business Name'] ?? '';
                String distance = request['Location'] ?? '';
                String numberOfPersons =
                    request['People in need']?.toString() ?? '0';

                return Container(
                  margin: const EdgeInsets.all(11),
                  padding: const EdgeInsets.fromLTRB(16, 17, 16, 13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row with Hotel Name and Distance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            hotelName,
                            style: const TextStyle(
                              color: Color(0xFFFC8019),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/delivery.svg'),
                              const SizedBox(width: 5),
                              Text(
                                distance,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.33,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      // Title
                      Text(
                        "$hotelName is offering food for you",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Action Buttons
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // Handle call recipient action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFC8019),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFFFC8019)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(122, 28),
                              padding: EdgeInsets.zero,
                            ),
                            icon: const Icon(
                              Icons.call,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                'Call Recipient',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Handle show on map action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFC8019),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFFFC8019)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(128, 28),
                              padding: EdgeInsets.zero,
                            ),
                            icon: const Icon(
                              Icons.location_on_sharp,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                'Show on maps',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Arrow button to navigate to the detailed donor page
                          IconButton(
                            onPressed: () {
                              String documentId =
                                  request['documentId']; // Fetch document ID
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DonorOldAgeFund(
                                    documentId: documentId,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward,
                                color: Color(0xFFFC8019)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
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
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Home
              _buildBottomNavItem('assets/home.svg', 'Home', () {
                Navigator.pushNamed(context, '/home');
              }),
              // History
              _buildBottomNavItem('assets/history.svg', 'History', () {
                Navigator.pushNamed(context, '/history');
              }),
              // Donate Now
              _buildBottomNavItem('assets/donatenow.svg', 'Donate Now', () {
                Navigator.pushNamed(context, '/donate');
              }),
              // Maps
              _buildBottomNavItem('assets/maps.svg', 'Maps', () {
                Navigator.pushNamed(context, '/maps');
              }),
              // Message
              _buildBottomNavItem('assets/message.svg', 'Message', () {
                Navigator.pushNamed(context, '/message');
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build bottom navigation items
  Widget _buildBottomNavItem(
      String iconPath, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, height: 24, width: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
