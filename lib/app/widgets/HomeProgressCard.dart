import 'package:flutter/material.dart';
import 'package:mandarinapp/app/constants/Colors.dart';

Widget HomeProgressCard({
  required String level,
  required int? words,
  required int? totalWords,
  required VoidCallback? onTap,
}) {
  double getProgress(int? words, int? totalWords) {
    final total = (totalWords ?? 0);
    if (total == 0) return 0.0;
    return ((words ?? 0) / total).clamp(0.0, 1.0);
  }

  print(getProgress(words, totalWords));

  print((words ?? 0) / (totalWords ?? 1).toDouble());
  return InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Color(0xFFE9FFFD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.menu_book_rounded, color: Color(0xFF61CBC2), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: blackColor,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: getProgress(words, totalWords),
                  minHeight: 6,
                  color: primaryColor,
                  backgroundColor: lightgreyColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Words ${words ?? 0}/${totalWords ?? 0}',
                style: TextStyle(color: greyColor, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Icon(Icons.arrow_forward_ios_rounded, color: greyColor, size: 18),
            ],
          ),
        ],
      ),
    ),
  );
}
