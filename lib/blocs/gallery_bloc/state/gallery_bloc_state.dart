import 'package:gallery_with_rest_api/models/gallery_item.dart';

enum CrudStates { initial, loading, complete, error }

class GalleryCrudState {
  final CrudStates state;

  GalleryCrudState({
    required this.state
  });
}

class DisplayGalleryItems extends GalleryCrudState {
  final List<GalleryItem>? galleryItems;

  DisplayGalleryItems({
    required CrudStates state,
    this.galleryItems
    }) : super(state: state);
}

class DisplayGalleryItem extends GalleryCrudState {
  final GalleryItem? galleryItem;

  DisplayGalleryItem({
    required CrudStates state,
    this.galleryItem
    }) : super(state: state);
}