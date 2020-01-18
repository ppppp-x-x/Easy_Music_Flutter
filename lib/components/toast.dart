import 'package:flutter/material.dart';

import './commonText.dart';

class Toast extends StatelessWidget {
  final String message;

  Toast(this.message);

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.5,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromRGBO(220, 220, 220, 0.3), 
        ),
        child: CommonText(
          message, 
          12, 
          1, 
          Colors.black87,
          FontWeight.normal
        )
      )
    );
  }
}