import 'package:flutter/material.dart';

class NavigatorBackBar extends StatelessWidget {
  final Function callback;
  NavigatorBackBar(this.callback);

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
              color: Colors.black87
            ),
          ),
        ),
      ],
    );
  }
}