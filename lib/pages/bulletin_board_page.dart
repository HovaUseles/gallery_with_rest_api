import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/event/gallery_bloc_event.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/state/gallery_bloc_state.dart';
import 'package:gallery_with_rest_api/widgets/bulletin_board.dart';

class BulletinBoardPage extends StatelessWidget {
  const BulletinBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    GalleryItemCrudBloc crudBloc =
        BlocProvider.of<GalleryItemCrudBloc>(context); // Inject Bloc
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Bulletin Board"),
      ),
      body: BlocBuilder<GalleryItemCrudBloc, GalleryCrudState>(
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
          if (state.galleryItems == null) {
            return const Text("No data");
          }
          return BulletinBoard(galleryItems: state.galleryItems!);
        }
        return const Text("No Data");
      }),
      floatingActionButton: FloatingActionButton(
        tooltip: "Reset",
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider.value(
                  value: crudBloc,
                  child: const BulletinBoardPage(),
                );
              },
            ),
          );
        },
        child: const Icon(Icons.restart_alt),
      ),
    );
  }
}
