import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../routes/app_pages.dart';
import 'page_view_model.dart';

class IntroductionView extends StatelessWidget {
  const IntroductionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: ViewModel.model,
        showSkipButton: true,
        skip: const Text('Skip'),
        next: const Text(
          "Next",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        done:
            const Text("Login", style: TextStyle(fontWeight: FontWeight.w700)),
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        // onSkip: () {},
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).colorScheme.secondary,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}
