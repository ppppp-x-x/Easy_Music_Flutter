import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' as ui;

import './../../redux/index.dart';
import './../../utils/request.dart';
import './../../redux/audioController/action.dart';

class Play extends StatefulWidget {
  int songId;
  Play(this.songId);
  @override
  PlayState createState() => new PlayState(songId);
}

class PlayState extends State<Play> with SingleTickerProviderStateMixin{
  int songId;
  PlayState(this.songId);

  dynamic songDetail;
  bool initPlay;
  AnimationController coverController;
  CurvedAnimation coverCurved;

  @override
  void initState() {
    super.initState();
    getSongDetail(songId);
    initPlay = false;
    coverController = new AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 40
      ),
    );
    coverCurved = new CurvedAnimation(
      parent: coverController,
      curve: Curves.linear
    );
    coverController.repeat();
  }

  @override
  void dispose() {
    if(this.mounted) {
      coverController.dispose();
      super.dispose();
    }
  }

  dynamic getSongDetail(int id) async {
    dynamic _songDetail = await fetchData('http://xinpeng.natapp1.cc/song/detail?ids=' + id.toString());
    if(this.mounted) {
      setState(() {
      songDetail = _songDetail['playList']; 
      });
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
                  state.playListModelState.playList[state.playListModelState.currentIndex - 1]['albumBg'],
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
                          state.playListModelState.playList[state.playListModelState.currentIndex - 1]['name'],
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                        Text(
                          state.playListModelState.playList[state.playListModelState.currentIndex - 1]['singer'],
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
                        margin: EdgeInsets.only(top: 150),
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
                        margin: EdgeInsets.fromLTRB(10, 160, 0, 0),
                        child: ClipOval(
                          child: 
                          state.audioControllerState.playing || (this.initPlay != null && this.initPlay == true)
                          ?
                          RotationTransition(
                            turns: coverCurved,
                            child: CachedNetworkImage(
                              imageUrl: state.playListModelState.playList[state.playListModelState.currentIndex - 1]['albumBg'],
                              placeholder: Container(
                                width: MediaQuery.of(context).size.width * 0.6 - 20,
                                height: MediaQuery.of(context).size.width * 0.6 - 20,
                                color: Colors.grey,
                              ),
                            ),
                          )
                          :
                          CachedNetworkImage(
                            imageUrl: state.playListModelState.playList[state.playListModelState.currentIndex - 1]['albumBg'],
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
                margin: EdgeInsets.fromLTRB(40, MediaQuery.of(context).size.width * 0.6 + 210, 40, 0),
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
              ),
              PlayController(songId, state, coverController, setInitPlay)
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
  AnimationController coverController;
  dynamic setInitPlay;
  PlayController(this.songId, this.state, this.coverController, this.setInitPlay);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: EdgeInsets.fromLTRB(30, MediaQuery.of(context).size.width * 0.6 + 300, 30, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(0, -1)
                  )
                ]
              ),
              child: Image.asset(
                'assets/images/play_prev.png'
              )
            ),
            StoreConnector<AppState, VoidCallback>(
              converter: (store) {
                var _action = new Map();
                if (state.audioControllerState.playing == true) {
                  _action['type'] = Actions.pause;
                } else {
                  _action['type'] = Actions.play;
                }
                return () => store.dispatch(_action);
              },
              builder: (BuildContext context, callback) {
                return GestureDetector(
                  onTap: () {
                    if(state.audioControllerState.playing == true) {
                      this.coverController.stop();
                    } else {
                      this.coverController.forward();
                      this.setInitPlay(true);
                    }
                    callback();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: Offset(0, -1)
                        )
                      ]
                    ),
                    child: state.audioControllerState.playing
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
              decoration: BoxDecoration(
                color: Colors.grey[900],
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(0, -1)
                  )
                ]
              ),
              child: Image.asset(
                'assets/images/play_next.png'
              )
            )   
          ],
        )
      );
  }
}