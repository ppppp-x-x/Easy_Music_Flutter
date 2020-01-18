import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final int maxLines;
  final Color color;
  final FontWeight fontWeight;

  CommonText(this.text, this.fontSize, this.maxLines, this.color, this.fontWeight);

  Widget build(BuildContext context) {
    return Text(
      text == null
        ? ''
        : text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight
      ),
    );
  }
}