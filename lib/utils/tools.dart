import 'package:flutter/material.dart';
import 'dart:math';

Color randomColor() {
    return Color.fromARGB(60, Random().nextInt(256) + 0, Random().nextInt(256) + 0, Random().nextInt(256) + 0);
}

double stringDurationToDouble (String duration) {
  return double.parse(duration.substring(0, 2)) * 60 + double.parse(duration.substring(3, 5));
}