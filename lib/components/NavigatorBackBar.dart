import 'package:flutter/material.dart';

class NavigatorBackBar extends StatelessWidget {
  final Function callback;
  final Color iconColor;
  NavigatorBackBar(this.callback, this.iconColor);

  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: IconButton(
            onPressed: () {
              callback();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 26,
              color: iconColor??Colors.white
            ),
          ),
        ),
      ],
    );
  }
}