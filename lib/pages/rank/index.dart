import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Rank extends StatefulWidget {
  @override
  RankState createState() => new RankState();
}

class RankState extends State<Rank> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/images/billboard.jpg')
                  )
                )
              ),
              Text(
                'BillBoard'
              )
            ],
          ),
          GridView.builder(
             itemBuilder: context,
          )
        ],
      )
    );
  }
}