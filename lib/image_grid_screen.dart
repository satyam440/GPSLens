import 'package:GPSLens/picture_detail_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';

class GalleryPage extends StatelessWidget {
  final List<Map<String, dynamic>> galleryData;

  GalleryPage({required this.galleryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gallery')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: galleryData.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> imageData = galleryData[index];
          return GestureDetector(
            onTap: () {
              // Navigate to a new page to show the image in full detail.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PictureDetailsScreen(
                    // Pass the image data to PictureDetailsScreen.
                    imagePath: imageData['imagePath'],
                    imagePathFull: imageData['imagePathFull'],
                    latitude: imageData['latitude'],
                    longitude: imageData['longitude'],
                    currentTime: imageData['currentTime'],
                    currentDate: imageData['currentDate'],
                    stateName: imageData['stateName'],
                    weatherIcon: imageData['weatherIcon'],
                    temperatureCelsius: imageData['temperatureCelsius'],
                    temperatureFahrenheit: imageData['temperatureFahrenheit'],
                    address: imageData['address'],
                    area: imageData['area'],
                    postalCode: imageData['postalCode'],
                    city: imageData['city'],
                    clickCount: imageData['clickCount'],
                  ),
                ),
              );
            },
            child: Image.file(
              File(imageData['imagePath']),
              fit: BoxFit.cover,
            ),
          );
        },
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
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: imagePath,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }
}
