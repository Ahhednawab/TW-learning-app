import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/widgets/CustomAppBar.dart';
import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: customAppBar(
          title: 'Favorite Words',
        ),
        body:Padding(padding: EdgeInsets.all(14),
        child:Column(
          children: [],
        ),)
      ),
    );
  }
}
