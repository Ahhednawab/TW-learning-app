import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mandarinapp/app/constants/Colors.dart';

Widget ProfileHeader({
  String? avatarUrl,
  required String userName,
  required int learnedWords,
  VoidCallback? onEdit,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor, width: 1),
          ),
          child: CircleAvatar(
            radius: 38,
            backgroundColor: primaryColor,
            // backgroundImage:
            //     avatarUrl != null ? AssetImage(avatarUrl) : null,
            child:Text('${avatarUrl}', style: TextStyle(color: whiteColor, fontSize: 44)),
                // avatarUrl == null
                //     ? Icon(Icons.person, color: Color(0xFF1CA6A6), size: 54)
                //     : null,
          ),
        ),
        const SizedBox(width: 18),
        // Name, learned words, edit
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 2),
              // Text(
              //   'learned'.tr+ ' $learnedWords ' +'words'.tr.toLowerCase(),
              //   style: const TextStyle(
              //     fontSize: 16,
              //     color: primaryColor,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
              // const SizedBox(height: 4),
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  'editprofile'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: greyColor,
                    decoration: TextDecoration.underline,
                    decorationColor: greyColor,
                    decorationThickness: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
