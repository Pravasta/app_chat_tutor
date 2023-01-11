import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/model/users_model_model.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(

      // scopes: [ //Bolehh gk aplikasi melihat apa yang orang lakukan
      //   'email',
      //   'https://www.googleapis.com/auth/contacts.readonly',
      // ],
      );
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  var user = UsersModel().obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> firstInitialized() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

  Future<bool> skipIntro() async {
    // Kita akan mengubah isSkipIntro = true (status ketika udh pernah login blm)
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    // Kenapa Auto Login juga diberi data lengkap seperti login, karena auto login sudah ada data nya
    // Kita akan mengubah isAuth = true => Auto Login
    try {
      final isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);

        // Authentication digunakan untuk mendapatkan Id token sama akses token
        final googleAuth = await _currentUser!.authentication;

        // Credential digunakan untuk memasukkan user kedalam Firebase Authentication
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print('USER CREDENTIAL');
        print(userCredential);

        CollectionReference users = firestore.collection('users');

        await users.doc(_currentUser!.email).update({
          'updateAt':
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        // Ambil dataa
        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData)); //Sama kayak bawahnya
        // user(UsersModel(
        //   uid: currUserData['uid'],
        //   name: currUserData['name'],
        //   keyName: currUserData['keyName'],
        //   email: currUserData['email'],
        //   createAt: currUserData['createAt'],
        //   updateAt: currUserData['updateAt'],
        //   updateTime: currUserData['updateTime'],
        //   photoUrl: currUserData['photoUrl'],
        //   status: currUserData['status'],
        // ));
        // Memasang user model
        // user(UsersModel.fromJson(currUserData));

        // ignore: todo
        // TODO LIST : Fixing list Collection Chat User

        user.refresh();

        final listChats =
            await users.doc(_currentUser!.email).collection('chats').get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUsers> dataListChats = List.empty();
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(
              ChatUsers(
                chatId: dataDocChatId,
                connection: dataDocChat['connection'],
                lastTime: dataDocChat['lastTime'],
                totalUnread: dataDocChat['total_unread'],
              ),
            );
          }
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        user.refresh();

        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<void> loginGoole() async {
    // FUNGSI UNTUK LOGIN DENGAN GOOGLE
    try {
      // Ini untuk handle kebocoran data user sebelum login
      await _googleSignIn.signOut();

      // Ini digunakan untuk mendapatkan google account ketika login
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      // Ini untuk mengecek status login user (login atau tidak)
      final isSign = await _googleSignIn.isSignedIn();

      if (isSign) {
        // KONDISI LOGIN BERHASIL
        print('Sudah berhasil login dengan akun : ');
        print(_currentUser);

        // Authentication digunakan untuk mendapatkan Id token sama akses token
        final googleAuth = await _currentUser!.authentication;

        // Credential digunakan untuk memasukkan user kedalam Firebase Authentication
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print('USER CREDENTIAL');
        print(userCredential);

        // Simpan status user bahwa sudah pernah login dan tidak akan menampilkan introduction lagi
        final box = GetStorage();
        // Agar tidak terjadi kebocoran (agar tidak nge write setiap kali login).
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        // Jika ada datanya maka hapus data nya baru kita buat lagi yang baru dengan box.write()
        box.write('skipIntro', true);

        // Masukkan data ke Firebase..
        CollectionReference users = firestore.collection('users');

        // cek apakah user sudah pernah mendaftar atau belum sebelumnya
        final checkUser = await users.doc(_currentUser!.email).get();

        if (checkUser.data() == null) {
          await users.doc(_currentUser!.email).set({
            'uid': userCredential!.user!.uid,
            'name': _currentUser!.displayName,
            'keyName': _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            'email': _currentUser!.email,
            'photoUrl': _currentUser!.photoUrl ?? 'noimage',
            'status': '',
            'createAt':
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            'updateAt': userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            'updateTime': DateTime.now().toIso8601String(),
          });

          users.doc(_currentUser!.email).collection('chats');
        } else {
          await users.doc(_currentUser!.email).update({
            'updateAt': userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }

        // Ambil dataa
        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        // ignore: todo
        // TODO LIST : Fixing list Collection Chat User
        // user(UsersModel(
        //   uid: currUserData['uid'],
        //   name: currUserData['name'],
        //   keyName: currUserData['keyName'],
        //   email: currUserData['email'],
        //   createAt: currUserData['createAt'],
        //   updateAt: currUserData['updateAt'],
        //   updateTime: currUserData['updateTime'],
        //   photoUrl: currUserData['photoUrl'],
        //   status: currUserData['status'],
        // ));
        // Memasang user model
        user(UsersModel.fromJson(currUserData));

        user.refresh();

        final listChats =
            await users.doc(_currentUser!.email).collection('chats').get();

        if (listChats.docs.isNotEmpty) {
          // List<ChatUsers> dataListChats = List<ChatUsers>.empty().obs; //Bisa gini atau bawahnya
          List<ChatUsers> dataListChats = [];
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(
              ChatUsers(
                chatId: dataDocChatId,
                connection: dataDocChat['connection'],
                lastTime: dataDocChat['lastTime'],
                totalUnread: dataDocChat['total_unread'],
              ),
            );
          }
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        user.refresh();
        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        // KONDISI LOGIN GAGAL
        print('TIdak berhasil login dengan akun : ');
      }
    } catch (error) {
      print(error);
    }
    // Get.offAllNamed(Routes.HOME);
  }

  Future<void> logOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  // PROFILE

  void changeProfile(String name, String status) {
    String date = DateTime.now().toIso8601String();
    // Update firebase
    CollectionReference users = firestore.collection('users');

    users.doc(_currentUser!.email).update({
      'name': name,
      'keyName': name.substring(0, 1).toUpperCase(),
      'status': status,
      'updateAt':
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      'updateTime': date,
    });

    // Update model

    user.update((val) {
      val!.name = name;
      val.keyName = name.substring(0, 1).toUpperCase();
      val.status = status;
      val.updateAt =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      val.updateTime = date;
    });

    user.refresh();
    Get.defaultDialog(
      title: 'Sukses',
      middleText: 'Profile has Change',
    );
  }

  void updatePhotoUrl(String url) async {
    String date = DateTime.now().toIso8601String();
    // Update firebase
    CollectionReference users = firestore.collection('users');

    await users.doc(_currentUser!.email).update({
      'photoUrl': url,
      'updateTime': date,
    });

    // Update model

    user.update((user) {
      user!.photoUrl = url;
      user.updateTime = date;
    });

    user.refresh();
    Get.defaultDialog(
      title: 'Sukses',
      middleText: 'Update Photo Profile, Succes',
    );
  }

  // UPDATE STATUS
  void updateStatus(String status) {
    String date = DateTime.now().toIso8601String();
    // Update firebase
    CollectionReference users = firestore.collection('users');

    users.doc(_currentUser!.email).update({
      'status': status,
      'updateAt':
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      'updateTime': date,
    });

    // Update model

    user.update((val) {
      val!.status = status;
      val.updateAt =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      val.updateTime = date;
    });

    user.refresh();
    Get.defaultDialog(
      title: 'Sukses',
      middleText: 'Profile has Change',
    );
  }

  // SEARCH

  void addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    var chat_id;
    String date = DateTime.now().toIso8601String();
    // Collection untuk mendapatkan collection database chats dan users
    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');

    // kemudian dapatkan document 'chats'
    final docChat =
        await users.doc(_currentUser!.email).collection('chats').get();

    if (docChat.docs.isNotEmpty) {
      // user sudah pernah chat dengan siapapun
      final checkConnection = await users
          .doc(_currentUser!.email)
          .collection('chats')
          .where('connection', isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.isNotEmpty) {
        // Sudah pernah buat koneksi dengan frienEmail
        flagNewConnection = false;

        //Chat_id from chats Collection
        chat_id = checkConnection.docs[0].id;
      } else {
        // Belum pernah buat koneksi dengan friendEmail
        // buat koneksi
        flagNewConnection = true;
      }
    } else {
      // Belum pernah buat koneksi dengan friendEmail
      // buat koneksi
      flagNewConnection = true;
    }

    // FIXING COLLECTION CHATS USER

    // Kalau flag nya false maka perintah dibawah akan dilewati dan langsung melakukan route membawa sebuah argument
    if (flagNewConnection) {
      // cek dari chats collection apakah ada document yang koneksnya sama (dari akun a ke b begitupun sebaliknya)
      // Kondisi 1 klo misalnya ada
      final chatsDocs = await chats.where(
        'connection',
        whereIn: [
          //Where in untuk agar urutan darii email tidak sama (kalau menggunakan isEqual to harus sama urutannya) a,b != b,a..
          // TPi kalau where in a,b = b,a
          [
            _currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            _currentUser!.email,
          ],
        ],
      ).get();

      if (chatsDocs.docs.isNotEmpty) {
        // Terdapat data chats (sudah ada koneksi antara 2 orang)
        final chatDataId =
            chatsDocs.docs[0].id; //Mendapatkan id dokumen yang random
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        // Masukk ke users
        await users
            .doc(_currentUser!.email) //masuk ke doc email
            .collection('chats') //membuat chats
            .doc(chatDataId) //mengeset data
            .set({
          'connection': friendEmail,
          'lastTime': chatsData['lastTime'],
          'total_unread': 0,
        });

        // Ambil List
        final listChats =
            await users.doc(_currentUser!.email).collection('chats').get();

        // Lalu masukkan ke sini
        if (listChats.docs.isNotEmpty) {
          // Update model
          List<ChatUsers> dataListChats = List.empty();
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(
              ChatUsers(
                chatId: dataDocChatId,
                connection: dataDocChat['connection'],
                lastTime: dataDocChat['lastTime'],
                totalUnread: dataDocChat['total_unread'],
              ),
            );
          }
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        // Data yang lama jangan di replace

        // docChat.add(
        //   {
        //     'connection': friendEmail,
        //     'chat_id': chatDataId,
        //     'lastTime': chatsData['lastTime'],
        //     'total_unread': 0,
        //   },
        // );

        // await users.doc(_currentUser!.email).update({
        //   'chats': docChat,
        // });

        // user.update((user) {
        //   user!.chats = docChat as List<ChatUsers>;
        // });

        chat_id = chatDataId;
      } else {
        // Buat baru , mereka berdua benar benar belum ada koneksi
        final newChatDoc = await chats.add({
          'connection': [
            _currentUser!.email,
            friendEmail,
          ],
        });

        // Masuk lagi buat chat
        chats.doc(newChatDoc.id).collection('chat');

        await users
            .doc(_currentUser!.email)
            .collection('chats')
            .doc(newChatDoc.id)
            .set({
          'connection': friendEmail,
          'lastTime': date,
          'total_unread': 0,
        });

        // Ngambil dari user collection chats ada datanya tidak
        final listChats =
            await users.doc(_currentUser!.email).collection('chats').get();

        // Logic untuk masukkan datanya
        if (listChats.docs.isNotEmpty) {
          List<ChatUsers> dataListChats = List<ChatUsers>.empty();
          // UPDATE MODEL
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(
              ChatUsers(
                chatId: dataDocChatId,
                connection: dataDocChat['connection'],
                lastTime: dataDocChat['lastTime'],
                totalUnread: dataDocChat['total_unread'],
              ),
            );
          }
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chat_id = newChatDoc.id;

        user.refresh();
      }
    }

    print(chat_id);

    // DIGUNAKAN UNTUK MENGUPDATE isREAD ketika kita masuk ke CHAT ROOM
    // buat updateStatusChat, masuk ke collection chats -> doc chat_id -> collection chat -> trus cari isRead false dan penerima pesan adalah kita
    // jika sudah maka dapat kan data dengan get()
    final updateStatusChat = await chats
        .doc(chat_id)
        .collection('chat')
        .where('isRead', isEqualTo: false)
        .where('penerima', isEqualTo: _currentUser!.email)
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
        .doc(_currentUser!.email)
        .collection('chats')
        .doc(chat_id)
        .update({'total_unread': 0});

    Get.toNamed(Routes.CHATSROOM, arguments: {
      'chat_id': '$chat_id',
      'friendEmail': friendEmail,
    });

    // Kondisi 1. Belum pernah membuat koneksi (history chat) dengan yang email orang

    // Kondisi 2. Dia sudah pernah membuat histori chat dengan si email orang
  }
}
