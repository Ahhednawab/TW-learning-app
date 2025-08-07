import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            AnimatedOpacity(
              opacity: controller.showSecondImage.value ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 1500),
              child: Image.asset(
                'assets/images/splash1.png',
                fit: BoxFit.cover,
              ),
            ),
            AnimatedOpacity(
              opacity: controller.showSecondImage.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1500),
              child: Image.asset(
                'assets/images/splash2.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
