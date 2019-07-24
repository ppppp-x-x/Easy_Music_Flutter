import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui' as ui;

import './../../redux/index.dart';
import './../../redux/playController/action.dart';

import './../../components/customBottomNavigationBar.dart';

import './../../utils/commonFetch.dart';
import './../../utils//api.dart';

class PlayList extends StatefulWidget {
  final int id;
  final String heroTag;
  PlayList(this.id, this.heroTag):super();

  @override
  PlayListState createState() => new PlayListState(id, heroTag);
}

class PlayListState extends State<PlayList> {
  final int id;
  String heroTag;
  var playListData;

  PlayListState(this.id, this.heroTag);
  @override
  void initState() {
    super.initState();
    fetchOlayList(id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchOlayList(id) async {
    var _playListData = await getData('playlistDetail', {
      'id': id.toString()
    });
    if (_playListData == '请求错误') {
      return;
    }
    if(this.mounted && _playListData != null) {
      setState(() {
        playListData = _playListData['playlist'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        return Scaffold(
          body: Hero(
            tag: heroTag,
            child: playListData ==null
            ?
            Container(
              child: Center(
                child:  SpinKitCubeGrid(
                  color: Colors.red,
                )
              ),
            )
            :
            Material(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    PlayListCardTop(
                      playListData == null ? null : playListData['coverImgUrl'],
                      playListData == null ? null : playListData['name'],
                      playListData == null ? null : playListData['creator']['nickname'],
                      playListData == null ? null : playListData['tags'],
                      playListData == null ? null : playListData['description'] 
                    ),
                    PlayListCardBottom(playListData, state.playControllerState.currentIndex)
                  ],
                ),
              )
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar()
        );
      }
    );
  }
}

class PlayListCardBottom extends StatefulWidget {
  dynamic playListData;
  int currentIndex;
  PlayListCardBottom(this.playListData, this.currentIndex);

  @override
  PlayListCardBottomState createState () => PlayListCardBottomState(playListData, currentIndex);
}

class PlayListCardBottomState extends State<PlayListCardBottom> {
  int currentIndex;
  bool isRequesting = false;
  dynamic playListData;
  dynamic playList = [];
  dynamic playListAction;

  @override
  void initState() {
    this.playList = [];
    super.initState();
  }

  @override
  PlayListCardBottomState(this.playListData, this.currentIndex);

  @override
  Widget build(BuildContext context) {
    return playListData == null
    ?
    Container(
      width: 0,
      height: 0,
    )
    :
    Container(
      color: Colors.white,
      child: Container(
        child: StoreConnector<AppState, dynamic>(
          converter: (store) => store.state,
          builder: (BuildContext context, state) {
            return ListView.builder(
              physics: new NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: playListData['tracks'].length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: StoreConnector<AppState, VoidCallback>(
                    converter: (store) {
                      return () => store.dispatch(playListAction);
                    },
                    builder: (BuildContext context, callback) {
                      return InkWell(
                        onTap: () async {
                          if (this.isRequesting == true) {
                            return null;
                          }
                          this.isRequesting = true;
                          dynamic songDetail = await getSongDetail(playListData['tracks'][index]['id']);
                          dynamic songLyr = await getData('lyric', {
                            'id': playListData['tracks'][index]['id']
                          });
                          songDetail['songLyr'] = songLyr;
                          playListAction = new Map();
                          var _playListActionPayLoad = new Map();
                          dynamic _playList = [];
                          for(int j = 0;j < playListData['tracks'].length;j ++) {
                            _playList.add(playListData['tracks'][j]['id'].toString());
                          }
                          _playListActionPayLoad['songList'] = _playList;
                          _playListActionPayLoad['songIndex'] = index;
                          _playListActionPayLoad['songDetail'] = songDetail;
                          _playListActionPayLoad['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + playListData['tracks'][index]['id'].toString() + '.mp3';
                          playListAction['payLoad'] = _playListActionPayLoad;
                          playListAction['type'] = Actions.addPlayList;
                          this.isRequesting = false;
                          callback();
                        },
                        child:
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  state.playControllerState.playList.length > 0 && state.playControllerState.playList[state.playControllerState.currentIndex] != null && state.playControllerState.playList[state.playControllerState.currentIndex]['id'] == playListData['tracks'][index]['id']
                                  ?
                                  Container(
                                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    width: 15,
                                    child: Image.asset('assets/images/playingAudio.png')
                                  )
                                  :
                                  Container(
                                    margin: EdgeInsets.only(left: 15),
                                    width: 30,
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 110,
                                    margin: EdgeInsets.only(left: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            playListData['tracks'][index]['name'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            playListData['tracks'][index]['ar'][0]['name'],
                                            maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54
                                          ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 20,
                                    child: Image.asset(
                                      'assets/images/more_playList.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  )
                                ],
                              ),
                              Divider()
                            ],
                          )
                      );
                    }
                  ) 
                );
              },
            );
          }
        )
      )
    );
  }
}

class PlayListCardTop extends StatelessWidget {
  final String backgroundImageUrl;
  final String title;
  final String creatorName;
  final List<dynamic> tags;
  final String description;

  PlayListCardTop(this.backgroundImageUrl, this.title, this.creatorName, this.tags, this.description);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: backgroundImageUrl,
          width: MediaQuery.of(context).size.width,
          height: 230,
          fit: BoxFit.fitWidth,
          placeholder: (context, url) => Container(
            width: MediaQuery.of(context).size.width,
            height: 230,
            color: Colors.grey,
          ),
        ),
        BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
          child: Container(
            color: Colors.white.withOpacity(0.3),
            width: MediaQuery.of(context).size.width,
            height: 230,
          )
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.black26,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(40, 50, 40, 0),
          child: Column(
            children: <Widget>[
              PlayListCardTopInfo(
                this.backgroundImageUrl,
                this.title,
                this.creatorName,
                this.tags
              ),
              Container(
                width: MediaQuery.of(context).size.width - 60,
                height: 55,
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  this.description,
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11
                  ),
                ),
              ),  
              // Container(
              //   margin: EdgeInsets.only(top: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Column(
              //         children: <Widget>[
              //           Icon(
              //             Icons.star,
              //             color: Colors.black38,
              //           ),
              //           Text(
              //             '收藏',
              //             style: TextStyle(
              //               color: Colors.black38,
              //               fontSize: 13
              //             ),
              //           )
              //         ],
              //       ),
              //       Column(
              //         children: <Widget>[
              //           Icon(
              //             Icons.cloud_download,
              //             color: Colors.black38,
              //           ),
              //           Text(
              //             '下载',
              //             style: TextStyle(
              //               color: Colors.black38,
              //               fontSize: 13
              //             ),
              //           )
              //         ],
              //       ),
              //       Column(
              //         children: <Widget>[
              //           Icon(
              //             Icons.comment,
              //             color: Colors.black38,
              //           ),
              //           Text(
              //             '评论',
              //             style: TextStyle(
              //               color: Colors.black38,
              //               fontSize: 13
              //             ),
              //           )
              //         ],
              //       ),
              //     ],
              //   )
              // )
            ],
          )
        )
      ],
    );
  }
}

class PlayListCardTopInfo extends StatelessWidget {
  final String backgroundImageUrl;
  final String title;
  final String creatorName;
  final List<dynamic> tags;

  PlayListCardTopInfo(this.backgroundImageUrl, this.title, this.creatorName, this.tags);

  String composeTags(List<dynamic> list) {
    String _str = '';
    if (list.length == 0) {
      return '';
    }
    for(int i = 0;i < list.length;i ++) {
      _str = _str + '#' + list[i] + '#  ';
    }
    return _str;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              imageUrl: this.backgroundImageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.fitWidth,
              placeholder: (context, url) => Container(
                width: 100,
                height: 100,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 200,
            margin: EdgeInsets.only(left: 15),
            padding: EdgeInsets.only(top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.title,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    fontSize: 15
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    this.creatorName,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    composeTags(this.tags),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 12
                    ),
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}