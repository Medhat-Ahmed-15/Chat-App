import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  Function _pickedImageFunction;
  UserImagePicker(this._pickedImageFunction);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  void _pickImage() async {
    final pickedImagefile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality:
            50, //since 2n el  default size of the captured image is a littlt bit high so I made the quality  50
        maxWidth: 150 //to ensure that the image is small
        );
    setState(() {
      _pickedImage = pickedImagefile;
    });
    widget._pickedImageFunction(pickedImagefile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _pickedImage != null
              ? FileImage(
                  _pickedImage,
                )
              : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(
            Icons.image,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            'Add  image',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
