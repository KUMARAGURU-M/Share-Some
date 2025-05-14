// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodItemDetails extends StatefulWidget {
  const FoodItemDetails(
      {super.key, Map<String, dynamic>? existingItem, int? index});

  @override
  State<FoodItemDetails> createState() => _FoodItemDetailsState();
}

class _FoodItemDetailsState extends State<FoodItemDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _foodnameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _claimdateController = TextEditingController();

  int _quantity = 0;
  String? _selectedFoodType;
  String? _selectedDietaryInfo;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    _quantityController.text =
        _quantity.toString(); // Initialize with default quantity
  }

  @override
  void dispose() {
    _foodnameController.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    _claimdateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat.yMd().format(picked);
      });
    }
  }

  void _handleContinue() {
    setState(() {
      _showErrors = true; // Enable error messages
    });

    if (_formKey.currentState!.validate()) {
      // Gather data into a map
      final foodItemData = {
        'foodName': _foodnameController.text,
        'quantity': _quantity,
        'foodType': _selectedFoodType,
        'dietaryInfo': _selectedDietaryInfo,
        'dateOfFoodPreparation': _dateController.text,
        'claimBefore': _claimdateController.text,
      };

      // Pass data back to previous screen
      Navigator.pop(context, foodItemData);
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
          'Food Items Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
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
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      buildDropdownField(
                        label: 'Food Type',
                        value: _selectedFoodType,
                        items: ['Breakfast', 'Lunch', 'Dinner'],
                        hint: 'Select food type',
                        onChanged: (value) {
                          setState(() {
                            _selectedFoodType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        label: 'Food Name',
                        controller: _foodnameController,
                        placeholder: 'Enter food name',
                        validator: (value) {
                          if (_showErrors) {
                            if (value == null || value.isEmpty) {
                              return 'Food name is required';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildDropdownField1(
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
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quantity',
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
                      buildTextField(
                        label: 'Date of Food Preparation',
                        controller: _dateController,
                        placeholder: 'Choose date',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, _dateController),
                        ),
                        validator: (value) {
                          if (_showErrors) {
                            if (value == null || value.isEmpty) {
                              return 'Date of food preparation is required';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        label: 'Claim Before',
                        controller: _claimdateController,
                        placeholder: 'Choose date',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, _claimdateController),
                        ),
                        validator: (value) {
                          if (_showErrors) {
                            if (value == null || value.isEmpty) {
                              return 'Claim date is required';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_showErrors && !_formKey.currentState!.validate())
                        Text(
                          'Please fill all required fields and select all options',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 100),
                      ElevatedButton(
                        onPressed: _handleContinue,
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
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownField1({
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
                child: label ==
                        'Dietary Information' // Check if it's dietary dropdown
                    ? Row(
                        children: [
                          Image.asset(
                            item == 'Vegetarian'
                                ? 'assets/veg.png' // Image for Vegetarian
                                : 'assets/nveg.png', // Image for Non-Vegetarian
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(item),
                        ],
                      )
                    : Text(item), // Default text if it's not dietary dropdown
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
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              hintText: hint,
              hintStyle:
                  const TextStyle(color: Color(0xFFB5BBC3), fontSize: 12),
            ),
            value: value,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
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
}
