import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/event/gallery_bloc_event.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:gallery_with_rest_api/models/gallery_item.dart';
import 'package:gallery_with_rest_api/services/locators.dart';
import 'package:gallery_with_rest_api/widgets/gallery_item_list.dart';
import 'package:image_picker/image_picker.dart';

import 'Utilities/utilities.dart';

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
                    return Dialog();
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
