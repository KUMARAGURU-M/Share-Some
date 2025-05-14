// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sharesome/Choose_Role.dart';
import 'package:sharesome/Home_Donar.dart';
import 'package:sharesome/Mobile_Login.dart';

class DonorPersonal extends StatefulWidget {
  const DonorPersonal({super.key});

  @override
  _DonorPersonalState createState() => _DonorPersonalState();
}

class _DonorPersonalState extends State<DonorPersonal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _selectedBusinessType = '';
  // Function to fetch and update the current location
  Future<void> _getCurrentLocation() async {
    try {
      // Check location permissions
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, ask the user to enable it
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
        ));
        return;
      }

      // Check for location permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Request location permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permission denied, show a message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Location permission denied.'),
          ));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ));
        return;
      }

      // Get the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Use the geocoding package to get a human-readable address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _locationController.text =
              '${place.locality}, ${place.country}'; // Example: Cupertino, United States
        });
      } else {
        setState(() {
          _locationController.text = 'No address found';
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactNumberController.dispose();
    _businessNameController.dispose();
    _licenseNumberController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFC8019),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 45,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 10,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              hintText: controller.text.isEmpty ? placeholder : null,
              hintStyle: const TextStyle(
                color: Color(0xFFB5BBC3),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              suffixIcon: suffixIcon,
            ),
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            keyboardType: keyboardType,
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFC8019),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 45,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 10,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: InputBorder.none,
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFFFC8019),
            ),
            dropdownColor: Colors.white,
            isExpanded: true, // Ensures the dropdown takes the full width
            hint: const Text(
              "Mention the business type",
              style: TextStyle(
                color: Color(0xFFB5BBC3),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            onChanged: onChanged,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFF111112),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
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
                  builder: (context) =>
                      UserSelectionPage()), // Replace Login() with your Login page class
            );
          },
        ),
        title: const Text(
          'Personal Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildTextField(
                        label: 'First name',
                        controller: _firstNameController,
                        placeholder: 'Enter your first name',
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        label: 'Last name',
                        controller: _lastNameController,
                        placeholder: 'Enter your last name',
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        label: 'Phone number',
                        controller: _contactNumberController,
                        placeholder: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      buildDropdownField(
                        label: 'Business type',
                        value: _selectedBusinessType.isEmpty
                            ? null
                            : _selectedBusinessType,
                        items: [
                          'Hotels & Restaurants',
                          'Caterings & Food Services',
                          'Ceremonial Events / Gatherings',
                          'Corporate Cafeterias',
                          'Others'
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedBusinessType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        label: 'Name of your business',
                        controller: _businessNameController,
                        placeholder: 'Enter your business name',
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        label: 'License Number',
                        controller: _licenseNumberController,
                        placeholder: 'Enter your license number',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        label: 'Location',
                        controller: _locationController,
                        placeholder: 'Enter your location',
                        suffixIcon: GestureDetector(
                          onTap: _getCurrentLocation,
                          child: Icon(
                            Icons.location_on,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 32), // Add spacing below the fields
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  User? user =
                      FirebaseAuth.instance.currentUser; // Get the current user
                  if (user != null) {
                    CollectionReference c =
                        FirebaseFirestore.instance.collection("donors");
                    try {
                      // Save data with UID
                      await c.doc(user.uid).set({
                        'firstName': _firstNameController.text,
                        'lastName': _lastNameController.text,
                        'phone': _contactNumberController.text,
                        'businessName': _businessNameController.text,
                        'licenseNumber':
                            int.tryParse(_licenseNumberController.text),
                        'location': _locationController.text,
                        'businessType': _selectedBusinessType,
                      });

                      // Navigate to HomeDonar page with data
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HomeDonar(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No user signed in')));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFC8019),
                minimumSize: Size(double.infinity, 55),
                padding:
                    const EdgeInsets.symmetric(horizontal: 69, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadowColor: const Color(0x3F000000),
                elevation: 4,
              ),
              child: const Text(
                'Save and Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
