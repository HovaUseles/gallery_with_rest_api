import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gallery_with_rest_api/blocs/gallery_bloc/event/gallery_bloc_event.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/state/gallery_bloc_state.dart';
import 'package:gallery_with_rest_api/data_access/gallery_entry_data_handler.dart';
import 'package:gallery_with_rest_api/models/gallery_item.dart';

class GalleryChangeBloc extends Bloc<GalleryCrudEvent, GalleryCrudState> {
  late GalleryEntryDataHandler _handler;

  GalleryChangeBloc() : super(GalleryCrudState()) {
    _handler = GalleryEntryDataHandler();
    List<GalleryItem> galleryItems = [];

    // Create event
    on<GalleryCreateEvent>((event, emit) async {
      await _handler.create(GalleryItem(
        description: event.description,
        filename: event.filename,
        filetype: event.filetype,
        imageBytes: event.imageBytes
      ));
    });

    // Edit event
    on<GalleryEditEvent>((event, emit) async {
      await _handler.edit(event.galleryItem);
    });

    // Get all event
    on<GalleryGetEvent>((event, emit) async {
      galleryItems = await _handler.getAll();
      emit(DisplayGalleryItems(galleryItems: galleryItems));
    });

    // Get by id
    on<GalleryGetByIdEvent>((event, emit) async {
      GalleryItem galleryItem = await _handler.get(event.id);
      emit(DisplayGalleryItem(galleryItem: galleryItem));
    });

    // Delete event
    on<GalleryDeleteEvent>((event, emit) async {
      await _handler.delete(event.id);
      add(GalleryGetEvent());
    });
  }
}