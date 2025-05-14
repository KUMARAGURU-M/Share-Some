// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharesome/Donor_select_Donation_Type.dart';
import 'package:sharesome/FoodDetect.dart';
import 'package:sharesome/FoodRecognitionScreen.dart';
import 'package:sharesome/Home_Donar.dart';
import 'package:sharesome/Splash_page.dart';
import 'package:sharesome/food_item_details.dart';
import 'package:sharesome/pop_up.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostDonation extends StatefulWidget {
  const PostDonation({super.key});

  @override
  State<PostDonation> createState() => _PostDonationState();
}

class _PostDonationState extends State<PostDonation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ngoController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final List<Map<String, dynamic>> _donations = [];
  bool _showAddFoodItems = false;
  String? _docId; // Dynamically retrieved document ID

  Future<void> _getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showSnackbar('Location services are disabled. Please enable them.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        _showSnackbar('Location permissions are denied.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      setState(() {
        _locationController.text = placemarks.isNotEmpty
            ? '${placemarks.first.locality}, ${placemarks.first.country}'
            : 'No address found';
      });
    } catch (e) {
      _showSnackbar('Failed to get location: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => _dateController.text = DateFormat.yMd().format(picked));
    }
  }

  Future<void> _selectTime() async {
    final picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() => _timeController.text = picked.format(context));
    }
  }

  Future<void> _saveDonation() async {
    if (_formKey.currentState?.validate() ?? false) {
      final donationData = {
        'Business Name': _businessController.text.trim(),
        'Location': _locationController.text.trim(),
        'Ngo': _ngoController.text.trim(),
        'Date': _dateController.text.trim(),
        'Time': _timeController.text.trim(),
        'fooditems': _donations,
      };

      try {
        if (_docId == null) {
          // Add new donation to Firestore if no document exists
          final docRef = await FirebaseFirestore.instance
              .collection('Donation')
              .add(donationData);

          _docId = docRef.id; // Store the document ID
        } else {
          // Update the existing donation if document ID exists
          await FirebaseFirestore.instance
              .collection('Donation')
              .doc(_docId)
              .update(donationData);
        }

        _showSnackbar('Donation posted successfully!');

        // Navigate to the home page after posting the donation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeDonar()),
        );
      } catch (e) {
        _showSnackbar('Failed to post donation: $e');
      }
    }
  }

  Future<void> _navigateToFoodItemDetails(
      {Map<String, dynamic>? foodItem, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodItemDetails(
          existingItem: foodItem, // Pass existing item if editing
          index: index, // Pass index for editing
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (index != null) {
          // Update the existing food item if editing
          _donations[index] = result;
        } else {
          // Add new food item if creating
          _donations.add(result);
        }
        _showAddFoodItems = true;
      });
    }
  }

  // Edit a food item in Firestore
  Future<void> _editFoodItemInFirestore(
      int index, Map<String, dynamic> updatedItem) async {
    if (_docId == null) {
      _showSnackbar('Document not found.');
      return;
    }
    try {
      // Retrieve the current document
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Donation')
          .doc(_docId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        List<dynamic> foodItems = data?['fooditems'] ?? [];

        // Update the specific item at the given index
        foodItems[index] = updatedItem;

        // Update the document in Firestore with the new food item array
        await FirebaseFirestore.instance
            .collection('Donation')
            .doc(_docId)
            .update({'fooditems': foodItems});

        _showSnackbar('Food item updated successfully!');
      }
    } catch (e) {
      _showSnackbar('Failed to update food item: $e');
    }
  }

  void _deleteFoodItem(List<dynamic> foodItems, int index) {
    if (index >= 0 && index < foodItems.length) {
      foodItems.removeAt(index);
      _showSnackbar('Food item deleted successfully!');
    } else {
      _showSnackbar('Invalid item to delete.');
    }
  }

  void _1showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    Widget? suffixIcon,
    required FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFC8019),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Color(0x19000000), blurRadius: 10),
            ],
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              hintText: controller.text.isEmpty ? placeholder : null,
              hintStyle:
                  const TextStyle(color: Color(0xFFB5BBC3), fontSize: 12),
              suffixIcon: suffixIcon,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget buildFoodItemList() {
    if (_donations.isEmpty) {
      return const Text('No food items added');
    }

    return Column(
      children: _donations.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> item = entry.value;
        return Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 3.0, vertical: 3.0), // Adds space between list items
          decoration: BoxDecoration(
            color: Colors.white, // Background color for shadow visibility
            borderRadius: BorderRadius.circular(8.0), // Rounds the corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            title: Text('FoodName: ${item['foodName']}'),
            subtitle: Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Text('Quantity: ${item['quantity']}'),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.orange),
                  onPressed: () {
                    // Call the delete function, passing the list of donations
                    _deleteFoodItem(_donations, index = index);
                    setState(() {}); // Update the UI after deletion
                  },
                ),
                IconButton(
                  icon:
                      const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                  onPressed: () {
                    _navigateToFoodItemDetails(
                      foodItem: item,
                      index: index,
                    ); // Pass the index to edit
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DonationTypeScreen(),
              ),
            );
          },
        ),
        title: const Text('Post Donation',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildTextField(
                            label: 'Business Name',
                            controller: _businessController,
                            placeholder: 'Enter Business Name',
                            validator: (value) => value?.isEmpty == true
                                ? 'Please enter the business name'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          buildTextField(
                            label: 'Location',
                            controller: _locationController,
                            placeholder: 'Enter your location',
                            suffixIcon: GestureDetector(
                              onTap: _getCurrentLocation,
                              child: const Icon(Icons.location_on),
                            ),
                            validator: (value) => value?.isEmpty == true
                                ? 'Please enter a location'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          buildTextField(
                            label: 'Notify nearby NGO',
                            controller: _ngoController,
                            placeholder: 'Enter NGO name',
                            validator: (value) => value?.isEmpty == true
                                ? 'Please enter the NGO name'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextField(
                                  label: 'Choose Date',
                                  controller: _dateController,
                                  placeholder: 'Select date',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: _selectDate,
                                  ),
                                  validator: (value) => value?.isEmpty == true
                                      ? 'Please select a date'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: buildTextField(
                                  label: 'Preferred Time',
                                  controller: _timeController,
                                  placeholder: 'Choose time',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.access_time),
                                    onPressed: _selectTime,
                                  ),
                                  validator: (value) => value?.isEmpty == true
                                      ? 'Please select a time'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Align text and icon at opposite ends
                            children: [
                              Text(
                                'Mention available food',
                                style: const TextStyle(
                                  color: Color(0xFFFC8019),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.camera_alt_rounded),
                                onPressed: () {
                                  // Navigate to CameraPage
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CameraScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          if (_showAddFoodItems) buildFoodItemList(),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _navigateToFoodItemDetails,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x19000000),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.add_circle,
                                  color: Color(0xFFFC8019),
                                ),
                                title: const Text(
                                  'Add food items',
                                  style: TextStyle(color: Color(0xFFB5BBC3)),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFFFC8019),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 320),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(3.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _saveDonation();
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  showCustomPopup(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFC8019),
                                minimumSize: const Size(double.infinity, 60),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 69, vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text(
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
                        ],
                      ),
                    ),
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
