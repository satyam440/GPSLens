import 'package:shared_preferences/shared_preferences.dart';

class ImageStorage {
  static const imageKey = 'image_'; // Keep the variable private.

  static String getImageKey(int index) {
    return imageKey +
        index.toString(); // Public method to access the private variable.
  }

  static Future<void> storeImageDetails(
      int index, Map<String, dynamic> imageData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(getImageKey(index), imageData.toString());
  }

  static Future<Map<String, dynamic>?> getImageDetails(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final imageData = prefs.getString(getImageKey(index));
    if (imageData != null) {
      return Map<String, dynamic>.fromEntries(imageData.split(',').map((entry) {
        final parts = entry.split(':');
        return MapEntry(parts[0].trim(), parts[1].trim());
      }));
    } else {
      return null;
    }
  }
}
