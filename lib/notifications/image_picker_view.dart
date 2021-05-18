import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerView extends StatefulWidget {
  final Function(File image) onImageSelection;
  ImagePickerView({Key key, @required this.onImageSelection}) : super(key: key);

  @override
  _ImagePickerViewState createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<ImagePickerView> {
  File _image;

  _imgFromGallery() async {
    ImagePicker _imagePicker = ImagePicker();
    PickedFile image = await _imagePicker.getImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: _imgFromGallery,
        child: _image == null
            ? Icon(Icons.add_a_photo)
            : Image.file(
                _image,
              ),
      ),
    );
  }
}
