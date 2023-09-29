import 'dart:async';
import 'package:GPSLens/picture_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:GPSLens/wheather/wheather_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/croped_image_store.dart';
import 'image_with_ovrelay.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String? latitudeText;
  String? longitudeText;
  String? currentTimeText = '';
  String? currentDateText = '';
  String stateName = "";
  String address = "";
  String area = "";
  String postalCode = "";
  String city = "";
  bool isLoading = true;
  String weatherIcon = '';
  String temperatureCelsius = '';
  String temperatureFahrenheit = '';
  int _clickCount = 0;
  String? _firstStoredImagePath;
  String? firstPictureStoredImagePath;
  String? imagePath;
  bool isClicked = false;

  final WeatherModel _weatherModel = WeatherModel();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();

    // Start updating current date and time every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      updateCurrentDateTime();
    });

    fetchInitialData(); // Fetch location details and weather on init
  }

  void updateCurrentDateTime() {
    DateTime now = DateTime.now();
    String day = DateFormat('EEE').format(now);
    String formattedDate = '${now.year}-${now.month}-${now.day}';

    String period = now.hour >= 12 ? '(pm)' : '(am)';
    int hourOfDay = now.hour % 12;
    if (hourOfDay == 0) {
      hourOfDay = 12; // Convert 0 to 12 for 12-hour format
    }
    String formattedTime =
        '${hourOfDay.toString()}:${now.minute.toString().padLeft(2, '0')} $period';

    setState(() {
      currentTimeText = formattedTime;
      currentDateText =
          '$formattedDate ($day)'; // Include the day in the date string
    });

    print(formattedDate);
    print(formattedTime);
  }

  Future<void> printCurrentDateTime() async {
    DateTime now = DateTime.now();
    String day = DateFormat('EEE').format(now);
    String formattedDate = '${now.year}-${now.month}-${now.day}';

    String period = now.hour >= 12 ? '(pm)' : '(am)';
    int hourOfDay = now.hour % 12;
    if (hourOfDay == 0) {
      hourOfDay = 12; // Convert 0 to 12 for 12-hour format
    }
    String formattedTime =
        '${hourOfDay.toString()}:${now.minute.toString().padLeft(2, '0')} $period';

    setState(() {
      currentTimeText = formattedTime;
      currentDateText =
          '$formattedDate ($day)'; // Include the day in the date string
    });

    print(formattedDate);
    print(formattedTime);
  }

  Future<void> fetchInitialData() async {
    try {
      Position position = await getCurrentLocation();
      latitudeText = '${position.latitude}';
      longitudeText = '${position.longitude}';

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          stateName = placemark.administrativeArea ?? "";
          area = placemark.subLocality ?? "";
          postalCode = placemark.postalCode ?? "";
          address = placemark.name ?? "";
          city = placemark.locality ?? "";
          isLoading = false;
        });
      }

      // Fetch weather data using latitude and longitude
      var weatherData = await _weatherModel.getLocationWeather();
      int condition = weatherData['weather'][0]['id'];
      setState(() {
        weatherIcon = _weatherModel.getWeatherIcon(condition);
        temperatureCelsius = '${weatherData['main']['temp']}°C';
        double temperatureInFahrenheit =
            (weatherData['main']['temp'] * 9 / 5) + 32;
        temperatureFahrenheit =
            '${temperatureInFahrenheit.toStringAsFixed(1)}°F';
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching location or weather data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Position> getCurrentLocation() async {
    // Request location permission if not granted
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception("Location permission not granted.");
      }
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: CameraPreview(_controller),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 180.0, right: 20),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: FloatingActionButton(
                                  onPressed: () => _onCameraButtonPressed(),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Image.network(
                            "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/w_2560%2Cc_limit/GoogleMapTA.jpg",
                            // "https://maps.googleapis.com/maps/api/staticmap?center=51.477222,0&zoom=14&size=400x400&key=YOUR_GOOGLE_MAPS_API_KEY",
                            width: 170,
                            height: 170,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
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
                                    "$address, $area ,$city, $stateName, $postalCode, India",
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
                                    area, // Replace with your area name
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
                                    stateName,
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
                                    '$currentDateText    $currentTimeText',
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
                                    '      $latitudeText      $longitudeText',
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
                          padding:
                              const EdgeInsets.only(right: 30.0, bottom: 30),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  weatherIcon,
                                  style: const TextStyle(
                                    fontSize: 35,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  temperatureCelsius,
                                  style: GoogleFonts.cantoraOne(
                                    color: const Color.fromRGBO(
                                        183, 200, 181, 1.0),
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  temperatureFahrenheit,
                                  style: GoogleFonts.cantoraOne(
                                    color: const Color.fromRGBO(
                                        183, 200, 181, 1.0),
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
      ),
    );
  }

  ScreenshotController ssController = ScreenshotController();

  void _onCameraButtonPressed() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      var imagePath = image.path;
      if (!mounted) return;

      // Read the image file
      File imageFile = File(imagePath);
      List<int> bytes = await imageFile.readAsBytes();
      img.Image originalImage = img.decodeImage(bytes)!;

      // Calculate the new width and height (half of the original width and height)
      int newWidth = originalImage.width;
      int newHeight = originalImage.height ~/ 2;

      // Calculate the top and left positions for cropping (top half)
      int top = newHeight; // Adjusted for the bottom half
      int left = 0; // Keep left position at 0 for the full width

      // Crop the image from the bottom half
      img.Image croppedImage =
          img.copyCrop(originalImage, left, top, newWidth, newHeight);

      // Encode the cropped image to bytes
      List<int> croppedBytes = img.encodeJpg(croppedImage);

      // Save the cropped image to the local app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
      final savedImagePath = '${appDir.path}/$fileName';
      final savedImagePathWithoutCrop = '${appDir.path}/$fileName';
      await File(savedImagePath).writeAsBytes(croppedBytes);
      await File(savedImagePathWithoutCrop).writeAsBytes(bytes);
      CroppedImageStorage().setCropImage(File(savedImagePath));

      setState(() {
        _clickCount++;
        // Update the first stored image path with the current image path
        if (!isClicked) {
          _firstStoredImagePath = savedImagePath;
          // Store the first image path in shared preferences
          _storeFirstImageInSharedPreferences(savedImagePath);
          // Set the firstPictureStoredImagePath with the current image path
          firstPictureStoredImagePath = savedImagePath;
          isClicked = true;
        }
      });
      imagePath = savedImagePath;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PictureDetailsScreen(
            imagePath: savedImagePath,
            imagePathFull: savedImagePathWithoutCrop,
            latitude: latitudeText!,
            longitude: longitudeText!,
            currentTime: currentTimeText!,
            currentDate: currentDateText!,
            stateName: stateName,
            area: area,
            address: address,
            temperatureCelsius: temperatureCelsius,
            temperatureFahrenheit: temperatureFahrenheit,
            weatherIcon: weatherIcon,
            city: city,
            postalCode: postalCode,
            clickCount: _clickCount,
            firstPicturePath: _firstStoredImagePath,
            firstPictureStoredImagePath: firstPictureStoredImagePath,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void _storeFirstImageInSharedPreferences(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstImage', imagePath);
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
    final file = File(imagePath!);
    final data = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
