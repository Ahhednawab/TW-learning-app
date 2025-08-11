import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionModel {
  final String image;
  final String questionText;
  final List<String> options;
  final int correctIndex;

  QuestionModel({
    required this.image,
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });
}

class FillblanksController extends GetxController with GetTickerProviderStateMixin {
  String? activity;

  var currentIndex = 0.obs;
  var progress = 0.0.obs;

  var selectedOption = (-1).obs;
  var answerColor = <int, Color>{}.obs;

  late AnimationController swipeController;
  late Animation<Offset> swipeAnimation;
final List<QuestionModel> questions = [
  QuestionModel(
    image: "assets/images/sheep.png",
    questionText: "我喜歡 ______。\n(Wǒ xǐhuān ______.)",
    options: ["狗 (gǒu)", "羊 (yáng)", "馬 (mǎ)", "魚 (yú)"],
    correctIndex: 1,
  ),
  QuestionModel(
    image: "assets/images/cat.jpg",
    questionText: "我有一隻 ______。\n(Wǒ yǒu yī zhī ______.)",
    options: ["狗 (gǒu)", "馬 (mǎ)", "貓 (māo)", "鳥 (niǎo)"],
    correctIndex: 2,
  ),
  QuestionModel(
    image: "assets/images/dog.png",
    questionText: "他養了一隻 ______。\n(Tā yǎngle yī zhī ______.)",
    options: ["魚 (yú)", "貓 (māo)", "狗 (gǒu)", "羊 (yáng)"],
    correctIndex: 2,
  ),
  QuestionModel(
    image: "assets/images/bird.jpg",
    questionText: "天空有一隻 ______。\n(Tiānkōng yǒu yī zhī ______.)",
    options: ["鳥 (niǎo)", "羊 (yáng)", "魚 (yú)", "馬 (mǎ)"],
    correctIndex: 0,
  ),
  QuestionModel(
    image: "assets/images/horse.png",
    questionText: "他在騎 ______。\n(Tā zài qí ______.)",
    options: ["貓 (māo)", "鳥 (niǎo)", "馬 (mǎ)", "羊 (yáng)"],
    correctIndex: 2,
  ),
  QuestionModel(
    image: "assets/images/fish.jfif",
    questionText: "我喜歡吃 ______。\n(Wǒ xǐhuān chī ______.)",
    options: ["鳥 (niǎo)", "魚 (yú)", "羊 (yáng)", "狗 (gǒu)"],
    correctIndex: 1,
  ),
  QuestionModel(
    image: "assets/images/lion.jpeg",
    questionText: "動物園有一隻 ______。\n(Dòngwùyuán yǒu yī zhī ______.)",
    options: ["狗 (gǒu)", "羊 (yáng)", "獅子 (shīzi)", "馬 (mǎ)"],
    correctIndex: 2,
  ),
  QuestionModel(
    image: "assets/images/elephant.jpg",
    questionText: "我看到一頭 ______。\n(Wǒ kàndào yī tóu ______.)",
    options: ["狗 (gǒu)", "大象 (dàxiàng)", "馬 (mǎ)", "羊 (yáng)"],
    correctIndex: 1,
  ),
  QuestionModel(
    image: "assets/images/tiger.jpg",
    questionText: "叢林裡有一隻 ______。\n(Cónglín lǐ yǒu yī zhī ______.)",
    options: ["老虎 (lǎohǔ)", "馬 (mǎ)", "羊 (yáng)", "狗 (gǒu)"],
    correctIndex: 0,
  ),
  QuestionModel(
    image: "assets/images/goat.jpg",
    questionText: "山上有一隻 ______。\n(Shān shàng yǒu yī zhī ______.)",
    options: ["狗 (gǒu)", "馬 (mǎ)", "魚 (yú)", "山羊 (shānyáng)"],
    correctIndex: 3,
  ),
];

  @override
  void onInit() {
    super.onInit();
    activity = Get.arguments?['activity'];
    swipeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    swipeAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(-2, 0))
        .animate(CurvedAnimation(parent: swipeController, curve: Curves.easeInOut));
    updateProgress();
  }

  void selectOption(int index) async {
    selectedOption.value = index;

    if (index == questions[currentIndex.value].correctIndex) {
      answerColor[index] = Colors.lightGreen;
      await Future.delayed(const Duration(milliseconds: 500));
      await swipeController.forward();
      nextQuestion();
      swipeController.reset();
    } else {
      answerColor[index] = Colors.red.shade200;
      await Future.delayed(const Duration(seconds: 1));
      answerColor.remove(index); 
    }
  }

  void passQuestion() async {
    await swipeController.forward();
    nextQuestion();
    swipeController.reset();
  }

  void nextQuestion() {
   
      // Get.back if last question
      if (currentIndex.value < questions.length - 1) {
        currentIndex.value++;
        selectedOption.value = -1;
        answerColor.clear();
        updateProgress();
      } else {
        Get.back();
      }
    
  }

  void updateProgress() {
    progress.value = (currentIndex.value + 1) / questions.length;
  }

  @override
  void onClose() {
    swipeController.dispose();
    super.onClose();
  }
}
