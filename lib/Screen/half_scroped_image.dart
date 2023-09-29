import 'dart:io';
import 'package:GPSLens/Screen/croped_image_store.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../image_storage.dart';

class HalfCroppedImageScr extends StatefulWidget {
  final String imagePath;

  HalfCroppedImageScr({required this.imagePath});

  @override
  _HalfCroppedImageScrState createState() => _HalfCroppedImageScrState();
}

class _HalfCroppedImageScrState extends State<HalfCroppedImageScr> {
  // Remove the late keyword since we'll be using the ImageStorage singleton to store the image
  // late File _croppedImageFile;

  @override
  void initState() {
    super.initState();
    _saveCroppedImageLocally();
  }

  Future<void> _saveCroppedImageLocally() async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now()}.jpg';
    final savedImagePath = '${appDir.path}/$fileName';

    File(widget.imagePath).copy(savedImagePath).then((file) {
      // Use the ImageStorage singleton to store the image file globally
      CroppedImageStorage().setCropImage(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: CroppedImageStorage().croppedImageFile != null
              ? DecorationImage(
                  image: FileImage(CroppedImageStorage().croppedImageFile!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: const Center(
          child: Text(
            'Your content goes here',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
