import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sharesome/Choose_Role.dart';
import 'package:sharesome/Mobile_Login.dart';

import 'Home_NGO.dart';

class NgoPersonal extends StatefulWidget {
  const NgoPersonal({super.key});

  @override
  _NgoPersonalState createState() => _NgoPersonalState();
}

class _NgoPersonalState extends State<NgoPersonal> {
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
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 1),
                spreadRadius: 0,
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Color(0xFF111112),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.5, // Reduced line height
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 18),
              border: InputBorder.none, // Removed the orange outline
              filled: true,
              fillColor: Colors.white,
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFFFC8019),
            ),
            hint: const Text(
              "Non-governmental organization (NGO)",
              style: TextStyle(
                color: Color(0xFFB5BBC3),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            onChanged: onChanged,
            dropdownColor: Colors.white,
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
                      buildDropdownField(
                        label: 'Choose type',
                        value: _selectedBusinessType.isEmpty
                            ? null
                            : _selectedBusinessType,
                        items: [
                          'Non-governmental organization (NGO)',
                          'Volunteers / Contributor',
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedBusinessType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        label: 'Phone number',
                        controller: _contactNumberController,
                        placeholder: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        label: 'Name of your organization',
                        controller: _businessNameController,
                        placeholder: 'Enter your organization name',
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        label: 'Organization Id',
                        controller: _licenseNumberController,
                        placeholder: '000000 0000000 00',
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        label: 'Location',
                        controller: _locationController,
                        placeholder: 'Enter your location',
                        suffixIcon: GestureDetector(
                          onTap: _getCurrentLocation,
                          child: Image.asset(
                            'assets/loc.png',
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
                // Ensure the form is valid before saving
                if (_formKey.currentState?.validate() ?? false) {
                  // Create a reference to the Firestore collection
                  CollectionReference c =
                      FirebaseFirestore.instance.collection("NGO login");

                  // Add the data to the Firestore collection
                  try {
                    await c.add({
                      'firsr': _firstNameController.text,
                      'last': _lastNameController.text,
                      'phone': _contactNumberController.text,
                      'Name of business': _businessNameController.text,
                      'license': _licenseNumberController.text,
                      'location': _locationController.text,
                      'business type': _selectedBusinessType,
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HomeNGO(),
                      ),
                    );

                    // Optionally, show a success message or navigate to another screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Registration  successfully!')),
                    );

                    // Clear the form or navigate to another screen
                    _formKey.currentState?.reset();
                  } catch (e) {
                    // Handle any errors
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFC8019), // Updated property name
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
            ),
          ],
        ),
      ),
    );
  }
}
