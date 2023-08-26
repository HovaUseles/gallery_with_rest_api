import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/event/gallery_bloc_event.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/state/gallery_bloc_state.dart';
import 'package:gallery_with_rest_api/models/gallery_item.dart';

class GalleryItemList extends StatelessWidget {
  const GalleryItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final GalleryItemCrudBloc crudBloc =
        BlocProvider.of<GalleryItemCrudBloc>(context); // Get Bloc instance

    return BlocBuilder<GalleryItemCrudBloc, GalleryCrudState>(
      builder: (BuildContext context, GalleryCrudState state) {
        if (state.state == CrudStates.initial) {
          crudBloc.add(FetchGalleryItems()); // Fetch on initial
        }
        if (state is DisplayGalleryItems) {
          if (state.state == CrudStates.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.state == CrudStates.error) {
            return const Text("An error occured.");
          }
          return ListView.builder(
            itemCount: state.galleryItems?.length ?? 0, // If null length is 0
            itemBuilder: (context, index) {
              final GalleryItem imageItem =
                  state.galleryItems![index]; // Get current item
              return Dismissible(
                key: Key("imageItem-$index-${imageItem.id}"),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => {
                  if (imageItem.id == null)
                    {
                      throw Exception(
                          "Id is not set on list item, cannot sync dismiss")
                    },
                  crudBloc.add(DeleteGalleryItem(
                      id: imageItem.id! // Id should never be null
                      ))
                },
                // Background when sliding item
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 56, // Image radius
                    backgroundImage: MemoryImage(imageItem.imageBytes),
                  ),
                  title: Text(imageItem.filename),
                  subtitle: Text(imageItem.description),
                  trailing: Text(imageItem.filetype),
                ),
              );
            },
          );
        }
        return const Text("No data");
      },
    );
    // Center(
    //   child: IconButton(
    //       onPressed: () {
    //         crudBloc.add(FetchGalleryItems());
    //       },
    //       icon: const Icon(Icons.refresh)),
    // )
  }
}
