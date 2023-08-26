import 'dart:math';

import 'package:image_picker/image_picker.dart';

class Utilities{

  /// Calculates the size of the bytes and returns the size with the correct suffix 
  static String getFileSizeString({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  /// Opens the image picker and returns the picked image if any was picked
  static Future<XFile?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  /// Opens the image picker and returns the picked image if any was picked
  static Future<XFile?> takeImageWithCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    return pickedFile;
  }
}