import 'package:flutter/material.dart';

class CustomWidgetBorder extends OutlineInputBorder {
  final Color? color;
  final double width;

  CustomWidgetBorder({required this.color, required this.width})
      : super(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: color!,
            width: width,
          ),
        );
}
