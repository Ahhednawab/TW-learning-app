import 'package:flutter/material.dart';
import 'package:mandarinapp/app/constants/Colors.dart';

Widget HomeActionButton({
  required String label,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return Column(
      children: [
        Ink(
          decoration: ShapeDecoration(
            color: primaryColor,
            shape: const CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(icon, color: whiteColor, size: 28),
            onPressed: onTap,
            splashRadius: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
}