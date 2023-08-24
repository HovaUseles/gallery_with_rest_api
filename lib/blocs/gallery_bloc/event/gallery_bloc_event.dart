import 'dart:typed_data';

import 'package:gallery_with_rest_api/models/gallery_item.dart';

abstract class GalleryCrudEvent {}

class FetchGalleryItems extends GalleryCrudEvent {}


class FetchGalleryItem extends GalleryCrudEvent {
    final String id;

  FetchGalleryItem({
    required this.id
  });
}

class CreateGalleryItem extends GalleryCrudEvent {
  final String description;
  final String filename;
  final String filetype;
  final Uint8List imageBytes;

  CreateGalleryItem({
    required this.description,
    required this.filename,
    required this.filetype,
    required this.imageBytes
    });
}

class EditGalleryItem extends GalleryCrudEvent {
  final  GalleryItem galleryItem;

  EditGalleryItem({
    required this.galleryItem
  });
}

class DeleteGalleryItem extends GalleryCrudEvent {
  final String id;

  DeleteGalleryItem({
    required this.id
  });
}