import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Storage {
  File? image;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<dynamic>?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      this.image = File(image.path);
      String imageName = image.name;

      return [
        this.image,
        imageName,
      ];
    } catch (e) {
      rethrow;
    }
  }

  Future pickFile() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null){
      final response = result.files.first.path;
      File file = File(response!);
      String fileName = response.split("/").last;
      return [file, fileName];
    }
    return null;
  }

  Future<String?> uploadImage(String path, File file) async {
    try {
      Reference ref = _storage.ref();
      UploadTask response = ref.child(path).putFile(file);

      String? downloadUrl;

      await response.whenComplete(() async {
        downloadUrl = await response.snapshot.ref.getDownloadURL();
      });

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String path) async {
    await _storage.ref().child(path).delete();
  }

  // Future<void> deleteImage()
}
