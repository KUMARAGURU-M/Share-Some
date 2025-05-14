import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharesome/donor_donate_popup.dart';

import 'Post_Donation.dart';

class DonorOldagehomeView extends StatelessWidget {
  final String documentId;

  DonorOldagehomeView({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(32.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Recipient Request')
            .doc(documentId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data not found'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          String organizationName = data['Organization Name'] ?? 'No Name';
          String location = data['location'] ?? 'No Address';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'assets/image 4(v).png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    organizationName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    location,
                    style: const TextStyle(
                      color: Color(0xFF9AA2AB),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildActionRow(),
                  const SizedBox(height: 16),
                  const Text(
                    'Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus.',
                    style: TextStyle(
                      color: Color(0xFF9AA2AB),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Government Identity Licence',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildLicenceRow(),
                  const SizedBox(height: 33),
                  const Text(
                    'Photos & Videos',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildPhotosAndVideosRow([
                    'assets/dview1.png',
                    'assets/dview2.png',
                    'assets/dview3.png',
                    'assets/dview4.png',
                    'assets/dview5.png',
                    'assets/dview6.png',
                  ]),
                  const SizedBox(height: 80), // Space for donate button
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
      bottomSheet: Container(
        padding: const EdgeInsets.all(14.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostDonation()),
            ); // Call the function to show the popup
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFC8019),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Text(
              'Donate Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildActionButton('assets/call.png', 'Call'),
        const SizedBox(width: 13),
        buildActionButton('assets/viewmsg.png', 'Message'),
        const SizedBox(width: 13),
        buildActionButton('assets/share.png', 'Share'),
      ],
    );
  }

  Widget buildActionButton(String iconPath, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFFC8019)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFC8019),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLicenceRow() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFFC8019)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Image.asset('assets/certi.png'),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Lc4578ncue44522',
              style: TextStyle(
                color: Color(0xFFFC8019),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0.14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPhotosAndVideosRow(List<String> imagePaths) {
    return SizedBox(
      height: 57,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: imagePaths.map((path) {
          return AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  path,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
