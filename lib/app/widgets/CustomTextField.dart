import 'package:flutter/material.dart';

Widget customTextField({
  required String label,
  String? Function(String?)? validator,
  required TextEditingController controller,
  bool obscureText = false,
  IconData? icon,
  TextInputType keyT = TextInputType.text,
  VoidCallback? onTap,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: obscureText,
    keyboardType: keyT,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      suffixIcon: icon != null ? GestureDetector(onTap: onTap,child: Icon(icon, color: Colors.grey)) : null,
    ),
  );
}