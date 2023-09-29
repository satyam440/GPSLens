import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'image_with_ovrelay.dart';

class PictureDetailsScreen extends StatefulWidget {
  final String imagePath;
  final String imagePathFull;
  final String latitude;
  final String longitude;
  final String currentTime;
  final String currentDate;
  final String stateName;
  final String weatherIcon;
  final String temperatureCelsius;
  final String temperatureFahrenheit;
  final String address;
  final String area;
  final String postalCode;
  final String city;
  final int clickCount;
  final String? firstPictureStoredImagePath;
  final String? firstPicturePath;

  PictureDetailsScreen(
      {required this.imagePath,
      required this.imagePathFull,
      required this.latitude,
      required this.longitude,
      required this.currentTime,
      required this.currentDate,
      required this.stateName,
      required this.area,
      required this.address,
      required this.temperatureCelsius,
      required this.temperatureFahrenheit,
      required this.weatherIcon,
      required this.city,
      required this.postalCode,
      required this.clickCount,
      this.firstPictureStoredImagePath,
      this.firstPicturePath});

  @override
  State<PictureDetailsScreen> createState() => _PictureDetailsScreenState();
}

class _PictureDetailsScreenState extends State<PictureDetailsScreen> {
  ScreenshotController ssController = ScreenshotController();
  String? firstPictureStoredImag; // Add this line

  @override
  void initState() {
    super.initState();
    // Initialize the firstPictureStoredImagePath from widget property
    firstPictureStoredImag = widget.firstPictureStoredImagePath;
    // If it's not provided in the widget, retrieve it from shared preferences
    if (firstPictureStoredImag == null) {
      _getFirstPictureFromSharedPreferences();
    }
    print('firstPictureStoredImagePath: $firstPictureStoredImag');
  }

  Future<void> _getFirstPictureFromSharedPreferences() async {
    print('Getting first picture path from SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    firstPictureStoredImag = prefs.getString('firstPicturePath');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ui.Image>(
        future: loadImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Screenshot(
              controller: ssController,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(widget.imagePathFull), fit: BoxFit.cover),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      width: 170,
                      height: 170,
                      // child: Image.network(
                      //   "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/w_2560%2Cc_limit/GoogleMapTA.jpg",
                      //   width: 170,
                      //   height: 170,
                      //   fit: BoxFit.cover,
                      // ),
                      child: Image.network(
                        "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/w_2560%2Cc_limit/GoogleMapTA.jpg",
                        width: 170,
                        height: 170,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  widget.clickCount % 2 == 0 && widget.firstPicturePath != null
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width - 170,
                            // color: const Color.fromRGBO(130, 111, 106, 2.0)
                            //     .withOpacity(0.6),
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 50),
                            decoration: BoxDecoration(
                              image: firstPictureStoredImag != null
                                  ? DecorationImage(
                                      image: FileImage(File(
                                          widget.firstPictureStoredImagePath!)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "${widget.address}, ${widget.area}, ${widget.city}, ${widget.stateName}, ${widget.postalCode}, India",
                                    style: GoogleFonts.cantoraOne(
                                      color: const Color.fromRGBO(
                                          183, 200, 181, 1.0),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: Text(
                                    widget.area,
                                    style: GoogleFonts.cantoraOne(
                                        color: const Color.fromRGBO(
                                            183, 200, 181, 1.0),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: Text(
                                    widget.stateName,
                                    style: GoogleFonts.cantoraOne(
                                        color: const Color.fromRGBO(
                                            183, 200, 181, 1.0),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: Text(
                                    "India",
                                    style: GoogleFonts.cantoraOne(
                                        color: const Color.fromRGBO(
                                            183, 200, 181, 1.0),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: Text(
                                    '${widget.currentDate}      ${widget.currentTime}',
                                    style: GoogleFonts.cantoraOne(
                                      color: const Color.fromRGBO(
                                          183, 200, 181, 1.0),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: Text(
                                    '     ${widget.latitude}        ${widget.longitude}',
                                    style: GoogleFonts.cantoraOne(
                                      color: const Color.fromRGBO(
                                          183, 200, 181, 1.0),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 170,
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 40),
                            color: const Color.fromRGBO(130, 111, 106, 2.0)
                                .withOpacity(0.6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "${widget.address}, ${widget.area} ,${widget.city}, ${widget.stateName}, ${widget.postalCode}, India",
                                    style: GoogleFonts.cantoraOne(
                                      color: const Color.fromRGBO(
                                          183, 200, 181, 1.0),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Center(
                                  child: Text(
                                    widget.area, // Replace with your area name
                                    style: GoogleFonts.cantoraOne(
                                        //rgb(167,168,163)
                                        color: const Color.fromRGBO(
                                            183, 200, 181, 1.0),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Center(
                                  child: Text(
                                    widget.stateName,
                                    style: GoogleFonts.cantoraOne(
                                        color: const Color.fromRGBO(
                                            183, 200, 181, 1.0),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Center(
                                  child: Text(
                                    "India",
                                    style: GoogleFonts.cantoraOne(
                                        color: const Color.fromRGBO(
                                            183, 200, 181, 1.0),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Center(
                                  child: Text(
                                    '${widget.currentDate}    ${widget.currentTime}',
                                    style: GoogleFonts.cantoraOne(
                                      color: const Color.fromRGBO(
                                          183, 200, 181, 1.0),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Center(
                                  child: Text(
                                    '      ${widget.latitude}      ${widget.longitude}',
                                    style: GoogleFonts.cantoraOne(
                                      color: const Color.fromRGBO(
                                          183, 200, 181, 1.0),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0, bottom: 30),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.weatherIcon,
                            style: const TextStyle(
                              fontSize: 40,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.temperatureCelsius,
                            style: GoogleFonts.cantoraOne(
                              color: const Color.fromRGBO(183, 200, 181, 1.0),
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            widget.temperatureFahrenheit,
                            style: GoogleFonts.cantoraOne(
                              color: const Color.fromRGBO(183, 200, 181, 1.0),
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 180.0),
        child: FloatingActionButton(
          onPressed: shareImage,
          child: Icon(Icons.save),
        ),
      ),
    );
  }

  List<String> savedImagePaths = [];

  Color calculateBackgroundColor() {
    int colorIndex = widget.clickCount % 5;
    if (colorIndex == 0) {
      return const Color.fromRGBO(130, 111, 106, 2.0).withOpacity(0.6);
    } else {
      return Colors.transparent;
    }
  }

  Future<void> shareImage() async {
    final uint8List = await ssController.capture();
    if (uint8List == null) {
      print('Failed to capture screenshot');
      return;
    }

    String tempPath = (await getTemporaryDirectory()).path;
    String fileName = '${DateTime.now().microsecondsSinceEpoch}.png';
    File file = File('$tempPath/$fileName');
    await file.writeAsBytes(uint8List);

    // Save the screenshot file path to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedImagePaths =
        prefs.getStringList('savedImages') ?? [];
    savedImagePaths.add(file.path);
    prefs.setStringList('savedImages', savedImagePaths);

    // Display a message to the user indicating that the screenshot has been saved
    print('Screenshot saved successfully: ${file.path}');

    // Navigate to the next page (ImageGridScreen)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageGridScreen(imagePaths: savedImagePaths),
      ),
    );
  }

  Future<ui.Image> loadImage() async {
    final file = File(widget.imagePath);
    final data = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
