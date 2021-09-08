import 'package:flutter/material.dart';

class AppData {
  static GlobalKey<NavigatorState> mainNavKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> experimentNavKey =
      GlobalKey<NavigatorState>();

  static int? groupNumber;

  static bool locked = false;
}
