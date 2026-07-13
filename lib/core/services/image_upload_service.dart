import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();

  /// Pick Image

  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) {
      return null;
    }

    return File(image.path);
  }

  /// Upload Image

 Future<String> uploadImage(
  File image,
  String folder,
) async {

  try {

    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}.jpg";

    final ref = FirebaseStorage.instance
        .ref()
        .child(folder)
        .child(fileName);

    await ref.putFile(image);

    return await ref.getDownloadURL();

  } catch (e) {

    print("====================");
    print(e);
    print("====================");

    rethrow;
  }
}

  /// Delete Image

  Future<void> deleteImage(
    String imageUrl,
  ) async {
    try {
      await _storage.refFromURL(imageUrl).delete();
    } catch (_) {}
  }
}