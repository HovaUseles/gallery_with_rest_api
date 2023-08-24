import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_with_rest_api/Utilities/utilities.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/event/gallery_bloc_event.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:image_picker/image_picker.dart';

class GalleryItemEditorDialog extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late XFile selectedImage;
  late Uint8List imageBytes; 
  final TextEditingController _filenameFieldController = TextEditingController();
  final TextEditingController _descriptionFieldController = TextEditingController();

  GalleryItemEditorDialog({super.key, String? filename, String? description}) {
    _filenameFieldController.value = TextEditingValue(text: filename ?? "");
    _descriptionFieldController.value = TextEditingValue(text: description ?? "");
  }

  @override
  Widget build(BuildContext context) {
    GalleryItemCrudBloc crudBloc = BlocProvider.of<GalleryItemCrudBloc>(context); // Inject Bloc
    return Dialog(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Image.memory(imageBytes), // Display chosen image
              ElevatedButton(
                onPressed: () async {
                  var pickedImage = await Utilities.pickImageFromGallery();
                  if(pickedImage != null) {
                    selectedImage = pickedImage;
                  }
                },
                child: const Text("Pick image"),
              ),
              // Build formfields
              TextFormField(
                controller: _filenameFieldController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image filename';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionFieldController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Send new item to Bloc
                    crudBloc.add(
                      CreateGalleryItem(
                        description: _descriptionFieldController.text,
                        filename: _filenameFieldController.text,
                        filetype: selectedImage.name.split('.').last, // Get filetype from filename
                        imageBytes: imageBytes,
                      ),
                    );

                    // Clear inputs and close dialog
                    _filenameFieldController.clear();
                    _descriptionFieldController.clear();
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save Image"))
            ],
          ),
        ),
      ),
    );
  }
}