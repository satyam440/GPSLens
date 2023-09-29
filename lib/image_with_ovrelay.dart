import 'dart:io';
import 'package:flutter/material.dart';

class ImageGridScreen extends StatelessWidget {
  final List<String> imagePaths;

  ImageGridScreen({required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Saved Image'),
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // Adjust the number of columns as needed
          ),
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            final imagePath = imagePaths[index];
            return Padding(
              padding: const EdgeInsets.only(
                  right: 3, top: 3), // Adjust the margin as needed
              child: InkWell(
                onTap: () {
                  // Navigate to the FullScreenImageScreen when an image is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenImageScreen(imagePath: imagePath),
                    ),
                  );
                },
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FullScreenImageScreen extends StatelessWidget {
  final String imagePath;

  const FullScreenImageScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
