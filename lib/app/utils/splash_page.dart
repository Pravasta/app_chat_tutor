import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 70),
              const Text(
                'Welcome to ChatsApp',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1e81b0),
                ),
              ),
              SizedBox(
                  width: Get.width * 0.7,
                  height: Get.height * 0.7,
                  child: Lottie.asset('asset/lottie/hello.json')),
              const SizedBox(
                height: 50,
              ),
              const Text('Chat App'),
              const Text(
                'v.1.0',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
