import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'take_picture_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  // Set preferred orientations to landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Location Permission App',
          home: LocationPermissionWrapper(
            camera: camera,
            child: TakePictureScreen(camera: camera),
          ),
        );
      },
    );
  }
}

class LocationPermissionWrapper extends StatefulWidget {
  final CameraDescription camera;
  final Widget child;

  const LocationPermissionWrapper({
    Key? key,
    required this.camera,
    required this.child,
  }) : super(key: key);

  @override
  _LocationPermissionWrapperState createState() =>
      _LocationPermissionWrapperState();
}

class _LocationPermissionWrapperState extends State<LocationPermissionWrapper> {
  bool locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the case where permission is not granted
      }
    }

    setState(() {
      locationPermissionGranted = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    });
  }

  @override
  Widget build(BuildContext context) {
    return locationPermissionGranted ? widget.child : Container();
  }
}
