import 'package:flutter/material.dart';
import 'package:mandarinapp/app/constants/Colors.dart';

class ProfileSectionHeader extends StatelessWidget {
  final String title;
  const ProfileSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 12, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: greyColor,
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.2,

          
        ),
      ),
    );
  }
}
