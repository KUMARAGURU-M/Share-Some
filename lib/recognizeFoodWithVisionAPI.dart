import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> recognizeFoodWithVisionAPI(File image, String apiKey) async {
  final bytes = image.readAsBytesSync();
  final base64Image = base64Encode(bytes);

  final url = 'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';

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

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(requestPayload),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final labels = data['responses'][0]['labelAnnotations'];
    for (var label in labels) {
      print('Food: ${label['description']} (Confidence: ${label['score']})');
    }
  } else {
    print('Error: ${response.statusCode}');
    print('Message: ${response.body}');
  }
}
