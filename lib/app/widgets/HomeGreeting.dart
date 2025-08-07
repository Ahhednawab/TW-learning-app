import 'package:flutter/material.dart';
import '../constants/Colors.dart';

Widget HomeGreeting({required userName}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Hi $userName,',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: blackColor,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        "Let's learn something",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: greyColor,
        ),
      ),
    ],
  );
}
