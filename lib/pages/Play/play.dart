import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import './../../redux/index.dart';
import './../../redux/playController/action.dart';
import './../../components/songComments.dart';
class Play extends StatefulWidget {
  @override
  PlayState createState() => new PlayState();
}

class PlayState extends State<Play> with SingleTickerProviderStateMixin {
  int songId;
  bool initPlay;
  bool showSongComments = false;
  dynamic songDetail;

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
              ProcessController(state),
              PlayController(songId, state, setInitPlay),
              SongComments()
            ],
          )
        );
      }
    );
  }
}

class ProcessController extends StatefulWidget {
  dynamic state;
  @override
  ProcessController(this.state);
  ProcessControllerState createState () => new ProcessControllerState(state);
}

class ProcessControllerState extends State<ProcessController> {
  dynamic state;
  ProcessControllerState(this.state);

  // swtich auto refresh view
  bool refreshView = true;
  // is touching process bar
  bool processTouching = false;
  double processVal = 0.0;
  Timer timer;
  // save&&dispatch playProcess
  Map durationActionMap = new Map();
  Map showSongCommentsAction = {};

  double computeProcessVal(String position, String duration) {
    // current play percentage: 0.55555555
    double currentPercent = stringDurationToDouble(position) / stringDurationToDouble(duration); 
    if(!this.processTouching) {
      this.processVal = currentPercent * 500;
    }
    return currentPercent * 500;
  }

  double stringDurationToDouble (String duration) {
    return double.parse(duration.substring(0, 2)) * 60 + double.parse(duration.substring(3, 5));
  }

  // 
  List<String> getLyricsNow(List<dynamic> allLyrics, String timeNow, Duration allTime) {
    double _timeNow = stringDurationToDouble(timeNow);
    List<String> _lyricsNow = [];
    List<dynamic> _lyrics = [];
    if (allLyrics != null && allLyrics.length > 0) {
      allLyrics.forEach((item) {
        List<dynamic> _subLyrics = [];
        if (item.length != null && item.length == 2 && item[0] != null && item[1] != null) {
          if (item[0].length > 5) {
            _subLyrics.add(stringDurationToDouble(item[0].substring(0, 5)));
          } else {
            _subLyrics.add('');
          }
          _subLyrics.add(item[1]);
          _lyrics.add(_subLyrics);
        }
      });
    }
    for (int i = 0;i < _lyrics.length;i ++) {
      if (_timeNow >= _lyrics[i][0] && (i == _lyrics.length - 1 || _timeNow <= _lyrics[i + 1][0])) {
        _lyricsNow.add(i > 0 ? _lyrics[i - 1][1] : '');
        _lyricsNow.add(_lyrics[i][1]);
        _lyricsNow.add(i < _lyrics.length - 1 ? _lyrics[i + 1][1] : '');
      }
    }
    return _lyricsNow.length > 0
      ? _lyricsNow 
      : [
        '',
        '正在搜索歌词',
        ''
      ];
  }

