import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' as ui;

import './../../redux/index.dart';
import './../../redux/playController/action.dart';

class Play extends StatefulWidget {
  @override
  PlayState createState() => new PlayState();
}

class PlayState extends State<Play> with SingleTickerProviderStateMixin{
  int songId;

  dynamic songDetail;
  bool initPlay;
  CurvedAnimation coverCurved;

  @override
  void initState() {
    super.initState();
    initPlay = false;
  }

  @override
  void dispose() {
    if(this.mounted) {
      super.dispose();
    }
  }

  void setInitPlay (bool val) {
    this.setState(() {
      initPlay = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        return Material(
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.network(
                  state.playControllerState.playList[state.playControllerState.currentIndex - 1]['al']['picUrl'],
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
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  imageUrl: state.playControllerState.playList[state.playControllerState.currentIndex - 1]['al']['picUrl'],
                  placeholder: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                height: 70,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width - 70),
                padding: EdgeInsets.only(left: 40),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.black26
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: (MediaQuery.of(context).size.width - 50) * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            state.playControllerState.playList[state.playControllerState.currentIndex - 1]['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            state.playControllerState.playList[state.playControllerState.currentIndex - 1]['ar'][0]['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 50) * 0.4,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            iconSize: 20,
                            color: Colors.white,
                            onPressed: () {
                              print('未开发');
                            },
                            icon: ImageIcon(
                              AssetImage(
                                'assets/images/loop.png'
                              )
                            )
                          ),
                          IconButton(
                            iconSize: 20,
                            color: Colors.white,
                            onPressed: () {
                              print('未开发');
                            },
                            icon: ImageIcon(
                              AssetImage(
                                'assets/images/random.png'
                              )
                            )
                          )
                        ],
                      )
                    )
                  ],
                )
              ),
              // Container(
              //   margin: EdgeInsets.fromLTRB(40, MediaQuery.of(context).size.height * 0.7, 40, 0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: <Widget>[
              //       IconButton(
              //         onPressed: () {
              //           print('暂未开发');
              //         },
              //         color: Colors.white,
              //         iconSize: 20,
              //         icon: ImageIcon(
              //           AssetImage(
              //             'assets/images/like_playList.png',
              //           )
              //         ),
              //       ),
              //       IconButton(
              //         onPressed: () {
              //           print('暂未开发');
              //         },
              //         color: Colors.white,
              //         iconSize: 20,
              //         icon: ImageIcon(
              //           AssetImage(
              //             'assets/images/comment_playList.png',
              //           )
              //         ),
              //       ),
              //       IconButton(
              //         onPressed: () {
              //           print('暂未开发');
              //         },
              //         color: Colors.white,
              //         iconSize: 20,
              //         icon: ImageIcon(
              //           AssetImage(
              //             'assets/images/retweet_playList.png',
              //           )
              //         ),
              //       ),
              //       IconButton(
              //         onPressed: () {
              //           print('暂未开发');
              //         },
              //         color: Colors.white,
              //         iconSize: 20,
              //         icon: Icon(Icons.file_download)
              //       )
              //     ],
              //   ),
              // ),
              PlayController(songId, state, setInitPlay)
            ],
          )
        );
      }
    );
  }
}

class PlayController extends StatelessWidget {
  int songId;
  dynamic state;
  dynamic setInitPlay;
  PlayController(this.songId, this.state, this.setInitPlay);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: EdgeInsets.fromLTRB(30, MediaQuery.of(context).size.height * 0.87, 30, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/play_prev.png'
              )
            ),
            StoreConnector<AppState, VoidCallback>(
              converter: (store) {
                var _action = new Map();
                if (state.playControllerState.playing == true) {
                  _action['type'] = Actions.pause;
                } else {
                  _action['type'] = Actions.play;
                }
                return () => store.dispatch(_action);
              },
              builder: (BuildContext context, callback) {
                return GestureDetector(
                  onTap: () {
                    if(state.playControllerState.playing != true) {
                      this.setInitPlay(true);
                    }
                    callback();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(15),
                    child: state.playControllerState.playing
                    ?
                    Image.asset(
                      'assets/images/play_pause.png'
                    )
                    :
                    Image.asset(
                      'assets/images/play_play.png'
                    )
                  ),
                );
              }
            ),
            Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/play_next.png'
              )
            )   
          ],
        )
      );
  }
}