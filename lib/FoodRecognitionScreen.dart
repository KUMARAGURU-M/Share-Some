import 'package:flutter/material.dart';
import 'package:sharesome/pickImage.dart';
import 'image_picker_service.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodRecognitionScreen extends StatefulWidget {
  @override
  _FoodRecognitionScreenState createState() => _FoodRecognitionScreenState();
}

class _FoodRecognitionScreenState extends State<FoodRecognitionScreen> {
  File? selectedImage;
  String foodName = "No food identified";

  void getImage() async {
    File? image = await pickImage();
    if (image != null) {
      setState(() {
        selectedImage = image;
        foodName = "Identifying...";
      });
      identifyFood(image);
    }
  }

  Future<void> identifyFood(File image) async {
    final apiKey =
        "AIzaSyAJLxs68N252_K1GLI3kS4sPfn0EYdsIoU"; // Replace with your API key
    final uri = Uri.parse(
        "https://vision.googleapis.com/v1/images:annotate?key=$apiKey");
    final imageBytes = image.readAsBytesSync();
    final base64Image = base64Encode(imageBytes);

    final requestPayload = {
      "requests": [
        {
          "image": {"content": base64Image},
          "features": [
            {"type": "LABEL_DETECTION", "maxResults": 5}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final labels = jsonResponse['responses'][0]['labelAnnotations'] ?? [];
        if (labels.isNotEmpty) {
          setState(() {
            foodName = labels[0]['description'];
          });
        } else {
          setState(() {
            foodName = "No food detected";
          });
        }
      } else {
        setState(() {
          foodName = "Error: ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        foodName = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Recognition')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedImage != null
                ? Image.file(selectedImage!)
                : Text('No image selected'),
            SizedBox(height: 20),
            Text(
              foodName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: getImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFC8019),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFFC8019)),
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(160, 50),
                padding: EdgeInsets.zero,
              ),
              icon: const Icon(
                Icons.camera_alt_rounded,
                size: 16,
                color: Colors.white,
              ),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Capture Image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
