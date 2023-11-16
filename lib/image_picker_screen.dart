import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? image;

  _displayImageDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true, //true-out side click dissmisses
        builder: (param) {
          return AlertDialog(
            title: Text('Get Image'),
            content: SingleChildScrollView(
              child: Column(children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(15, 53, 73, 1)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    pickImage('Gallery');
                    print('----------> uploaded from gallery');
                    Navigator.pop(context);
                  },
                  child: Text('Gallery'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(15, 53, 73, 1)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    print('---------> Image: $image');
                    pickImage('Camera');
                    Navigator.pop(context);
                    print('---------->uploaded from camera');
                  },
                  child: Text('Camera'),
                )
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Reference'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image == null
                  ? Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: FlutterLogo(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: ClipOval(
                        child: Image.file(
                          image!, // File Path
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              SizedBox(
                width: 80,
              ),
              SizedBox(
                height: 40,
                width: 125,
                child: ElevatedButton(
                    onPressed: () {
                      _displayImageDialog(context);
                    },
                    child: Text('Add Photo')),
              )
            ],
          ),
        ),
      ),
    );
  }

  void pickImage(String tmpOption) async{
    late final image;

    if(tmpOption == 'Gallery'){
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }else if(tmpOption == 'Camera'){
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    }

    try {

      if (image == null) return;

      final imageTemp = File(image.path);

      print('Image Path: $image.path');

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
