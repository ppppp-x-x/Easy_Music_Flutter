import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' as ui;

import './../../redux/playList/state.dart';

class Play extends StatefulWidget {
  @override
  PlayState createState() => new PlayState();
}

class PlayState extends State<Play> {
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
    return StoreConnector<PlayListModelState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        return Material(
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.network(
                  state.playList[state.currentIndex - 1]['albumBg'],
                  fit: BoxFit.cover,
                ),
              ),
              BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                )
              ),
              Container(
                height: 100,
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          state.playList[state.currentIndex - 1]['name'],
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                        Text(
                          state.playList[state.currentIndex - 1]['singer'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        print('暂未开发');
                      },
                      child: Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      )
                    )
                  ],
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 200),
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: Offset(0, 0)
                            )
                          ]
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 - 20,
                        height: MediaQuery.of(context).size.width * 0.6 - 20,
                        margin: EdgeInsets.fromLTRB(10, 210, 0, 0),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: state.playList[state.currentIndex - 1]['albumBg'],
                            placeholder: Container(
                              width: MediaQuery.of(context).size.width * 0.6 - 20,
                              height: MediaQuery.of(context).size.width * 0.6 - 20,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ),
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(40, MediaQuery.of(context).size.width * 0.6 + 240, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        print('暂未开发');
                      },
                      color: Colors.white,
                      iconSize: 20,
                      icon: ImageIcon(
                        AssetImage(
                          'assets/images/like_playList.png',
                        )
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        print('暂未开发');
                      },
                      color: Colors.white,
                      iconSize: 20,
                      icon: ImageIcon(
                        AssetImage(
                          'assets/images/comment_playList.png',
                        )
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        print('暂未开发');
                      },
                      color: Colors.white,
                      iconSize: 20,
                      icon: ImageIcon(
                        AssetImage(
                          'assets/images/retweet_playList.png',
                        )
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        print('暂未开发');
                      },
                      color: Colors.white,
                      iconSize: 20,
                      icon: Icon(Icons.file_download)
                    )
                  ],
                ),
              )
            ],
          )
        );
      }
    );
  }
}