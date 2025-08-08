import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WordModel {
  final String word;
  final String meaning;
  final String example;
  final String type;
  final String image;

  WordModel({
    required this.word,
    required this.meaning,
    required this.example,
    required this.type,
    required this.image,
  });
}

class SwipecardController extends GetxController with GetTickerProviderStateMixin {
  String? title;

  final words = <WordModel>[
    WordModel(word: "Sheep", meaning: "A domesticated ruminant animal", example: "The sheep grazed in the meadow.", type: "Noun", image: "assets/images/sheep.png"),
    WordModel(word: "Cat", meaning: "A small domesticated carnivorous mammal", example: "The cat chased the mouse.", type: "Noun", image: "assets/images/cat.jpg"),
    WordModel(word: "Dog", meaning: "A domesticated carnivorous mammal", example: "The dog barked loudly.", type: "Noun", image: "assets/images/dog.png"),
    WordModel(word: "Bird", meaning: "A warm-blooded egg-laying vertebrate", example: "The bird sang beautifully.", type: "Noun", image: "assets/images/bird.jpg"),
    WordModel(word: "Horse", meaning: "A large domesticated mammal", example: "The horse galloped across the field.", type: "Noun", image: "assets/images/horse.png"),
    WordModel(word: "Fish", meaning: "A limbless cold-blooded vertebrate", example: "The fish swam gracefully.", type: "Noun", image: "assets/images/fish.jfif"),
    WordModel(word: "Lion", meaning: "A large tawny-colored cat", example: "The lion roared fiercely.", type: "Noun", image: "assets/images/lion.jpeg"),
    WordModel(word: "Elephant", meaning: "A large herbivorous mammal", example: "The elephant splashed water.", type: "Noun", image: "assets/images/elephant.jpg"),
    WordModel(word: "Tiger", meaning: "A large cat with a striped coat", example: "The tiger prowled silently.", type: "Noun", image: "assets/images/tiger.jpg"),
    WordModel(word: "Goat", meaning: "A hardy domesticated ruminant", example: "The goat climbed the rocky hill.", type: "Noun", image: "assets/images/goat.jpg"),
  ].obs;

  var currentIndex = 0.obs;
  var progress = 0.0.obs;
  var isLearning = false.obs;

  late AnimationController swipeController;
  late Animation<Offset> swipeAnimation;

  late AnimationController overlayController;
  late Animation<double> overlayAnimation;

  @override
  void onInit() {
    super.onInit();
    title = Get.arguments?['activity'];

    swipeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    swipeAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(-2, 0))
        .animate(CurvedAnimation(parent: swipeController, curve: Curves.easeInOut));

    overlayController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    overlayAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: overlayController, curve: Curves.easeInOut));

    updateProgress();
  }

  void markKnown() async {
    if (isLearning.value) {
      // If overlay is open, close it first
      await overlayController.reverse();
      isLearning.value = false;
    }
    await swipeController.forward();
    nextCard();
    swipeController.reset();
  }

  void markLearn() {
    isLearning.value = true;
    overlayController.forward();
  }

  void nextCard() {
    if (currentIndex.value < words.length - 1) {
      currentIndex.value++;
      updateProgress();
    } else {
      // Optionally handle end of cards
      Get.back();
    }
  }

  void updateProgress() {
    progress.value = (currentIndex.value + 1) / words.length;
  }

  @override
  void onClose() {
    swipeController.dispose();
    overlayController.dispose();
    super.onClose();
  }
}
