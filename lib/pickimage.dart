import 'package:image_picker/image_picker.dart';
import 'dart:io';

Future<File?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  return pickedFile != null ? File(pickedFile.path) : null;
}
