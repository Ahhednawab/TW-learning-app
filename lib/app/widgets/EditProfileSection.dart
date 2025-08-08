import 'package:flutter/material.dart';

Widget EditableInfoSection({
  required String label,
  required String value,
  required Color textColor,
  VoidCallback? onEdit,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: textColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit_square, color: textColor),
          ),
        ],
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
