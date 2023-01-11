import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatsroomController extends GetxController {
  var isShowEmoji = false.obs;

  // Untuk digunakan disemua unread
  int total_unread = 0;

  // membuat inisial firebase
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late FocusNode focusNode;
  late TextEditingController chatC;
  late ScrollController scrollC;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChat(String chat_id) {
    CollectionReference chats = firestore.collection('chats');

    // OrderBy untuk mengurukan data berdasarkan Time.. Descending berdasarkan waktu yang paling terakhir
    // Snapshot digunakan untuk memantau yang terjadi didalam sini
    return chats.doc(chat_id).collection('chat').orderBy('time').snapshots();
  }

  Stream<DocumentSnapshot<Object?>> streamFriendData(String friendEmail) {
    CollectionReference users = firestore.collection('users');

    return users.doc(friendEmail).snapshots();
  }

  void addEmojiToChat(Emoji emoji) {
    chatC.text = chatC.text + emoji.emoji;
  }

  void deleteEmoji() {
    chatC.text = chatC.text.substring(0, chatC.text.length - 2);
  }

  // Melempar chat id dan chat nya
  void newChat(String email, Map<String, dynamic> argument, String chat) async {
    // VALIDASI AGAR CHAT TIDAK BISA MENGIRIM CHAT KOSONG
    if (chat != '') {
      // Masukk ke collection chats
      CollectionReference chats = firestore.collection('chats');

      // Masuk ke collection user
      CollectionReference users = firestore.collection('users');

      // Date time diambil biar bisa dipakai disemua tempat
      String date = DateTime.now().toIso8601String();

      //  Ambill document berdasarkan chat Id
      await chats.doc(argument['chat_id']).collection('chat').add({
        'pengirim': email,
        'penerima': argument['friendEmail'],
        'pesan': chat,
        'time': date,
        'isRead': false,
        'groupTime': DateFormat.yMMMMd('en_US').format(DateTime.parse(date)),
      });

      // Untuk membuat ketika kita masuk akan pindah ke scrooll chat paling bawah
      Timer(
        Duration.zero,
        () => scrollC.jumpTo(
          scrollC.position.maxScrollExtent,
        ),
      );

      // DITAROH SINI KARENA DIBAWAH SUDAH TIDAK DIGUNAKAN, HANYA DIGUNAKAN KETIKA MENAMBAHKAN DATA
      chatC.clear();

      // BAGI PENGGUNA KITA (KITA CHAT TPI BELUM DI READ);
      // Data dari (document id dari pengirim)
      // user kita punya document id dari pengirim, kemudian kita arah kan ke collection chats kemudian ke document id chat kita.
      // Kemudian setelah masuk ke dalam, kita update data yang mau di update
      await users
          .doc(email)
          .collection('chats')
          .doc(argument['chat_id'])
          .update({
        'lastTime': date,
        // 'total_unread' : 0, //Karena temen kita belum ngirim sesuatu maa tidak dipakai
      });

      // BUAT TEMAN KITA
      final checkChatsFriend = await users
          .doc(argument['friendEmail']) //masukk ke teman kira
          .collection('chats') // masuk ke collection chat
          .doc(argument['chat_id']) //masukke argument document teman kita
          .get(); //Baru kita GET data didalam nya

      // TOTAL UN READ adalah TOTAL PESAN YANG DIKIRIM TEMAN KITA KE KITA
      // LAlu cek dulu (Exist untuk cek apakah ada document didalamnya)
      if (checkChatsFriend.exists) {
        // Pertama check total_unread
        final checkTotalUnread = await chats
            .doc(argument['chat_id'])
            .collection('chat')
            .where('isRead', isEqualTo: false)
            .where('pengirim', isEqualTo: email)
            .get();

        // total unread for friend
        total_unread = checkTotalUnread.docs.length;

        // Update total unread dan last time saja
        await users
            .doc(argument['friendEmail'])
            .collection('chats')
            .doc(argument['chat_id'])
            .update({
          'lastTime': date,
          'total_unread': total_unread,
        });
      } else {
        // Create baru data nya dari database teman
        await users
            .doc(argument['friendEmail'])
            .collection('chats')
            .doc(argument['chat_id'])
            .set({
          'connection': email,
          'lastTime': date,
          'total_unread':
              1, //Kalau create baru total unread nya tingga; ditambahkan 1
        });
      }
    }
  }

  @override
  void onInit() {
    chatC = TextEditingController();
    scrollC = ScrollController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    chatC.dispose();
    scrollC.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
