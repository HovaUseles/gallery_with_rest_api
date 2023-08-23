import 'package:gallery_with_rest_api/models/gallery_item.dart';

class GalleryCrudState {
  GalleryCrudState();
}

class DisplayGalleryItems extends GalleryCrudState {
  final List<GalleryItem> galleryItems;

  DisplayGalleryItems({
    required this.galleryItems
    });
}

class DisplayGalleryItem extends GalleryCrudState {
  final GalleryItem galleryItem;

  DisplayGalleryItem({
    required this.galleryItem
    });
} 
/*
class GalleryChangeState {
  late List<GalleryItem>? _galleryItems;
  final GalleryEntryDataHandler _handler = GalleryEntryDataHandler();

  List<GalleryItem>? get galleryItems => _galleryItems;

  GalleryChangeState init() {
    return GalleryChangeState().._galleryItems = null;
  }
  
  Future<GalleryChangeState> get() async {
    return GalleryChangeState()
      .._galleryItems = await _handler.getAll();
  }

  Future<GalleryChangeState> create(GalleryItem galleryItem) async {
    await _handler.create(galleryItem);
    return GalleryChangeState()
      .._galleryItems = await _handler.getAll();
  }

  Future<GalleryChangeState> edit(GalleryItem galleryItem) async {
    await _handler.edit(galleryItem);
    return GalleryChangeState()
      .._galleryItems = await _handler.getAll();
  }
  
  Future<GalleryChangeState> delete(GalleryItem galleryItem) async {
    await _handler.delete(galleryItem);
    return GalleryChangeState()
      .._galleryItems = await _handler.getAll();
  }
}
*/