// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorPersonalInfo extends StatefulWidget {
  final String documentId;

  DonorPersonalInfo({required this.documentId});

  @override
  _DonorPersonalInfoState createState() => _DonorPersonalInfoState();
}

class _DonorPersonalInfoState extends State<DonorPersonalInfo> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _businessNameController;
  late TextEditingController _licenseNumberController;
  late TextEditingController _locationController;

  bool _isLoading = false;
  String? _selectedBusinessType; // To store selected value for the dropdown

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _businessNameController = TextEditingController();
    _licenseNumberController = TextEditingController();
    _locationController = TextEditingController();

    _fetchDonorInfo();
  }

  Future<void> _fetchDonorInfo() async {
    setState(() {
      _isLoading = true;
    });
    CollectionReference loginCollection =
        FirebaseFirestore.instance.collection('login');
    DocumentSnapshot docSnapshot =
        await loginCollection.doc(widget.documentId).get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      _firstNameController.text = data['first'] ?? '';
      _lastNameController.text = data['last'] ?? '';
      _phoneNumberController.text = data['phone'] ?? '';
      _selectedBusinessType = data['business type'] ?? ''; // Dropdown value
      _businessNameController.text = data['Name of business'] ?? '';
      _licenseNumberController.text = data['license'].toString();
      _locationController.text = data['location'] ?? '';
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveUpdatedInfo() async {
    CollectionReference loginCollection =
        FirebaseFirestore.instance.collection('login');
    try {
      await loginCollection.doc(widget.documentId).update({
        'first': _firstNameController.text,
        'last': _lastNameController.text,
        'phone': _phoneNumberController.text,
        'business type': _selectedBusinessType,
        'Name of business': _businessNameController.text,
        'license': int.parse(_licenseNumberController.text),
        'location': _locationController.text,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating data: $e')));
    }
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
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Personal Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Added to prevent overflow
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildTextField(
                        label: 'First Name', controller: _firstNameController),
                    const SizedBox(height: 16),
                    buildTextField(
                        label: 'Last Name', controller: _lastNameController),
                    const SizedBox(height: 16),
                    buildTextField(
                        label: 'Phone Number',
                        controller: _phoneNumberController),
                    const SizedBox(height: 16),
                    buildDropdownField(), // Dropdown for business type
                    const SizedBox(height: 16),
                    buildTextField(
                        label: 'Name of Business',
                        controller: _businessNameController),
                    const SizedBox(height: 16),
                    buildTextField(
                        label: 'License Number',
                        controller: _licenseNumberController),
                    const SizedBox(height: 16),
                    buildTextField(
                        label: 'Location', controller: _locationController),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveUpdatedInfo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFC8019),
                        minimumSize: Size(double.infinity, 55),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 69, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadowColor: const Color(0x3F000000),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Function to build text fields
  Widget buildTextField(
      {required String label, required TextEditingController controller}) {
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
          ),
        ),
        const SizedBox(height: 6),
        Container(
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
            ),
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  // Function to build dropdown field for business type
  Widget buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Type',
          style: const TextStyle(
            color: Color(0xFFFC8019),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
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
            value: _selectedBusinessType,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
            onChanged: (String? newValue) {
              setState(() {
                _selectedBusinessType = newValue;
              });
            },
            items: <String>[
              'Hotels & Restaurants',
              'Caterings & Food Services',
              'Ceremonial Events / Gatherings',
              'Corporate Cafeterias',
              'Others',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
