import 'package:flutter/material.dart';

class AppData {
  static GlobalKey<NavigatorState> mainNavKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> experimentNavKey =
      GlobalKey<NavigatorState>();

  static int? groupNumber;

  static bool locked = false;
  static bool finished = false;

  static Map quizOneAnswers = {};
  static Map quizTwoAnswers = {};
}
