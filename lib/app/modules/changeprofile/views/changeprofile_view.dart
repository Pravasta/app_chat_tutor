import 'dart:io';

import '../../../controller/auth_controller.dart';
import '../controllers/changeprofile_controller.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeprofileView extends StatelessWidget {
  ChangeprofileView({super.key});

  final controllerC = Get.put(ChangeprofileController());
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    controllerC.emailC.text = authC.user.value.email!;
    controllerC.nameC.text = authC.user.value.name!;
    controllerC.statusC.text = authC.user.value.status!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              authC.changeProfile(
                controllerC.nameC.text,
                controllerC.statusC.text,
              );
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            AvatarGlow(
              endRadius: 75,
              glowColor: Colors.black,
              duration: const Duration(seconds: 2),
              child: Container(
                margin: const EdgeInsets.all(15),
                width: 120,
                height: 120,
                child: Obx(
                  () => ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: authC.user.value.photoUrl! == 'noimage'
                        ? Image.asset('asset/logo/noimage.png',
                            fit: BoxFit.cover)
                        : Image.network(
                            authC.user.value.photoUrl!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              textInputAction: TextInputAction.next,
              readOnly: true,
              controller: controllerC.emailC,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(100),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controllerC.nameC,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(100),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controllerC.statusC,
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                authC.changeProfile(
                  controllerC.nameC.text,
                  controllerC.statusC.text,
                );
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Status',
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(100),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GetBuilder<ChangeprofileController>(builder: (c) {
                    return c.pickedImage != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 110,
                                width: 125,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: DecorationImage(
                                          image: FileImage(
                                            File(c.pickedImage!.path),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      right: -5,
                                      child: IconButton(
                                          onPressed: () => c.resetImage(),
                                          icon: const Icon(Icons.delete)),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => controllerC
                                    .uploadImage(authC.user.value.uid!)
                                    .then((hasilKembalian) {
                                  if (hasilKembalian != null) {
                                    authC.updatePhotoUrl(hasilKembalian);
                                  }
                                }),
                                child: const Text(
                                  'upload',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        : const Text('no image');
                  }),
                  TextButton(
                    onPressed: () {
                      controllerC.selectImage();
                    },
                    child: const Text(
                      'choosen',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  authC.changeProfile(
                    controllerC.nameC.text,
                    controllerC.statusC.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  backgroundColor: const Color(0xff1e81b0),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
