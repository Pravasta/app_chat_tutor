import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:intl/intl.dart';
import '../../../controller/auth_controller.dart';
import '../controllers/chatsroom_controller.dart';

class ChatsroomView extends GetView<ChatsroomController> {
  ChatsroomView({super.key});
  final authC = Get.find<AuthController>();
  final String chat_id = (Get.arguments as Map<String, dynamic>)['chat_id'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          leadingWidth: 100,
          leading: InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 5),
                const Icon(Icons.arrow_back),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  child: StreamBuilder<DocumentSnapshot<Object?>>(
                    stream: controller.streamFriendData(
                      (Get.arguments as Map<String, dynamic>)['friendEmail'],
                    ),
                    builder: (context, snapFriendUser) {
                      if (snapFriendUser.connectionState ==
                          ConnectionState.active) {
                        var dataTeman =
                            snapFriendUser.data!.data() as Map<String, dynamic>;
                        print(dataTeman);
                        if (dataTeman['photoUrl'] == 'noimage') {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset('asset/logo/noimage.png'));
                        } else {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(dataTeman['photoUrl']));
                        }
                      }
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset('asset/logo/noimage.png'));
                    },
                  ),
                ),
              ],
            ),
          ),
          title: StreamBuilder<DocumentSnapshot<Object?>>(
            stream: controller.streamFriendData(
              (Get.arguments as Map<String, dynamic>)['friendEmail'],
            ),
            builder: (context, snapFriendUser) {
              if (snapFriendUser.connectionState == ConnectionState.active) {
                var dataTeman =
                    snapFriendUser.data!.data() as Map<String, dynamic>;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dataTeman['name']}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${dataTeman['status']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Loading ...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Loading ...',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              );
            },
          ),
          centerTitle: false,
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (controller.isShowEmoji.isTrue) {
            controller.isShowEmoji.value = false;
          } else {
            Navigator.pop(context);
          }
          return Future.value(false);
        },
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.streamChat(chat_id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      print(snapshot.data!.docs.length);
                      var allData = snapshot
                          .data!.docs; //Ini data all dari collection chat_id
                      Timer(
                        //Digunakan untuk agar ketika room chat dibuka langsung mengarah ke chat paling bawah
                        Duration.zero,
                        () => controller.scrollC.jumpTo(
                          controller.scrollC.position.maxScrollExtent,
                        ),
                      );
                      return ListView.builder(
                          // controollerr digunakan untuk mencontroll scrool annya seberapa
                          controller: controller.scrollC,
                          itemCount: allData.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    '${allData[index]['groupTime']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ItemChat(
                                    isSender:
                                        // check dulu apakah ini akun kita
                                        allData[index]['pengirim'] ==
                                                authC.user.value.email!
                                            ? true
                                            : false,
                                    msg: '${allData[index]['pesan']}',
                                    time: '${allData[index]['time']}',
                                  ),
                                ],
                              );
                            } else {
                              if (allData[index]['groupTime'] ==
                                  allData[index - 1]['groupTime']) {
                                return ItemChat(
                                  isSender:
                                      // check dulu apakah ini akun kita
                                      allData[index]['pengirim'] ==
                                              authC.user.value.email!
                                          ? true
                                          : false,
                                  msg: '${allData[index]['pesan']}',
                                  time: '${allData[index]['time']}',
                                );
                              } else {
                                return Column(
                                  children: [
                                    Text(
                                      '${allData[index]['groupTime']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ItemChat(
                                      isSender:
                                          // check dulu apakah ini akun kita
                                          allData[index]['pengirim'] ==
                                                  authC.user.value.email!
                                              ? true
                                              : false,
                                      msg: '${allData[index]['pesan']}',
                                      time: '${allData[index]['time']}',
                                    ),
                                  ],
                                );
                              }
                            }
                          });
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: controller.isShowEmoji.isTrue
                      ? 5
                      : context.mediaQueryPadding.bottom),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        controller: controller.chatC,
                        autocorrect: false,
                        onEditingComplete: () {
                          controller.newChat(
                            authC.user.value.email!,
                            Get.arguments as Map<String, dynamic>,
                            controller.chatC.text,
                          );
                        },
                        focusNode: controller.focusNode,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () {
                              controller.focusNode.unfocus();
                              controller.isShowEmoji.toggle();
                            },
                            icon: const Icon(Icons.emoji_emotions_outlined),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue[600],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        controller.newChat(
                          authC.user.value.email!,
                          Get.arguments as Map<String, dynamic>,
                          controller.chatC.text,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => (controller.isShowEmoji.isTrue)
                  ? SizedBox(
                      height: 325,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          controller.addEmojiToChat(emoji);
                        },
                        onBackspacePressed: () {
                          controller.deleteEmoji();
                        },
                        // textEditingController: controller.chatC,
                        config: Config(
                          columns: 7,
                          emojiSizeMax: 32 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.30
                                  : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecents: const Text(
                            'No Recents',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ), // Needs to be const Widget
                          loadingIndicator: const SizedBox
                              .shrink(), // Needs to be const Widget
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({
    Key? key,
    required this.isSender,
    required this.msg,
    required this.time,
  }) : super(key: key);

  final bool isSender;
  final String msg;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[500],
              borderRadius: isSender
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
            ),
            padding: const EdgeInsets.all(15),
            child: Text(
              msg,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 5),
          Text(DateFormat.jm().format(DateTime.parse(time))),
        ],
      ),
    );
  }
}
