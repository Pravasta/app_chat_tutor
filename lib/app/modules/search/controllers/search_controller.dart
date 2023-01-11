import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  late TextEditingController searchC;

  var queryAwal = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend(String data, String email) async {
    if (data.isEmpty) {
      queryAwal.value = [];
      tempSearch.value = [];
    } else {
      var capitalize = data.substring(0, 1).toUpperCase() + data.substring(1);
      print(capitalize);

      if (queryAwal.isEmpty && data.length == 1) {
        // Fungsi yang akan dijalankan pada satu huruf ketikan pertama
        CollectionReference users = firestore.collection('users');
        final keyNameResult = await users
            .where('keyName', isEqualTo: data.substring(0, 1).toUpperCase())
            .where('email', isNotEqualTo: email)
            .get();

        print('TOTAL DATA : ${keyNameResult.docs.length}');
        if (keyNameResult.docs.isNotEmpty) {
          for (int i = 0; i < keyNameResult.docs.length; i++) {
            queryAwal.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
          }
          print('QUERY RESULT : ');
          print(queryAwal);
        } else {
          print('Tidak ada Data QUERY RESULT');
        }
      }

      if (queryAwal.isNotEmpty) {
        tempSearch.value = [];
        queryAwal.forEach((element) {
          if (element['name'].startsWith(capitalize)) {
            tempSearch.add(element);
          }
        });
      }
    }
    queryAwal.refresh();
    tempSearch.refresh();
  }

  @override
  void onInit() {
    searchC = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }
}
