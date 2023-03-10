import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeprofileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;
  late ImagePicker imagePicker;

  XFile? pickedImage;

  // Membuat jembatan masukk ke firebase storage
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> uploadImage(String uid) async {
    // Untuk masukk ke referensi, kalau kosong berarti masuk ke root utama
    Reference storageRef = storage.ref('$uid.png');
    File file = File(pickedImage!.path);

    try {
      await storageRef.putFile(file); //putFile mengambil file darii galeri
      final photoUrl = await storageRef.getDownloadURL();
      resetImage();
      return photoUrl;
    } catch (err) {
      print(err);
      return null;
    }
  }

  void resetImage() {
    pickedImage = null;
    update();
  }

  void selectImage() async {
    // try catch untuk berjaga jaga ketika erroe terjadi
    try {
      final checkDataImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      // Cek agar tidak error kerika tidak ada data yang dibawa
      if (checkDataImage != null) {
        print(checkDataImage.name);
        print(checkDataImage.path);
        pickedImage = checkDataImage;
      }
      update();
    } catch (err) {
      print(err);
      pickedImage = null;
      update();
    }
  }

  @override
  void onInit() {
    emailC = TextEditingController();
    nameC = TextEditingController();
    statusC = TextEditingController();
    imagePicker = ImagePicker();
    super.onInit();
  }

  @override //Agar tidak terjadi kebocoran data
  void onClose() {
    emailC.dispose();
    nameC.dispose();
    statusC.dispose();
    super.onClose();
  }
}
