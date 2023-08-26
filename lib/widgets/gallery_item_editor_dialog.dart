import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_with_rest_api/Utilities/utilities.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/event/gallery_bloc_event.dart';
import 'package:gallery_with_rest_api/blocs/gallery_bloc/gallery_bloc.dart';
import 'package:image_picker/image_picker.dart';

class GalleryItemEditorDialog extends StatefulWidget {
  final String? _filename;
  final String? _description;
  final Uint8List? _imageBytes;

  const GalleryItemEditorDialog({super.key, String? filename, String? description, Uint8List? imageBytes}) :
    _filename = filename ?? "",
    _description = description ?? "",
    _imageBytes = imageBytes;

  @override
  State<GalleryItemEditorDialog> createState() =>
      _GalleryItemEditorDialogState();
}

class _GalleryItemEditorDialogState extends State<GalleryItemEditorDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? selectedImage;
  Uint8List? imageBytes;
  final TextEditingController _filenameFieldController =
      TextEditingController();
  final TextEditingController _descriptionFieldController =
      TextEditingController();

  @override
  void initState() {
    _filenameFieldController.text = widget._filename ?? "";
    _descriptionFieldController.text = widget._description ?? "";
    imageBytes = widget._imageBytes;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GalleryItemCrudBloc crudBloc =
        BlocProvider.of<GalleryItemCrudBloc>(context); // Inject Bloc
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Future builder waiting for a image to be selected
              FutureBuilder(
                future: selectedImage?.readAsBytes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(snapshot.data!);
                  }
                  return const Text("Please select image");
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        var pickedImage = await Utilities.takeImageWithCamera();
                        if (pickedImage != null) {
                          selectedImage = pickedImage;
                          imageBytes = await pickedImage.readAsBytes();
                          setState(() {});
                        }
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.camera),
                          Text("Take image"),
                        ],
                      )   
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        var pickedImage = await Utilities.pickImageFromGallery();
                        if (pickedImage != null) {
                          selectedImage = pickedImage;
                          imageBytes = await pickedImage.readAsBytes();
                          setState(() {});
                        }
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.image),
                          Text("Pick image"),
                        ],
                      )   
                    ),
                  ],
                ),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Send new item to Bloc
                        crudBloc.add(
                          CreateGalleryItem(
                            description: _descriptionFieldController.text,
                            filename: _filenameFieldController.text,
                            filetype: selectedImage!.name
                                .split('.')
                                .last, // Get filetype from filename
                            imageBytes: imageBytes!,
                          ),
                        );

                        // Clear inputs and close dialog
                        _filenameFieldController.clear();
                        _descriptionFieldController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Save Image")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
