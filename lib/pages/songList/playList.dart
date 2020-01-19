import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';

import './../../redux/index.dart';
import './../../redux/playController/action.dart' as playControllerActions;
import './../../redux/commonController/action.dart';

import './../../components/customBottomNavigationBar.dart';
import './../../components/NavigatorBackBar.dart';

import './../../utils/commonFetch.dart';
import './../../utils/api.dart';

class PlayList extends StatefulWidget {
  final int id;
  PlayList(this.id):super();

  @override
  PlayListState createState() => new PlayListState(id);
}

class PlayListState extends State<PlayList> {
  final int id;
  List<int> backgroundImageMainColor;
  Map playListData;

  PlayListState(this.id);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchOlayList(id);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void switchIsRequesting() {
    StoreProvider.of<AppState>(context).dispatch(switchIsRequestingAction);
  }

  void fetchOlayList(id) async {
    switchIsRequesting();
    var _playListData = await getData('playlistDetail', {
      'id': id.toString()
    });
    switchIsRequesting();
    await getColorFromUrl(_playListData['playlist']['coverImgUrl']).then((palette) {
    backgroundImageMainColor = palette;
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
          body: 
            playListData ==null
            ?
            Container(
              child: Center(
                child:  SpinKitDoubleBounce(
                  color: Colors.red[300],
                )
              ),
            )
            :
            Material(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    PlayListCard(
                      playListData == null ? null : playListData['coverImgUrl'],
                      playListData == null ? null : playListData['name'],
                      playListData == null ? null : playListData['creator']['nickname'],
                      playListData == null ? null : playListData['tags'],
                      playListData == null ? null : playListData['description'],
                      backgroundImageMainColor
                    ),
                    PlayListSongs(playListData, state.playControllerState.currentIndex, switchIsRequesting)
                  ],
                ),
              )
            ),
            bottomNavigationBar: CustomBottomNavigationBar()
          );
      }
    );
  }
}

class PlayListCard extends StatelessWidget {
  final String backgroundImageUrl;
  final String title;
  final String creatorName;
  final List<dynamic> tags;
  final String description;
  List<int> backgroundImageMainColor;
  final double blurHeight = 300;

  PlayListCard(this.backgroundImageUrl, this.title, this.creatorName, this.tags, this.description, this.backgroundImageMainColor);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: blurHeight,
            color: Color.fromRGBO(backgroundImageMainColor[0], backgroundImageMainColor[1],
            backgroundImageMainColor[2], 1)
          ),
          Container(
            margin: EdgeInsets.only(top: 35),
            child: NavigatorBackBar(() {
              Navigator.pop(context);
            }, Colors.white),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 80, 40, 0),
            child: Column(
              children: <Widget>[
                PlayListCardInfo(
                  this.backgroundImageUrl,
                  this.title,
                  this.creatorName,
                  this.tags,
                  this.description
                ),
                // PlayListCardButtons()
              ],
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 15,
            margin: EdgeInsets.only(top: blurHeight - 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)
              ),
              border: Border.all(
                color: Colors.white
              ),
              color: Colors.white
            ),
          )
        ],
      )
    );
  }
}

class PlayListCardInfo extends StatelessWidget {
  final String backgroundImageUrl;
  final String title;
  final String creatorName;
  final List<dynamic> tags;
  final String description;

  PlayListCardInfo(this.backgroundImageUrl, this.title, this.creatorName, this.tags, this.description);

  String composeTags(List<dynamic> list) {
    String _str = '';
    if (list.length == 0) {
      return '';
    }
    for(int i = 0;i < list.length;i ++) {
      _str = _str + list[i] + ' ';
    }
    return _str;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
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
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        this.creatorName,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.white,
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
                          color: Colors.white,
                          fontSize: 12
                        ),
                      )
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width - 60,
            constraints: BoxConstraints(
              minHeight: 50
            ),
            margin: EdgeInsets.only(top: 20),
            child: Text(
              description??'',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11
              ),
            ),
          ),
        ],
      )
    );
  }
}

class PlayListSongs extends StatefulWidget {
  final dynamic playListData;
  final int currentIndex;
  final Function switchIsRequesting;

  PlayListSongs(this.playListData, this.currentIndex, this.switchIsRequesting);
  PlayListSongsState createState () => PlayListSongsState(playListData, currentIndex, switchIsRequesting);
}

class PlayListSongsState extends State<PlayListSongs> {
  int currentIndex;
  bool isRequesting = false;
  dynamic playListData;
  dynamic playList = [];
  dynamic playListAction;
  Function switchIsRequesting;

  @override
  void initState() {
    this.playList = [];
    super.initState();
  }

  @override
  PlayListSongsState(this.playListData, this.currentIndex, this.switchIsRequesting);

  @override
  Widget build(BuildContext context) {
    return playListData == null
    ?
    Container()
    :
    Container(
      color: Colors.white,
      child: StoreConnector<AppState, dynamic>(
        converter: (store) => store.state,
        builder: (BuildContext context, state) {
          return MediaQuery.removeViewPadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              physics: new NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: playListData['tracks'].length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: StoreConnector<AppState, VoidCallback>(
                    converter: (store) {
                      return () => store.dispatch(playControllerActions.addPlayList(playListAction));
                    },
                    builder: (BuildContext context, callback) {
                      return Material(
                        color: Colors.white,
                        child: Ink(
                          child: InkWell(
                            onTap: () async {
                              playListAction = {};
                              if (this.isRequesting == true) {
                                return null;
                              }
                              this.isRequesting = true;
                              switchIsRequesting();
                              dynamic songDetail = await getSongDetail(playListData['tracks'][index]['id']);
                              dynamic songLyr = await getData('lyric', {
                                'id': playListData['tracks'][index]['id'].toString()
                              });
                              switchIsRequesting();
                              Map _playListActionPayload = {};
                              List<String> _playList = [];
                              songDetail['songLyr'] = songLyr;
                              for(int j = 0;j < playListData['tracks'].length;j ++) {
                                _playList.add(playListData['tracks'][j]['id'].toString());
                              }
                              _playListActionPayload['songList'] = _playList;
                              _playListActionPayload['songIndex'] = index;
                              _playListActionPayload['songDetail'] = songDetail;
                              _playListActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + playListData['tracks'][index]['id'].toString() + '.mp3';
                              playListAction['payload'] = _playListActionPayload;
                              playListAction['type'] = playControllerActions.Actions.addPlayList;
                              this.isRequesting = false;
                              callback();
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  state.playControllerState.playList.length > 0 && state.playControllerState.playList[state.playControllerState.currentIndex] != null && state.playControllerState.playList[state.playControllerState.currentIndex]['id'] == playListData['tracks'][index]['id']
                                  ?
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    width: 20,
                                    child: Image.asset('assets/images/playingAudio.png')
                                  )
                                  :
                                  Container(
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
                                    width: MediaQuery.of(context).size.width - 120,
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
                                          margin: EdgeInsets.only(top: 5),
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
                              )
                            )
                          )
                        )
                      );
                    }
                  ) 
                );
              },
            )
          );
        }
      )
    );
  }
}