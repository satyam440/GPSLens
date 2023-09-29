class ImageDetails {
  final String imagePath;
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

  ImageDetails({
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.currentTime,
    required this.currentDate,
    required this.stateName,
    required this.weatherIcon,
    required this.temperatureCelsius,
    required this.temperatureFahrenheit,
    required this.address,
    required this.area,
    required this.postalCode,
    required this.city,
    required this.clickCount,
  });
}