  @override
  void initState() {
    this.showSongCommentsAction['type'] = Actions.switchSongComments;
    timer = Timer.periodic(const Duration(milliseconds: 100), (Void) {
      setState(() {
       this.refreshView = !this.refreshView; 
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state.playControllerState,
      builder: (BuildContext context, playControllerState) {
        return Stack(
          children: <Widget>[
            // 之所以要把封面模块也写在进度条模块内是为了解决自动切换歌曲时不刷新封面视图的问题
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.width),
              // child: CachedNetworkImage(
              //   imageUrl: state.playControllerState.playList[state.playControllerState.currentIndex]['al']['picUrl'],
              //   placeholder: (context, url) => Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height,
              //     color: Colors.grey,
              //   ),
              //   fit: BoxFit.cover,
              // )
            ),
            // BackdropFilter(
            //   filter: ui.ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
            //   child: Container(
            //     color: Colors.white.withOpacity(0.1),
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height,
            //   )
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl: state.playControllerState.playList[state.playControllerState.currentIndex]['al']['picUrl'],
                placeholder: (context, url) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                ),
              )
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
                          state.playControllerState.playList[state.playControllerState.currentIndex ]['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                        Text(
                          state.playControllerState.playList[state.playControllerState.currentIndex ]['ar'][0]['name'],
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        StoreConnector<AppState, VoidCallback>(
                          converter: (store) {
                            return () => store.dispatch(this.showSongCommentsAction);
                          },
                          builder: (BuildContext context, callback) {
                            return InkWell(
                              child: IconButton(
                                icon: Icon(Icons.comment),
                                iconSize: 20,
                                color: Colors.white,
                                onPressed: () {
                                  callback();
                                },
                              ),
                            );
                          }
                        ),
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
                        // IconButton(
                        //   iconSize: 20,
                        //   color: Colors.white,
                        //   onPressed: () {
                        //     print('未开发');
                        //   },
                        //   icon: ImageIcon(
                        //     AssetImage(
                        //       'assets/images/random.png'
                        //     )
                        //   )
                        // )
                      ],
                    )
                  )
                ],
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height - 210),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 25,
                        alignment: Alignment.topCenter,
                        child: Text(
                          playControllerState.songPosition != null
                            ? this.getLyricsNow(playControllerState.playList[playControllerState.currentIndex ]['lyric'], playControllerState.songPosition.toString().substring(2, 7), playControllerState.audioPlayer.duration)[0]
                            : '',
                          style: TextStyle(
                            color: Colors.black54
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 25,
                        alignment: Alignment.topCenter,
                        child: Text(
                          playControllerState.songPosition != null
                            ? this.getLyricsNow(playControllerState.playList[playControllerState.currentIndex ]['lyric'], playControllerState.songPosition.toString().substring(2, 7), playControllerState.audioPlayer.duration)[1]
                            : '',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 25,
                        alignment: Alignment.topCenter,
                        child: Text(
                          playControllerState.songPosition != null
                            ? this.getLyricsNow(playControllerState.playList[playControllerState.currentIndex ]['lyric'], playControllerState.songPosition.toString().substring(2, 7), playControllerState.audioPlayer.duration)[2]
                            : '',style: TextStyle(
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 35,
                          child: Text(
                            playControllerState.songPosition == null
                            ?
                            ''
                            :
                            playControllerState.songPosition.toString().substring(2, 7),
                            style: TextStyle(
                              color: Colors.black87
                            ),
                          )
                        ),
                        Text(
                          playControllerState.songPosition != null
                            ?
                            computeProcessVal(playControllerState.songPosition.toString().substring(2, 7), playControllerState.audioPlayer.duration.toString().substring(2, 7)).toString()
                            :
                            '',
                          style: TextStyle(
                            fontSize: 0,
                          ),
                        ),
                        StoreConnector<AppState, VoidCallback>(
                          converter: (store) {
                            return () => store.dispatch(durationActionMap);
                          },
                          builder: (BuildContext context, callback) {
                            return Container(
                              width: MediaQuery.of(context).size.width - 95,
                              child: Slider(
                                value: this.processVal,
                                max: 500,
                                min: 0,
                                label: ((this.processVal.floor() / 500) * (int.parse(playControllerState.audioPlayer.duration.toString().substring(2, 4)) * 60 +
                                  int.parse(playControllerState.audioPlayer.duration.toString().substring(5, 7))) / 60).floor().toString() + '：' +
                                  ((this.processVal.floor() / 500) * (int.parse(playControllerState.audioPlayer.duration.toString().substring(2, 4)) * 60 +
                                  int.parse(playControllerState.audioPlayer.duration.toString().substring(5, 7))) % 60).floor().toString(),
                                activeColor: Colors.black,
                                inactiveColor: Colors.black26,
                                divisions: 500,
                                onChangeStart: (double val) {
                                  this.timer.cancel();
                                  this.processTouching = true;
                                },
                                onChanged: (double val) {
                                  setState(() {
                                    this.processVal = val; 
                                  });
                                },
                                onChangeEnd: (double val) async{
                                  int _songSecond = int.parse(playControllerState.audioPlayer.duration.toString().substring(2, 4)) * 60 +
                                  int.parse(playControllerState.audioPlayer.duration.toString().substring(5, 7));
                                  durationActionMap['type'] = Actions.playSeek;
                                  durationActionMap['payLoad'] = _songSecond * this.processVal.floor() / 500;
                                  callback();
                                  await new Future.delayed(const Duration(milliseconds: 500));
                                  this.processTouching = false;
                                  if (this.mounted) {
                                    setState(() {
                                      this.timer = Timer.periodic(const Duration(microseconds: 100), (Void) {
                                        setState(() {
                                          this.refreshView = !this.refreshView; 
                                        });
                                      });
                                    });
                                  }
                                },
                              ),
                            );
                          },
                        ),
                        Container(
                          width: 35,
                          child: Text(
                            playControllerState.audioPlayer.duration == null
                            ?
                            ''
                            :
                            playControllerState.audioPlayer.duration.toString().substring(2, 7),
                            style: TextStyle(
                              color: Colors.black87
                            ),
                          )
                        )
                      ],
                    )
                  )
                ],
              )
            )
          ],
        );
      },
    );
  }
}

class PlayController extends StatelessWidget {
  int songId;
  bool isRequesting = false;
  dynamic state;
  dynamic setInitPlay;
  dynamic songListAction;
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
            StoreConnector<AppState, VoidCallback>(
              converter: (store) {
                var _action = new Map();
                _action['type'] = Actions.addCollectSong;
                return () => store.dispatch(_action);
              },
              builder: (BuildContext context, callback) {
                return GestureDetector(
                  onTap: () {
                    callback();
                  },
                  child: Container( 
                    width: 30,
                    height: 30,
                    padding: EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/images/unLike.png'
                    )
                  ),
                );
              }
            ),
            Container( 
              width: 30,
              height: 30,
              padding: EdgeInsets.all(5),
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
                    padding: EdgeInsets.all(10),
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
            StoreConnector<AppState, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(playeNextSong);
              },
              builder: (BuildContext context, callback) {
                if (this.isRequesting == true) {
                  return null;
                }
                this.isRequesting = true;
                return InkWell(
                  onTap: () async {
                    // this.songListAction = await getNextSongData(state);
                    this.isRequesting = false;
                    callback();
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    padding: EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/images/play_next.png',
                    )
                  )   
                );
              }
            ),
            Container( 
              width: 30,
              height: 30,
              padding: EdgeInsets.all(5),
              child: Image.asset(
                'assets/images/next_play.png'
              )
            ),
          ],
        )
      );
  }
}