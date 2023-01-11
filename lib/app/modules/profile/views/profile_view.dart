import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../routes/app_pages.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () {
              authC.logOut();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            child: Column(
              children: [
                Obx(
                  () => AvatarGlow(
                    endRadius: 110,
                    glowColor: Colors.black,
                    duration: const Duration(seconds: 2),
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      width: 175,
                      height: 175,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: authC.user.value.photoUrl! == 'noimage'
                            ? Image.asset('asset/logo/noimage.png',
                                fit: BoxFit.cover)
                            : Image.network(authC.user.value.photoUrl!,
                                fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Obx(
                  () => Text(authC.user.value.name!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ),
                Text(authC.user.value.email!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                      onTap: () => Get.toNamed(Routes.CHANGEPROFILE),
                      leading: const Icon(Icons.person),
                      title: const Text('Change Profile',
                          style: TextStyle(fontSize: 22)),
                      trailing: const Icon(Icons.arrow_right)),
                  ListTile(
                      onTap: () => Get.toNamed(Routes.UPDATESTATUS),
                      leading: const Icon(Icons.note_alt_outlined),
                      title: const Text('Change Status',
                          style: TextStyle(fontSize: 22)),
                      trailing: const Icon(Icons.arrow_right)),
                  ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.color_lens),
                      title: const Text('Change Theme',
                          style: TextStyle(fontSize: 22)),
                      trailing: const Text('Light')),
                ],
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(bottom: context.mediaQueryPadding.bottom + 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Chats App', style: TextStyle(color: Colors.black54)),
                Text('v.1.0', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
