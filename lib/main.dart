import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:gallery_with_rest_api/pages/bulletin_board_page.dart';
import 'package:gallery_with_rest_api/services/locators.dart';
import 'package:gallery_with_rest_api/widgets/gallery_item_editor_dialog.dart';
import 'package:gallery_with_rest_api/widgets/gallery_item_list.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bulletin board',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<GalleryItemCrudBloc>(
              create: (context) => GalleryItemCrudBloc(),
            ),
          ],
          child: const MainPage(), // Main page
        ));
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    GalleryItemCrudBloc crudBloc =
        BlocProvider.of<GalleryItemCrudBloc>(context); // Inject Bloc
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Gallery list"),
      ),
      drawer: Drawer(
        child: ListView(
          // Remove padding from list view
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary 
              ),
              child: const Text("Menu"),
            ),
            ListTile(
              leading: const Icon(
                Icons.list
              ),
              title: const Text("Gallery list"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.image
              ),
              title: const Text("Bulletin Board"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return BlocProvider.value(
                      value: crudBloc, 
                      child: const BulletinBoardPage(),
                    ) ;
                  }),
                );
              },
            )
          ],
        ),
      ),
      body: const GalleryItemList(),
      // body: BlocBuilder<GalleryItemCrudBloc, GalleryCrudState>(
      //   builder: (BuildContext context, GalleryCrudState state) {
      //     if (state.state == CrudStates.initial) {
      //       crudBloc.add(FetchGalleryItems()); // Fetch on initial
      //     }
      //     if (state is DisplayGalleryItems) {
      //       if (state.state == CrudStates.loading) {
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       if (state.state == CrudStates.error) {
      //         return const Text("An error occured.");
      //       }
      //       if(state.galleryItems == null) {
      //         return Text("No data");
      //       }
      //       return BulletinBoard(galleryItems: state.galleryItems!);
      //     }
      //   return Text("No Data");
      //   }
      // ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: FloatingActionButton(
              tooltip: 'Add Image',
              onPressed: () => {
                // Opens editor for gallery item
                showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return BlocProvider.value(
                        value: crudBloc,
                        child: const GalleryItemEditorDialog(),
                      );
                    }),
              },
              child: const Icon(Icons.add_a_photo),
            ),
          ),
        ],
      ),
    );
  }
}
