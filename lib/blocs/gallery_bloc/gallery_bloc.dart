import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gallery_with_rest_api/blocs/gallery_bloc/event/gallery_bloc_event.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/state/gallery_bloc_state.dart';
import 'package:gallery_with_rest_api/data_access/gallery_entry_data_handler.dart';
import 'package:gallery_with_rest_api/models/gallery_item.dart';
import 'package:gallery_with_rest_api/services/locators.dart';

class GalleryItemCrudBloc extends Bloc<GalleryCrudEvent, GalleryCrudState> {

  Future<void> _tryEmitGalleryItems(emit) async {
    GalleryItemDataHandler handler = locator<GalleryItemDataHandler>(); // Inject handler

    // Try emitting updated GalleryItem list
    emit(DisplayGalleryItems(state: CrudStates.loading)); // Emit loading state
    try {
      List<GalleryItem> items = await handler.getAll();
      emit(DisplayGalleryItems(
          state: CrudStates.complete, 
          galleryItems: items)
      );
    }
    catch(ex) {
      emit(DisplayGalleryItems(state: CrudStates.error)); // Emit error state
    }
  }

  GalleryItemCrudBloc() : super(DisplayGalleryItems(state: CrudStates.initial)) {

    // Create event handler
    on<CreateGalleryItem>((event, emit) async {
      GalleryItemDataHandler handler = locator<GalleryItemDataHandler>(); // Inject handler
      // Create the new GalleryItem in data source
      await handler.create(GalleryItem(
        description: event.description,
        filename: event.filename,
        filetype: event.filetype,
        imageBytes: event.imageBytes
      ));
      
      await _tryEmitGalleryItems(emit);
    });

    // Edit event handler
    on<EditGalleryItem>((event, emit) async {
      GalleryItemDataHandler handler = locator<GalleryItemDataHandler>(); // Inject handler
      await handler.edit(event.galleryItem);
    });

    // Get all event handler
    on<FetchGalleryItems>((event, emit) async {
      emit(DisplayGalleryItems(state: CrudStates.loading)); // Emit loading state
      
      await _tryEmitGalleryItems(emit);
    });

    // Get by id handler
    on<FetchGalleryItem>((event, emit) async {
      emit(DisplayGalleryItem(state: CrudStates.loading)); // Emit loading state

      await _tryEmitGalleryItems(emit);
    });

    // Delete event handler
    on<DeleteGalleryItem>((event, emit) async {
      GalleryItemDataHandler handler = locator<GalleryItemDataHandler>(); // Inject handler
      await handler.delete(event.id);
      
      await _tryEmitGalleryItems(emit);
    });
  }
}