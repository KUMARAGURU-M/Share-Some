// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sharesome/Choose_Role.dart';
import 'package:sharesome/Home_Recipient.dart';

class RecipientPersonal extends StatefulWidget {
  const RecipientPersonal({super.key});

  @override
  _RecipientPersonalState createState() => _RecipientPersonalState();
}

class _RecipientPersonalState extends State<RecipientPersonal> {
  final _formKey = GlobalKey<FormState>();

  // Controllers named according to their label
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _organizationNameController =
      TextEditingController();
  final TextEditingController _accreditationController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _selectedBusinessType = '';

  // Function to fetch and update the current location
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
        ));
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Location permission denied.'),
          ));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _locationController.text = '${place.locality}, ${place.country}';
        });
      } else {
        setState(() {
          _locationController.text = 'No address found';
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
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
    _organizationNameController.dispose();
    _accreditationController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final phoneRegExp = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (value == null || value.isEmpty) {
      return 'Contact number is required';
    } else if (!phoneRegExp.hasMatch(value)) {
      return 'Enter a valid contact number';
    }
    return null;
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
            value: (value == null || value.isEmpty)
                ? null
                : value, // Use null-aware check
            items: items.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Center(
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Color(0xFF111112),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 18),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFFFC8019),
            ),
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
            validator: validator,
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
              MaterialPageRoute(builder: (context) => UserSelectionPage()),
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
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    buildTextField(
                      label: 'First Name',
                      controller: _firstNameController,
                      placeholder: 'Enter your first name',
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      label: 'Last Name',
                      controller: _lastNameController,
                      placeholder: 'Enter your last name',
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      label: 'Contact Number',
                      controller: _contactNumberController,
                      placeholder: 'Enter your contact number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    buildDropdownField(
                      label: 'Support Category',
                      value: _selectedBusinessType,
                      items: [
                        'Elder Care Facilities',
                        'Children’s Homes & Orphanages',
                        'Residential Care Services',
                        'Community Care Homes',
                        'Others'
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedBusinessType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      label: 'Organization Name',
                      controller: _organizationNameController,
                      placeholder: 'Enter your organization name',
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      label: 'Accreditation',
                      controller: _accreditationController,
                      placeholder: 'Enter accreditation',
                    ),
                    const SizedBox(height: 10),
                    buildTextField(
                      label: 'Location',
                      controller: _locationController,
                      placeholder: 'Enter your location',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.location_on,
                            color: Color(0xFFFC8019)),
                        onPressed: _getCurrentLocation,
                      ),
                    ),
                  ],
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
                        FirebaseFirestore.instance.collection("recipient");
                    try {
                      // Save data with UID
                      await c.doc(user.uid).set({
                        'First': _firstNameController.text,
                        'Last': _lastNameController.text,
                        'Phone': _contactNumberController.text,
                        'Organization Name': _organizationNameController.text,
                        'Accreditation': _accreditationController.text,
                        'Location': _locationController.text,
                        'Support Category': _selectedBusinessType,
                      });

                      // Navigate to HomeDonar page with data
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HomeRecipient(),
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
