import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gallery_with_rest_api/blocs/gallery_bloc/event/gallery_bloc_event.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/state/gallery_bloc_state.dart';
import 'package:gallery_with_rest_api/data_access/gallery_entry_data_handler.dart';
import 'package:gallery_with_rest_api/models/gallery_item.dart';
import 'package:gallery_with_rest_api/services/locators.dart';

class GalleryItemCrudBloc extends Bloc<GalleryCrudEvent, GalleryCrudState> {

  GalleryItemCrudBloc() : super(DisplayGalleryItems(state: CrudStates.initial)) {
    List<GalleryItem> galleryItems = [];

    // Create event handler
    on<CreateGalleryItem>((event, emit) async {
      GalleryItemDataHandler handler = locator<GalleryItemDataHandler>(); // Inject handler
      await handler.create(GalleryItem(
        description: event.description,
        filename: event.filename,
        filetype: event.filetype,
        imageBytes: event.imageBytes
      ));
      emit(DisplayGalleryItems(state: CrudStates.loading)); // Emit loading state
      try {
        emit(DisplayGalleryItems(
            state: CrudStates.complete, 
            galleryItems: await handler.getAll())
        );
      }
      catch(ex) {
        emit(DisplayGalleryItems(state: CrudStates.error)); // Emit error state
      }
    });

    // Edit event handler
    on<EditGalleryItem>((event, emit) async {
      GalleryItemDataHandler handler = locator<GalleryItemDataHandler>(); // Inject handler
      await handler.edit(event.galleryItem);
    });

    // Get all event handler
    on<FetchGalleryItems>((event, emit) async {
      emit(DisplayGalleryItems(state: CrudStates.loading)); // Emit loading state
      GalleryItemDataHandler handler = locator<GalleryItemDataHandler>(); // Inject handler
      try {
        galleryItems = await handler.getAll();
        emit(DisplayGalleryItems(
            state: CrudStates.complete, 
            galleryItems: galleryItems)
        );
      }
      catch(ex) {
        emit(DisplayGalleryItems(state: CrudStates.error)); // Emit error state
      }
    });

    // Get by id handler
    on<FetchGalleryItem>((event, emit) async {
      emit(DisplayGalleryItem(state: CrudStates.loading)); // Emit loading state
      GalleryItemDataHandler handler = locator<GalleryItemDataHandler>(); // Inject handler
      try {
        GalleryItem galleryItem = await handler.get(event.id);
        emit(
          DisplayGalleryItem(
            state: CrudStates.complete, 
            galleryItem: galleryItem)
        );
      }
      catch (ex) {
        emit(DisplayGalleryItem(state: CrudStates.error)); // Emit error state
      }
    });

    // Delete event handler
    on<DeleteGalleryItem>((event, emit) async {
      GalleryItemDataHandler handler = locator<GalleryItemDataHandler>(); // Inject handler
      await handler.delete(event.id);
    });
  }
}