import 'package:flutter/material.dart';
import 'dart:math';

Color randomColor() {
    return Color.fromARGB(60, Random().nextInt(256) + 0, Random().nextInt(256) + 0, Random().nextInt(256) + 0);
}