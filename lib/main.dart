import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:gallery_with_rest_api/services/locators.dart';
import 'package:gallery_with_rest_api/widgets/gallery_item_editor_dialog.dart';
import 'package:gallery_with_rest_api/widgets/gallery_item_list.dart';

void main() {
  setupLocator();
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
        child: const BulletinBoardPage(), // Main page
      )
    );
  }
}

class BulletinBoardPage extends StatelessWidget {
  const BulletinBoardPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Bulletin Board"),
      ),
      body: const GalleryItemList(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: FloatingActionButton(
              tooltip: 'Add Image',
              onPressed: () => {
                // Insert images picker method here
                showDialog(
                  context: context,
                  builder: (context) {
                    // Error if Dialog context does not have its own BlocProvider, Ask Kris
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<GalleryItemCrudBloc>(
                          create: (context) => GalleryItemCrudBloc(),
                        ),
                      ],
                      child: GalleryItemEditorDialog()
                    );
                  }
                ),
              },
              child: const Icon(Icons.add_a_photo),
            ),
          ),
        ],
      ),
    );
  }
}
