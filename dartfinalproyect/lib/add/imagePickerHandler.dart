
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHandler{
  ImagePickerListener _listener;
  //static Future<PickedFile> imageFile;
  final ImagePicker _picker = ImagePicker();
  //static PickedFile galleryFile;

  ImagePickerHandler(this._listener);
  
  pickImageFromGallery(ImageSource source){
    _picker.getImage(source: source).then((value){
      cropImage(value!);
    });
  }

  Future<Null> cropImage(PickedFile galleryFile) async{
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: galleryFile.path,
      aspectRatioPresets: Platform.isAndroid
        ?
      [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ]
          :
      [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9,
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.black,
        toolbarWidgetColor:  Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false
      )
    );

    _listener.userImage(croppedFile!);
  }
}

abstract class ImagePickerListener{
  userImage(File _image);
}