import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle welcome = TextStyle(
    fontFamily: 'LibreBaskerville',
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0067F1),
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'LibreBaskerville',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  static const TextStyle link = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0067F1),
    decoration: TextDecoration.underline,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
