import 'dart:async';
import 'dart:convert';

import 'package:gallery_with_rest_api/data_access/api_client.dart';
import 'package:gallery_with_rest_api/models/gallery_item.dart';
import 'package:localstore/localstore.dart';

/// Responsible for data handling for GalleryItem
class GalleryItemDataHandler {
  final ApiClient _apiClient = ApiClient(baseUrl: "http://10.0.2.2:27016/api");
  // final ApiClient _apiClient = ApiClient(baseUrl: "https://b089-80-208-67-11.ngrok.io/api");
  final String _entityContext = "GalleryEntry";
  final db = Localstore.instance;
  
  GalleryItemDataHandler();

  /// Gets all the gallery items from external API
  Future<List<GalleryItem>> getAll() async {
    try {
      var response = await _apiClient.get(_entityContext);
      Iterable jsonArray = json.decode(response.body);
      List<GalleryItem> galleryItems = List<GalleryItem>.from(
        jsonArray.map((jsonObject) => GalleryItem.fromMap(jsonObject)) // Turn json array into Gallery Item objects
        );
      
      // Caching items to local db, to enable offline use
      await db.collection(_entityContext).delete(); // Empty existing cache
      for (int i = 0; i < galleryItems.length; i++) {
        var galleryItem = galleryItems[i];
        final id = db.collection(_entityContext).doc().id; // Returns a new Id
        var map = galleryItem.toMap(); // Get item map
        // Save to local storage
        await db.collection(_entityContext).doc(id).set(map);
      }
      return galleryItems;
    }
    // on(TimeoutException, ) {
    catch (ex) {
      // Get data from local storage
      var localItems = await db.collection(_entityContext).get();
      if (localItems == null) {
        return [];
      }
      List<GalleryItem> galleryItems = [];
      // map localstorage items to GalleryItems
      for (int i = 0; i < localItems.entries.length; i++) {
        var map = localItems[localItems.entries.elementAt(i).key];
        galleryItems.add(GalleryItem.fromMap(map));
      }
      return galleryItems; // Return cached data
    }
  }

  /// Gets a gallery item from external API
  Future<GalleryItem> get(String id) async {
    var response = await _apiClient.get("$_entityContext/$id");
    GalleryItem galleryItem = GalleryItem.fromJson(response.body);
    return galleryItem;
  }

  /// Saves a gallery item on external API
  Future<GalleryItem> create(GalleryItem galleryItem) async {
    Map<String, dynamic> jsonBody = galleryItem.toMap();
    var response = await _apiClient.post(_entityContext, jsonBody);

    GalleryItem createdGalleryItem = GalleryItem.fromJson(response.body); // Should return the created model
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

  /// Updates a gallery items on external API
  Future<bool> edit(GalleryItem galleryItemChanges) async {
    Map<String, dynamic> jsonBody = galleryItemChanges.toMap();
    await _apiClient.put("$_entityContext/${galleryItemChanges.id}", jsonBody); // Saving response for easy extension refactor of the method
    return true;
  }
  
  /// Deletes a gallery items on external API
  Future<bool> delete(String id) async {
    await _apiClient.delete("$_entityContext/$id"); // Saving response for easy extension refactor of the method
    return true;
  }
}