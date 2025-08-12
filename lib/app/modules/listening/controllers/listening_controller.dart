import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ListeningController extends GetxController {
  String? activity;

  final progress = 0.0.obs;
  final currentIndex = 0.obs;
  final correctCount = 0.obs;

  final textFieldColor = Rx<Color>(Colors.white);

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Animal data
  final List<Map<String, String>> questions = [
    {
      "image": "assets/images/sheep.png",
      "audio": "audio/sheep.mp3",
      "answer": "A"
    },
    {
      "image": "assets/images/horse.png",
      "audio": "audio/horse.mp3",
      "answer": "A"
    },
    {
      "image": "assets/images/dog.png",
      "audio": "audio/dog.mp3",
      "answer": "A"
    },
  ];

  @override
  void onInit() {
    super.onInit();
    activity = Get.arguments['activity'];
  }

  void playSound(String filePath) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(filePath));
  }

  void checkAnswer(String input) {
    if (input.trim().toLowerCase() == 'a') {
      textFieldColor.value = const Color(0xFFD0F0C0); // light green
      correctCount.value++;
      Future.delayed(const Duration(milliseconds: 500), nextQuestion);
    } else {
      textFieldColor.value = const Color(0xFFF4C2C2); // light red
    }
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      progress.value = (currentIndex.value) / questions.length;
      textFieldColor.value = Colors.white;
    } else {
      progress.value = 1.0;
      // Game complete logic can be placed here
      Get.back();
    }
  }

  // disposing the audio player
  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
