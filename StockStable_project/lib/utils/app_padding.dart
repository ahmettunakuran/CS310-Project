import 'package:flutter/material.dart';

class AppPadding {
  // General Padding
  static const EdgeInsets all8 = EdgeInsets.all(8);
  static const EdgeInsets all16 = EdgeInsets.all(16);
  static const EdgeInsets all20 = EdgeInsets.all(20);
  static const EdgeInsets all24 = EdgeInsets.all(24);

  // Symmetric Padding
  static const EdgeInsets horizontal16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets horizontal20 = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets vertical12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets vertical16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets vertical20 = EdgeInsets.symmetric(vertical: 20);
  static const EdgeInsets vertical24 = EdgeInsets.symmetric(vertical: 24);

  // Specific side paddings
  static const EdgeInsets bottom18 = EdgeInsets.only(bottom: 18);
  static const EdgeInsets top60 = EdgeInsets.only(top: 60);
  static const EdgeInsets top24 = EdgeInsets.only(top: 24);
  static const EdgeInsets top32 = EdgeInsets.only(top: 32);
  static const EdgeInsets bottom12 = EdgeInsets.only(bottom: 12);

  // Common Combinations
  static const EdgeInsets listPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsets bottomButton = EdgeInsets.all(18);
}
