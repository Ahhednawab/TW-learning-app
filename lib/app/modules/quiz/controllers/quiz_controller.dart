import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizQuestion {
  final String image;
  final String description;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.image,
    required this.description,
    required this.options,
    required this.correctIndex,
  });
}


class QuizController extends GetxController {
  var currentIndex = 0.obs;
  var progress = 0.0.obs;
  var correctCount = 0.obs;
  var selectedOption = (-1).obs;

  // Store color states for each option
  var answerColor = <int, dynamic>{}.obs;

  // Static question bank
  final List<QuizQuestion> questions = [
    QuizQuestion(
      image: 'assets/images/goat.jpg',
      description:
          'A four-legged farm mammal raised for wool, meat (mutton/lamb), and milk in agriculture.',
      options: ['Goat', 'Dog', 'Horse', 'Cat'],
      correctIndex: 0,
    ),
    QuizQuestion(
      image: 'assets/images/dog.png',
      description: 'A loyal domestic animal known as man\'s best friend.',
      options: ['Dog', 'Cat', 'Cow', 'Sheep'],
      correctIndex: 0,
    ),
    QuizQuestion(
      image: 'assets/images/sheep.png',
      description: 'A wool-producing farm animal often seen grazing in fields.',
      options: ['Goat', 'Sheep', 'Horse', 'Pig'],
      correctIndex: 1,
    ),
    QuizQuestion(
      image: 'assets/images/horse.png',
      description: 'A large mammal used for riding, racing, and farm work.',
      options: ['Horse', 'Goat', 'Dog', 'Cow'],
      correctIndex: 0,
    ),
    QuizQuestion(
      image: 'assets/images/cat.jpg',
      description: 'A small domesticated carnivore kept as a pet worldwide.',
      options: ['Dog', 'Cat', 'Cow', 'Goat'],
      correctIndex: 1,
    ),
    QuizQuestion(
      image: 'assets/images/cow.webp',
      description: 'A farm mammal raised for milk, meat, and leather.',
      options: ['Sheep', 'Pig', 'Cow', 'Goat'],
      correctIndex: 2,
    ),
    QuizQuestion(
      image: 'assets/images/pig.jpg',
      description: 'A pink farm animal raised for pork.',
      options: ['Pig', 'Goat', 'Dog', 'Horse'],
      correctIndex: 0,
    ),
    QuizQuestion(
      image: 'assets/images/chicken.webp',
      description: 'A domesticated bird raised for eggs and meat.',
      options: ['Goat', 'Dog', 'Chicken', 'Duck'],
      correctIndex: 2,
    ),
    QuizQuestion(
      image: 'assets/images/duck.jpg',
      description: 'A waterfowl with webbed feet, raised for meat and eggs.',
      options: ['Duck', 'Chicken', 'Cow', 'Sheep'],
      correctIndex: 0,
    ),
    QuizQuestion(
      image: 'assets/images/fish.jfif',
      description: 'An aquatic animal that lives in water and breathes through gills.',
      options: ['Dog', 'Goat', 'Fish', 'Duck'],
      correctIndex: 2,
    ),
  ];

  void selectOption(int index) {
    if (selectedOption.value != -1) return; // Prevent double tap
    selectedOption.value = index;

    if (index == questions[currentIndex.value].correctIndex) {
      answerColor[index] = const Color(0xFFD0F0C0); // green
      correctCount.value++;
    } else {
      answerColor[index] = const Color(0xFFF4C2C2); // red
      int correct = questions[currentIndex.value].correctIndex;
      answerColor[correct] = const Color(0xFFD0F0C0); // show correct
    }

    // Delay before moving to next question
    Future.delayed(const Duration(milliseconds: 700), nextQuestion);
  }

  void passQuestion() {
    nextQuestion();
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      selectedOption.value = -1;
      answerColor.clear();
      progress.value = currentIndex.value / questions.length;
    } else {
      Get.offNamed('/success'); // Redirect to success screen
    }
  }
}
