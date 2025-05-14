import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesome/donor_donate_popup.dart';

import 'Home_NGO.dart';

class NGOConfirmation extends StatefulWidget {
  @override
  _NGOConfirmationState createState() => _NGOConfirmationState();
}

class _NGOConfirmationState extends State<NGOConfirmation> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? donationData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('donations').doc('donation_id').get();

      if (snapshot.exists) {
        setState(() {
          donationData = snapshot.data() as Map<String, dynamic>;
        });
      } else {
        // Use default dummy data if Firebase isn't available
        setState(() {
          donationData = {
            "hotelName": "Hotel",
            "hotelAddress": "Puducherry",
            "recipientName": "Home",
            "recipientAddress": "Puducherry.",
            "distance": "1.2km",
            "pickupTime": "Today, Sept 12, 2:30PM",
            "foodItems": [
              {"name": "idli", "quantity": 2, "isVeg": true},
              {"name": "dosa", "quantity": 1, "isVeg": true},
              // {"name": "Sambar Rice", "quantity": 21, "isVeg": true},
              // {"name": "Lemon Rice", "quantity": 10, "isVeg": true}
            ]
          };
        });
      }
    } catch (e) {
      // If Firebase connection fails, use dummy data
      setState(() {
        donationData = {
          "hotelName": "Default Hotel",
          "hotelAddress": "123, Default Street",
          "recipientName": "Default Home",
          "recipientAddress": "456, Default Avenue",
          "distance": "N/A",
          "pickupTime": "N/A",
          "foodItems": [
            {"name": "Sample Food 1", "quantity": 10, "isVeg": true},
            {"name": "Sample Food 2", "quantity": 5, "isVeg": false},
          ]
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeNGO()),
            );
            // Goes back to Home_NGO.dart
          },
        ),
        title: const Text(
          "Request Donation",
          style: TextStyle(
            fontFamily: 'Inter', // Set font to Inter
            fontSize: 20, // Adjust size if needed
            fontWeight: FontWeight.w600, // Adjust weight if needed
            color: Colors.black, // Adjust color if needed
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: donationData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDonorRecipientInfo(),
                  const SizedBox(height: 20),
                  _buildPickupInfo(),
                  const SizedBox(height: 30),
                  _buildFoodList(),
                  const Spacer(),
                  _buildPickupButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildDonorRecipientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Donor",
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange)),
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(10), // Set border radius to 10
                image: const DecorationImage(
                  image: AssetImage("assets/image 5.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donationData!['hotelName'],
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    donationData!['hotelAddress'],
                    style: const TextStyle(
                        fontFamily: 'Inter', fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Recipient",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange)),
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(10), // Set border radius to 10
                image: const DecorationImage(
                  image: AssetImage("assets/dview2.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donationData!['recipientName'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    donationData!['recipientAddress'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPickupInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.black),
            const SizedBox(width: 5),
            Text(donationData!['distance']),
          ],
        ),
        Text(
          donationData!['pickupTime'],
          style: const TextStyle(
              color: Colors.orange, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildFoodList() {
    List<dynamic> foodItems = donationData!['foodItems'];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Available food for donation",
            style: TextStyle(
                color: Colors.orange,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                var food = foodItems[index];
                return _buildFoodItem(
                    food['name'], food['quantity'], food['isVeg']);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(String name, int quantity, bool isVeg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                isVeg ? "assets/veg.png" : "assets/nveg.png",
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Text(quantity.toString(), style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildPickupButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          showCustomPopup3(context);
        }, // Add functionality to handle pickup
        child: const Text("Pickup Delivery",
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
