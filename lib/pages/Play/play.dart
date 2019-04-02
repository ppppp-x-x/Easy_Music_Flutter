import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' as ui;
import 'dart:async';

import './../../redux/index.dart';
import './../../redux/playController/action.dart';
import './../../utils/url.dart';
import './../../utils/request.dart';
import './../../utils/commonFetch.dart';

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
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width),
                child: CachedNetworkImage(
                  imageUrl: state.playControllerState.playList[state.playControllerState.currentIndex]['al']['picUrl'],
                  placeholder: (context, url) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.grey,
                  ),
                  fit: BoxFit.cover,
                )
              ),
              BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                )
              ),
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
              ProcessController(state),
              PlayController(songId, state, setInitPlay)
            ],
          )
        );
      }
    );
  }
}

class ProcessController extends StatefulWidget {
  @override
  dynamic state;
  ProcessController(this.state);
  ProcessControllerState createState () => new ProcessControllerState(state);
}

class ProcessControllerState extends State<ProcessController> {
  dynamic state;
  ProcessControllerState(this.state);

  double processVal = 0.0;
  double processValAgent = 0.0;
  double lastProcessVal = 0.0;
  bool refreshView = true;
  bool processTouching = false;
  dynamic timer;
  dynamic actionMap = new Map();
  bool processValAgentLock = false;
  String lyricsNow = '正在搜索歌词';
  var lyrics = [];
  String currentDuration;

  double computeProcessVal(String position, String duration) {
    double parsedPosition = stringDurationToDouble(position);
    double parsedDuration = stringDurationToDouble(duration);
    this.processVal = ((parsedPosition / parsedDuration) * 500);
    if(!this.processTouching && !processValAgentLock) {
      this.processValAgent = ((parsedPosition / parsedDuration) * 500);
    }
    return this.processVal;
  }

  double stringDurationToDouble (String duration) {
    return double.parse(duration.substring(0, 2)) * 60 + double.parse(duration.substring(3, 5));
  }

  String getLyricsNow(List<dynamic> allLyrics, String timeNow, Duration allTime) {
    double _timeNow = stringDurationToDouble(timeNow);
    var _lyrics = [];
    if (currentDuration != allTime.toString().substring(0)) {
      currentDuration = allTime.toString().substring(0);
      allLyrics.forEach((item) {
        List<dynamic> _subLyrics = [];
        if (item.length != null && item.length == 2 && item[0] != null && item[1] != null) {
          _subLyrics.add(stringDurationToDouble(item[0].substring(0, 5)));
          _subLyrics.add(item[1]);
          _lyrics.add(_subLyrics);
        }
      });
      this.lyrics = _lyrics;
    }
    for (int i = 0;i < this.lyrics.length;i ++) {
      if (_timeNow >= this.lyrics[i][0]) {
        this.lyricsNow = this.lyrics[i][1];
      }
    }
    return lyricsNow;
  }

  @override
  void initState() {
    this.processValAgentLock = false;
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
    this.processValAgentLock = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state.playControllerState,
      builder: (BuildContext context, playControllerState) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height - 180),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      this.getLyricsNow(playControllerState.playList[playControllerState.currentIndex ]['lyric'], playControllerState.songPosition.toString().substring(2, 7), playControllerState.audioPlayer.duration) != null && this.getLyricsNow(playControllerState.playList[playControllerState.currentIndex ]['lyric'], playControllerState.songPosition.toString().substring(2, 7), playControllerState.audioPlayer.duration) != ''
                      ?
                      this.getLyricsNow(playControllerState.playList[playControllerState.currentIndex ]['lyric'], playControllerState.songPosition.toString().substring(2, 7), playControllerState.audioPlayer.duration)
                      :
                      ''
                    ),
                  )
                ],
              ),
              Row(
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
                    computeProcessVal(playControllerState.songPosition.toString().substring(2, 7), playControllerState.audioPlayer.duration.toString().substring(2, 7)).toString(),
                    style: TextStyle(
                      fontSize: 0,
                    ),
                  ),
                  StoreConnector<AppState, VoidCallback>(
                    converter: (store) {
                      return () => store.dispatch(actionMap);
                    },
                    builder: (BuildContext context, callback) {
                      return Container(
                        width: MediaQuery.of(context).size.width - 95,
                        child: Slider(
                          value: this.processValAgent,
                          max: 500,
                          min: 0,
                          label: ((this.processValAgent.floor() / 500) * (int.parse(playControllerState.audioPlayer.duration.toString().substring(2, 4)) * 60 +
                            int.parse(playControllerState.audioPlayer.duration.toString().substring(5, 7))) / 60).floor().toString() + '：' +
                            ((this.processValAgent.floor() / 500) * (int.parse(playControllerState.audioPlayer.duration.toString().substring(2, 4)) * 60 +
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
                              this.processValAgent = val; 
                            });
                          },
                          onChangeEnd: (double val) async{
                            this.processValAgentLock = true;
                            this.processTouching = false;
                            int _songSecond = int.parse(playControllerState.audioPlayer.duration.toString().substring(2, 4)) * 60 +
                            int.parse(playControllerState.audioPlayer.duration.toString().substring(5, 7));
                            actionMap['type'] = Actions.playSeek;
                            actionMap['payLoad'] = _songSecond * this.processValAgent.floor() / 500;
                            callback();
                            await new Future.delayed(const Duration(milliseconds: 500));
                            this.processValAgentLock = false;
                            setState(() {
                              this.timer = Timer.periodic(const Duration(microseconds: 100), (Void) {
                                setState(() {
                                  this.refreshView = !this.refreshView; 
                                });
                              });
                            });
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
            ],
          )
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
            Container( 
              width: 40,
              height: 40,
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
                return () => store.dispatch(songListAction);
              },
              builder: (BuildContext context, callback) {
                if (this.isRequesting == true) {
                  return null;
                }
                this.isRequesting = true;
                return InkWell(
                  onTap: () async {
                    dynamic songDetail;
                    dynamic _songListAction = new Map();
                    var _songListActionPayLoad = new Map();
                    if (state.playControllerState.songList.length == state.playControllerState.songIndex + 1) {
                      songDetail = await getSongDetail(int.parse(state.playControllerState.songList[0]));
                      dynamic songLyr = await fetchData('${localBaseUrl}lyric?id=${state.playControllerState.songList[state.playControllerState.songIndex + 1]}');
                      songDetail['songLyr'] = songLyr;
                      _songListActionPayLoad['songIndex'] = 0;
                      _songListActionPayLoad['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + state.playControllerState.songList[0] + '.mp3';
                    } else {
                      songDetail = await getSongDetail(int.parse(state.playControllerState.songList[state.playControllerState.songIndex + 1]));
                      dynamic songLyr = await fetchData('${localBaseUrl}lyric?id=${state.playControllerState.songList[state.playControllerState.songIndex + 1]}');
                      print(state.playControllerState.songIndex);
                      songDetail['songLyr'] = songLyr;
                      _songListActionPayLoad['songIndex'] = state.playControllerState.songIndex + 1;
                      _songListActionPayLoad['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + state.playControllerState.songList[state.playControllerState.songIndex + 1] + '.mp3';
                    }
                    _songListActionPayLoad['songDetail'] = songDetail;
                    _songListAction['payLoad'] = _songListActionPayLoad;
                    _songListAction['type'] = Actions.nextSong;
                    this.songListAction =_songListAction;
                    this.isRequesting = false;
                    callback();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/images/play_next.png',
                    )
                  )   
                );
              }
            )
          ],
        )
      );
  }
}