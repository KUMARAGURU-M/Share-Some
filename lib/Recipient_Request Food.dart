// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sharesome/Recipient_Select%20Request%20Type.dart';
import 'package:sharesome/Request%20Success_Pop%20up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Requestfood extends StatefulWidget {
  const Requestfood({super.key});

  @override
  State<Requestfood> createState() => _RequestfoodState();
}

class _RequestfoodState extends State<Requestfood> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _organizationNameController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String? _selectedFoodType;
  int _quantity = 0;
  String? _selectedDietaryInfo;

  @override
  void initState() {
    super.initState();
    _quantityController.text =
        _quantity.toString(); // Initialize with default quantity
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

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

  Widget buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
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
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 5.66,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              border: InputBorder.none,
              hintText: hint,
              hintStyle:
                  const TextStyle(color: Color(0xFFB5BBC3), fontSize: 12),
            ),
            value: value,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: label == 'Dietary Information'
                    ? Row(
                        children: [
                          Image.asset(
                            item == 'Vegetarian'
                                ? 'assets/veg.png'
                                : 'assets/nveg.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(item),
                        ],
                      )
                    : Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) =>
                value == null ? 'Please select an option' : null,
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
                builder: (context) => RequestTypeSelection(),
              ),
            );
          },
        ),
        title: const Text(
          'Request Donation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                          const SizedBox(height: 10),
                          buildTextField(
                            label: 'Organization Name',
                            controller: _organizationNameController,
                            placeholder: 'Enter your organization name',
                            validator: _validateNotEmpty,
                          ),
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
                          buildDropdownField(
                            label: 'Food Type',
                            value: _selectedFoodType,
                            items: ['BreakFast', 'Lunch', 'Dinner'],
                            hint: 'Select food type',
                            onChanged: (value) {
                              setState(() {
                                _selectedFoodType = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'People in need',
                                style: const TextStyle(
                                  color: Color(0xFFFC8019),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove,
                                          color: Colors.orange),
                                      onPressed: () {
                                        setState(() {
                                          if (_quantity > 0) {
                                            _quantity--;
                                            _quantityController.text =
                                                _quantity.toString();
                                          }
                                        });
                                      },
                                    ),
                                    Container(
                                      width: 60,
                                      child: Center(
                                        child: Text(
                                          _quantity.toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add,
                                          color: Colors.orange),
                                      onPressed: () {
                                        setState(() {
                                          if (_quantity < 999) {
                                            _quantity++;
                                            _quantityController.text =
                                                _quantity.toString();
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextField(
                                  label: 'Date',
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
                          const SizedBox(height: 16),
                          buildDropdownField(
                            label: 'Dietary Information',
                            value: _selectedDietaryInfo,
                            items: ['Vegetarian', 'Non-Vegetarian'],
                            hint: 'Select dietary information',
                            onChanged: (value) {
                              setState(() {
                                _selectedDietaryInfo = value;
                              });
                            },
                          ),
                          const SizedBox(height: 250),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  {
                                    CollectionReference c = FirebaseFirestore
                                        .instance
                                        .collection("Recipient Request");
                                    try {
                                      // Save data with UID
                                      await c.add({
                                        'Organization Name':
                                            _organizationNameController.text,
                                        'Food Type': _selectedFoodType,
                                        'People in need':
                                            _quantityController.text,
                                        'Date': _dateController.text,
                                        'Prefered time': _timeController.text,
                                        'location': _locationController.text,
                                      });

                                      showCustomPopup1(context);
                                    } catch (e) {
                                      _showSnackbar(
                                          'Failed to submit request: $e');
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFC8019),
                                minimumSize: Size(double.infinity, 60),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 69, vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                'Request Food',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
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
