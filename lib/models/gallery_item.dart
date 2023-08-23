import 'dart:convert';
import 'dart:typed_data';

class GalleryItem {
  final String? id;
  final Uint8List imageBytes;
  final String filename;
  final String filetype;
  final String description; 

  GalleryItem(
    {
      this.id,
      required this.description,
      required this.filename,
      required this.filetype,
      required this.imageBytes
    }
  );

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'description': description});
    result.addAll({'filename': filename});
    result.addAll({'filetype': filetype});
    result.addAll({'imageBytes': imageBytes});

    return result;
  }

  factory GalleryItem.fromMap(Map<String, dynamic> map) {
    return GalleryItem(
      id: map["id"], 
      description: map["description"] ?? "", 
      filename: map["filename"] ?? "", 
      filetype: map["filetype"] ?? "", 
      imageBytes: map["imageBytes"] ?? Uint8List
    );
  }

  factory GalleryItem.fromJson(String source) =>
      GalleryItem.fromMap(json.decode(source));

  String toJson() => json.encode(toMap()); // Turn Model into json
}