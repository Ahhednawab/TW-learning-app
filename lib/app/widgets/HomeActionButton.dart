import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandarinapp/app/constants/Colors.dart';
import 'package:mandarinapp/app/helper/responsive.dart';

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
          icon: Icon(
            icon,
            color: whiteColor,
            size: Responsive.isTablet(Get.context!) ? 42 : 28,
          ),
          onPressed: onTap,
          splashRadius: Responsive.isTablet(Get.context!) ? 42 : 28,
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: Responsive.wp(0.20),
        child: Text(
          label,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: Responsive.sp(Get.context!, 14),
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
