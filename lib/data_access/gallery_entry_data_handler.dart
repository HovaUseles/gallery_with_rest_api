import 'dart:convert';

import 'package:gallery_with_rest_api/data_access/api_client.dart';
// import 'package:gallery_with_rest_api/data_access/exceptions/missing_uri_exception.dart';
import 'package:gallery_with_rest_api/models/gallery_item.dart';

class GalleryEntryDataHandler {
  final ApiClient _apiClient = ApiClient(baseUrl: "127.0.0.1:7090/api");
  final String _context = "GalleryEntry";
  
  GalleryEntryDataHandler();

  Future<List<GalleryItem>> getAll() async {
    var response = await _apiClient.get(_context);
    Iterable jsonArray = json.decode(response.body);
    List<GalleryItem> galleryItems = List<GalleryItem>.from(jsonArray.map((jsonObject)=> GalleryItem.fromJson(jsonObject)));
    return galleryItems;
  }

  Future<GalleryItem> get(String id) async {
    var response = await _apiClient.get("$_context/$id");
    GalleryItem galleryItem = GalleryItem.fromJson(response.body);
    return galleryItem;
  }

  Future<GalleryItem> create(GalleryItem galleryItem) async {
    Map<String, dynamic> jsonBody = galleryItem.toMap();
    var response = await _apiClient.post(_context, jsonBody);

    GalleryItem createdGalleryItem = GalleryItem.fromJson(response.body);
    return createdGalleryItem;
    /*
    // Check for Uri header
    if(response.headers.containsKey("location")) {
      // Get Uri value and get created item from the location if not null.
      String? createdUri = response.headers["location"] ?? "";
      if(createdUri.isEmpty) {
        throw MissingUriException("Missing URI for created ${(GalleryItem).toString()}");
      }
      var getResponse = await _apiClient.get(createdUri);
      GalleryItem createdGalleryItem = GalleryItem.fromJson(getResponse.body);
      return createdGalleryItem;

    }*/
  }

  Future<bool> edit(GalleryItem galleryItemChanges) async {
    Map<String, dynamic> jsonBody = galleryItemChanges.toMap();
    var response = await _apiClient.put("$_context/${galleryItemChanges.id}", jsonBody);
    return true;
  }
  
  Future<bool> delete(String id) async {
    var response = await _apiClient.delete("$_context/${id}");
    return true;
  }
}