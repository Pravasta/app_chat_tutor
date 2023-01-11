import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String email) {
    return firestore
        .collection('users')
        .doc(email)
        .collection('chats')
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  void goToChatRoom(String chat_id, String email, String friendEmail) async {
    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');

    // DIGUNAKAN UNTUK MENGUPDATE isREAD ketika kita masuk ke CHAT ROOM
    // buat updateStatusChat, masuk ke collection chats -> doc chat_id -> collection chat -> trus cari isRead false dan penerima pesan adalah kita
    // jika sudah maka dapat kan data dengan get()
    final updateStatusChat = await chats
        .doc(chat_id)
        .collection('chat')
        .where('isRead', isEqualTo: false)
        .where('penerima', isEqualTo: email)
        .get();

    // ambil smua data dalam updateStatusChat menggunakan docs. lalu looping dan masuk ke chat id -> collec chat -> doc element id manapun yang masi false
    // lalu kita update isRead didalamnya menjadi true
    updateStatusChat.docs.forEach((element) async {
      await chats.doc(chat_id).collection('chat').doc(element.id).update({
        'isRead': true,
      });
    });

    // KEtika kita login akun, kita juga mengupdate total_unread kita  jadi 0, karena sudah kita baca
    await users
        .doc(email)
        .collection('chats')
        .doc(chat_id)
        .update({'total_unread': 0});

    Get.toNamed(Routes.CHATSROOM, arguments: {
      'chat_id': chat_id,
      'friendEmail': friendEmail,
    });
  }
}
