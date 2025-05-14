import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:sharesome/pop_up.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Recipient_accept_popup.dart';

class DonorOldAgeFund extends StatelessWidget {
  final String documentId;

  DonorOldAgeFund({required this.documentId});

  final List<String> photos = [
    'assets/dview1.png',
    'assets/dview2.png',
    'assets/dview3.png',
    'assets/dview4.png',
    'assets/dview5.png',
    'assets/dview6.png',
  ];

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
            .collection('Donation')
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
          String organizationName = data['Business Name'] ?? 'No Name';
          String location = data['Location'] ?? 'No Address';
          List<dynamic> foodItems =
              data['fooditems'] ?? []; // Fetch foodItems as a list
          String claimBefore = data['claimBefore'] ?? 'N/A';
          String preferredTime = data['Time'] ?? 'N/A';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImageSection(),
                const SizedBox(height: 20),
                Text(organizationName, style: _titleStyle()),
                const SizedBox(height: 12),
                Text(location, style: _subtitleStyle()),
                const SizedBox(height: 8),
                buildActionRow(context),
                const SizedBox(height: 16),
                buildPhotosAndVideosRow(photos),
                const Divider(),
                buildTimeRow('Preferred time', preferredTime),
                const SizedBox(height: 16),
                // Food Items Section
                const Text(
                  'Food Items',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                buildFoodItemsList(foodItems), // Render food items list
                const Divider(),
                Text('Claim before $claimBefore', style: _subtitleStyle()),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
      bottomSheet: buildBottomClaimButton(context),
    );
  }

  Widget buildImageSection() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.asset('assets/saravana.png', fit: BoxFit.cover),
      ),
    );
  }

  Widget buildActionRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: _makeCall,
            child: buildActionButton('assets/call.png', 'Call')),
        const SizedBox(width: 13),
        buildActionButton('assets/viewmsg.png', 'Message'),
        const SizedBox(width: 13),
        GestureDetector(
            onTap: _shareDetails,
            child: buildActionButton('assets/share.png', 'Share')),
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
          Text(label,
              style: const TextStyle(color: Color(0xFFFC8019), fontSize: 12)),
        ],
      ),
    );
  }

  Widget buildPhotosAndVideosRow(List<String> imagePaths) {
    return SizedBox(
      height: 57,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(imagePaths[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget buildTimeRow(String label, String value) {
    return Row(
      children: [
        SvgPicture.asset('assets/time.svg'),
        const SizedBox(width: 8),
        Text(label, style: _subtitleStyle()),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                color: Color(0xFFFC8019),
                fontSize: 14,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget buildFoodItemsList(List<dynamic> foodItems) {
    return Column(
      children: foodItems.map((item) {
        return _buildFoodItem(
          item['foodName'] ?? 'No Name',
          item['quantity'] ?? 0,
          item['dietaryInfo'] == 'Vegetarian'
              ? 'assets/veg.png'
              : 'assets/nveg.png',
        );
      }).toList(),
    );
  }

  Widget _buildFoodItem(String name, int qty, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(imagePath, width: 16, height: 16),
          const SizedBox(width: 8),
          Text(name, style: _titleStyle()),
          const Spacer(),
          Text(qty.toString(), style: _subtitleStyle()),
        ],
      ),
    );
  }

  Widget buildBottomClaimButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      child: ElevatedButton(
        onPressed: () {
          showCustomPopup2(context); // Call the function to show the popup
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
            'Claim Donation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _titleStyle() =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  TextStyle _subtitleStyle() =>
      const TextStyle(fontSize: 14, color: Colors.black54);

  void _shareDetails() => Share.share("Check out this donation!");
  void _makeCall() async => await launch("tel:9360893385");
}
