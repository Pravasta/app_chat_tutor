import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class ViewModel {
  static final model = [
    PageViewModel(
      title: "Berinteraksi dengan Mudah",
      body: "Kamu hanya perlu dirumah saja untuk mendapatkan teman baru",
      image: Container(
        width: Get.width * 0.7,
        height: Get.height * 0.7,
        child: Lottie.asset('asset/lottie/main-laptop-duduk.json'),
      ),
    ),
    PageViewModel(
      title: "Temukan Sahabat Baru",
      body: "Jika kamu memang jodoh karena aplikasi ini, kami sangat bahagia",
      image: Container(
          width: Get.width * 0.7,
          height: Get.height * 0.7,
          child: Center(child: Lottie.asset('asset/lottie/ojek.json'))),
    ),
    PageViewModel(
      title: "Aplikasi bebas biaya",
      body: "Kamu tidak perlu khawatir, aplikasi ini bebas biaya apapun",
      image: Container(
          width: Get.width * 0.7,
          height: Get.height * 0.7,
          child: Center(child: Lottie.asset('asset/lottie/payment.json'))),
    ),
    PageViewModel(
      title: "Gabung Sekarang juga",
      body:
          "Daftarkan diri kamu untuk menjadi bagian dari kami. Kami akan menghubungkan dengan 1000 teman lainnya",
      image: Container(
          width: Get.width * 0.7,
          height: Get.height * 0.7,
          child: Center(child: Lottie.asset('asset/lottie/register.json'))),
    ),
  ];
}
