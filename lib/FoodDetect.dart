import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false; // New: Track loading state
  int _clickCount = 0;

  // Fake food detection cycle
  final List<String> _fakeFoodItems = [
    "White Rice",
    "Biriyani",
    "Dosa",
    "Idly",
    "Gravy",
    "Sandwich",
    "Salad",
    "Fries",
    "Dosa",
    "Biryani"
  ];

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _isLoading = true; // Show loading state
        });

        // Wait 3 seconds before displaying food name
        await Future.delayed(const Duration(seconds: 3));

        setState(() {
          _isLoading = false; // Stop loading
          _clickCount = (_clickCount + 1) % _fakeFoodItems.length;
        });
      } else {
        print("Camera closed without capturing.");
      }
    } catch (e) {
      print("Error opening camera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Food Detector",
          style: TextStyle(fontFamily: 'Inter', fontSize: 20),
        ),
        backgroundColor: const Color(0xFFFC8019), // Orange theme
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display Image if available
            _imageFile != null
                ? Column(
                    children: [
                      Image.file(
                        _imageFile!,
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                : const Icon(Icons.image, size: 100, color: Colors.grey),

            // Show loading indicator or detected food
            _isLoading
                ? const CircularProgressIndicator()
                : (_imageFile != null
                    ? Text(
                        "Detected: ${_fakeFoodItems[_clickCount]}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      )
                    : const SizedBox()),

            const SizedBox(height: 20),

            // Open Camera Button
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Open Camera"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFC8019),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
