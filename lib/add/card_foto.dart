import 'dart:io';

import 'package:dartfinalproyect/add/imagePickerHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../global.dart';

class CardFotos extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CardFoto();
  }
}

class CardFoto extends State<CardFotos> with ImagePickerListener {
  late ImagePickerHandler imagePicker;
  static File? croppedFile;
  @override
  void initState(){
    super.initState();
    imagePicker = ImagePickerHandler(this);
  }
  Widget showImage(){
    if(croppedFile != null){
      return Image.file(
        croppedFile!,
        width: 300,
        height: 300,
      );
    }else{
      if(Global.doc != null){
        setState(() {});
        return Image.network(Global.doc!.Image);
      }else{
        return new Image.asset("assets/Gallo.png");
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return Column(
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            child: InkWell(
              child: Container(
                height: 200,
                width: 600,
                child: showImage(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                child: Text("Galeria"),
                color: Colors.white10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                onPressed: () {
                  imagePicker.pickImageFromGallery(ImageSource.gallery);
                },
              ),
              SizedBox(width: 10),
              FlatButton(
                child: Text("Camara"),
                color: Colors.white10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                onPressed: () {
                  imagePicker.pickImageFromGallery(ImageSource.camera);
                },
              ),
            ],
          ),
        ],
      );
  }

  @override
  userImage(File _image) {
    croppedFile = _image;
    setState(() {

    });
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<File>('croppedFile', croppedFile));
    properties.add(DiagnosticsProperty<File>('croppedFile', croppedFile));
    properties.add(DiagnosticsProperty<File>('croppedFile', croppedFile));
  }
}