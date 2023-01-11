import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../controller/auth_controller.dart';
import '../../../home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';

class ChatsApp extends StatelessWidget {
  ChatsApp({super.key});

  final homeC = Get.put(HomeController());
  final authC = Get.find<AuthController>();

  // final List<Widget> myChat = List.generate(
  //   20,
  //   (index) => ListTile(
  //     onTap: () => Get.toNamed(Routes.CHATSROOM),
  //     contentPadding: const EdgeInsets.all(10),
  //     leading: CircleAvatar(
  //       radius: 30,
  //       backgroundColor: Colors.black26,
  //       child: Image.asset(
  //         'asset/logo/noimage.png',
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //     title: Text(
  //       'Orang ke ${index + 1}',
  //       style: const TextStyle(fontWeight: FontWeight.bold),
  //     ),
  //     subtitle: Text('Pesan Ini ${index + 1}'),
  //     trailing: const Chip(label: Text('3')),
  //   ),
  // ).reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black12),
                ),
              ),
              width: Get.width * 1,
              height: 60,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Row(
                  children: const [
                    Icon(
                      Icons.archive_outlined,
                      color: Color(0xff008069),
                      size: 30,
                    ),
                    SizedBox(width: 30),
                    Text(
                      'Archieved',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: homeC.chatStream(authC.user.value.email!),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.active) {
                  var listDocsChat =
                      snapshot1.data!.docs; // ini snapshot kita sendiri
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: listDocsChat.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: homeC
                              .friendStream(listDocsChat[index]['connection']),
                          builder: (context, snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.active) {
                              var data = snapshot2.data!
                                  .data(); //Data dari snapshot teman kita
                              return data!['status'] == ''
                                  ? ListTile(
                                      onTap: () => homeC.goToChatRoom(
                                        listDocsChat[index].id,
                                        authC.user.value.email!,
                                        listDocsChat[index]['connection'],
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 8),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black26,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: data['photoUrl'] == 'noimage'
                                              ? Image.asset(
                                                  'asset/logo/noimage.png',
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  data['photoUrl'],
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      title: Text(
                                        '${data['name']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      trailing: listDocsChat[index]
                                                  ['total_unread'] ==
                                              0
                                          ? const SizedBox()
                                          : Chip(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 102, 198, 243),
                                              label: Text(
                                                '${listDocsChat[index]['total_unread']}',
                                              ),
                                            ),
                                    )
                                  : ListTile(
                                      onTap: () => homeC.goToChatRoom(
                                        listDocsChat[index].id,
                                        authC.user.value.email!,
                                        listDocsChat[index]['connection'],
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 8),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black26,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: data['photoUrl'] == 'noimage'
                                              ? Image.asset(
                                                  'asset/logo/noimage.png',
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  data['photoUrl'],
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      title: Text(
                                        '${data['name']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${data['status']}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      trailing: listDocsChat[index]
                                                  ['total_unread'] ==
                                              0
                                          ? const SizedBox()
                                          : Chip(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 102, 198, 243),
                                              label: Text(
                                                '${listDocsChat[index]['total_unread']}',
                                              ),
                                            ),
                                    );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1e81b0),
        onPressed: () => Get.toNamed(Routes.SEARCH),
        child: const Icon(Icons.message_rounded, color: Colors.white),
      ),
    );
  }
}
