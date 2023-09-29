import 'dart:io';

class CroppedImageStorage {
  static final CroppedImageStorage _instance = CroppedImageStorage._internal();

  factory CroppedImageStorage() => _instance;

  CroppedImageStorage._internal();

  File? _croppedImageFile;

  File? get croppedImageFile => _croppedImageFile;

  void setCropImage(File file) {
    _croppedImageFile = file;
  }
}
