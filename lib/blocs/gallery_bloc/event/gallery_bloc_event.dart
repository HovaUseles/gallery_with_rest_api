import 'dart:typed_data';

import 'package:gallery_with_rest_api/models/gallery_item.dart';

abstract class GalleryCrudEvent {}

class GalleryGetEvent extends GalleryCrudEvent {}


class GalleryGetByIdEvent extends GalleryCrudEvent {
    final String id;

  GalleryGetByIdEvent({
    required this.id
  });
}

class GalleryCreateEvent extends GalleryCrudEvent {
  final String description;
  final String filename;
  final String filetype;
  final Uint8List imageBytes;

  GalleryCreateEvent({
    required this.description,
    required this.filename,
    required this.filetype,
    required this.imageBytes
    });
}

class GalleryEditEvent extends GalleryCrudEvent {
  final  GalleryItem galleryItem;

  GalleryEditEvent({
    required this.galleryItem
  });
}

class GalleryDeleteEvent extends GalleryCrudEvent {
  final String id;

  GalleryDeleteEvent({
    required this.id
  });
}