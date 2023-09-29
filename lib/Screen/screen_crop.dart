import 'dart:io';
import 'package:flutter/material.dart';

class HalfCroppedImage extends StatelessWidget {
  final String imagePath;

  HalfCroppedImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Half Cropped Image'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
