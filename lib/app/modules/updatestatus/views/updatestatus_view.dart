import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../controllers/updatestatus_controller.dart';

class UpdatestatusView extends StatelessWidget {
  UpdatestatusView({super.key});
  final statusController = Get.put(UpdatestatusController());
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    statusController.statusC.text = authC.user.value.status!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Status'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: statusController.statusC,
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                authC.updateStatus(statusController.statusC.text);
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
            const SizedBox(height: 30),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  authC.updateStatus(statusController.statusC.text);
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
