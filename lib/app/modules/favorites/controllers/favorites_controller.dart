import 'package:get/get.dart';

class Favorite{
  final String word;
  final String meaning;
  final String image;

  Favorite({required this.word, required this.meaning, required this.image});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      word: json['word'],
      meaning: json['meaning'],
      image: json['image'],
    );
  }

}

class FavoritesController extends GetxController {

  List<Favorite> favorites = [
    Favorite(
      word: '大',
      meaning: 'big',
      image: 'assets/images/profile.png',
    ),
    Favorite(
      word: '小',
      meaning: 'small',
      image: 'assets/images/profile.png',
    ),
    Favorite(
      word: '天',
      meaning: 'sky',
      image: 'assets/images/profile.png',
    ),
    Favorite(
      word: '地',
      meaning: 'earth',
      image: 'assets/images/profile.png',
    ),
    Favorite(
      word: '在',
      meaning: 'at',
      image: 'assets/images/profile.png',
    ),
    Favorite(
      word: '太',
      meaning: 'too',
      image: 'assets/images/profile.png',
    ),
    Favorite(
      word: '太',
      meaning: 'too',
      image: 'assets/images/profile.png',
    ),
   ];
 
  @override
  void onInit() {
    super.onInit();
  }
}
