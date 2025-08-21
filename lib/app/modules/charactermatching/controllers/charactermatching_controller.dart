import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class CharactermatchingController extends GetxController with GetTickerProviderStateMixin{
  String? activity;

  var currentIndex = 0.obs;
  var matchesFound = 0.obs;
  var progress = 0.0.obs;

  var selectedLeft = (-1).obs;
  var selectedRight = (-1).obs;

  // Tracks which images are revealed
  var revealed = <bool>[false, false, false, false].obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // 3 questions: images, Chinese, English
  final List<Map<String, dynamic>> questions =  [
    {
      "images": [
        "assets/images/sheep.png",
        "assets/images/horse.png",
        "assets/images/dog.png",
        "assets/images/fish.jfif",
      ],
      "chinese": ["羊", "馬", "狗", "魚"],
      "english": ["Sheep", "Horse", "Dog", "Fish"],
      "map": {
        0: 0, // Sheep
        1: 1, // Horse
        2: 2, // Dog
        3: 3, // Fish
      }
    },
    {
      "images": [
        "assets/images/cat.jpg",
        "assets/images/monkey.webp",
        "assets/images/bird.jpg",
        "assets/images/cow.webp",
      ],
      "chinese": ["貓", "猴子", "鳥", "牛"],
      "english": ["Cat", "Monkey", "Bird", "Cow"],
      "map": {
        0: 0,
        1: 1,
        2: 2,
        3: 3,
      }
    },
    {
      "images": [
        "assets/images/pig.jpg",
        "assets/images/goat.jpg",
        "assets/images/duck.jpg",
        "assets/images/chicken.webp",
      ],
      "chinese": ["豬", "山羊", "鴨子", "雞"],
      "english": ["Pig", "Goat", "Duck", "Chicken"],
      "map": {
        0: 0,
        1: 1,
        2: 2,
        3: 3,
      }
    },
  ];

  @override
  void onInit() {
    super.onInit();
    activity = Get.arguments['activity'] ?? '';
    resetQuestion();
  }


     void playSound(String filePath) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(filePath));
  }

  void selectLeft(int index) {
    selectedLeft.value = index;
    checkMatch();
  }

  void selectRight(int index) {
    selectedRight.value = index;
    checkMatch();
  }

  void checkMatch() {
    if (selectedLeft.value != -1 && selectedRight.value != -1) {
      var map = questions[currentIndex.value]["map"] as Map<int, int>;
      if (map[selectedLeft.value] == selectedRight.value) {
        // Correct
        revealed[selectedLeft.value] = true;
        matchesFound.value++;
        selectedLeft.value = -1;
        selectedRight.value = -1;
        playSound('audio/correct.mp3');
        if (matchesFound.value == 4) {
          nextQuestion();
        }
      } else {
        // Wrong — reset after short delay
        playSound('audio/failure.mp3');
        Future.delayed(Duration(milliseconds: 300), () {
          selectedLeft.value = -1;
          selectedRight.value = -1;
        });
      }
    }
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      resetQuestion();
    } else {
      // End — go back or show result
      Get.back();
    }
  }

  void passQuestion() {
    nextQuestion();
  }

  void resetQuestion() {
    revealed.value = [false, false, false, false];
    matchesFound.value = 0;
    selectedLeft.value = -1;
    selectedRight.value = -1;
    progress.value = (currentIndex.value) / questions.length;
  }

   @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
