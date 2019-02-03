import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';

import './../../utils/request.dart';
import './../../redux/index.dart';
import './../../components/customBottomNavigationBar.dart';

import './../../redux/playList/action.dart' as playListActions;
import './../../redux/audioController/action.dart' as audioControllerActions;

class PlayList extends StatefulWidget {
  var store;
  final int id;
  PlayList({this.id, this.store}):super();

  @override
  PlayListState createState() => new PlayListState(id, store);
}

class PlayListState extends State<PlayList> {
  final int id;
  var store;
  var playListData;

  PlayListState(this.id, this.store);
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
    var _playListData = await fetchData('http://xinpeng.natapp1.cc/playlist/detail?id=' + id.toString());
    if(this.mounted) {
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
          body: Material(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  PlayListCardTop(
                  playListData == null ? null : playListData['coverImgUrl'],
                  playListData == null ? null : playListData['name']
                  ),
                  PlayListCardMid(playListData),
                  Divider(),
                  PlayListCardBottom(playListData, state.playListModelState.currentIndex)
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

class PlayListCardBottom extends StatelessWidget {
  final dynamic playListData;
  int currentIndex;
  PlayListCardBottom(this.playListData, this.currentIndex);
  
  List<Widget> createPlayListContent(data, context) {
    List<Widget> _playListContent = [];
    for(int i = 0 ;i < data.length;i ++) {
      _playListContent.add(
        Container(
          height: 45,
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 30,
                    child: Text(
                      (i + 1).toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54
                      ),
                    ),
                  ),
                  Container(
                    child: StoreConnector<AppState, VoidCallback>(
                      converter: (store) {
                        var _playListItem = new Map();
                        var _playListAction = new Map();
                        _playListItem['name'] = data[i]['name'];
                        _playListItem['singer'] = data[i]['ar'][0]['name'];
                        _playListItem['albumName'] = data[i]['al']['name'];
                        _playListItem['albumBg'] = data[i]['al']['picUrl'];
                        _playListItem['id'] = data[i]['id'];
                        _playListAction['payLoad'] = _playListItem;
                        _playListAction['type'] = playListActions.Actions.addPlayList;

                        var _audioControllerAction = new Map();
                        _audioControllerAction['payLoad'] = 'http://music.163.com/song/media/outer/url?id=' + data[i]['id'].toString() + '.mp3';
                        _audioControllerAction['type'] = audioControllerActions.Actions.changeSong;
                        dynamic _actions() {
                          store.dispatch(_audioControllerAction);
                          store.dispatch(_playListAction);
                        }
                        return () => _actions();
                      },
                      builder: (BuildContext context, callback) {
                        return GestureDetector(
                          onTap: () {
                            callback();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 100,
                            margin: EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    data[i]['name'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    data[i]['ar'][0]['name'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54
                                  ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    ) 
                  ),
                ],
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
      );
      _playListContent.add(
        Divider()
      );
    }
    return _playListContent;
  }

  @override
  Widget build(BuildContext context) {
    return playListData == null
    ?
    Container()
    :
    Column(
      children: createPlayListContent(playListData['tracks'], context),
    );
  }
}

class PlayListCardMid extends StatelessWidget {
  final dynamic playListData;
  PlayListCardMid(this.playListData);

  String computeCount(int count) {
    return (count / 10000).toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return playListData == null
    ?
    Container()
    :
    Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50)
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    playListData['creator']['avatarUrl'],
                  ),
                )
              ),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      playListData['creator']['nickname']
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          computeCount(playListData['playCount']) + '万次播放',
                          style: TextStyle(
                            color: Colors.black54
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            playListData['trackCount'].toString() + '首歌',
                            style: TextStyle(
                              color: Colors.black54
                            ),
                          )
                        )
                      ],
                    )
                  ],
                )
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 16, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/like_playList.png',
                    width: 18,
                    height: 18,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      playListData['subscribedCount'].toString(),
                      style: TextStyle(
                        color: Colors.black54
                      ),
                    )
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/comment_playList.png',
                    width: 18,
                    height: 18,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      playListData['commentCount'].toString(),
                      style: TextStyle(
                        color: Colors.black54
                      ),
                    )
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/retweet_playList.png',
                    width: 18,
                    height: 18,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      playListData['shareCount'].toString(),
                      style: TextStyle(
                        color: Colors.black54
                      ),
                    )
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/download_playList.png',
                    width: 18,
                    height: 18,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      playListData['subscribedCount'].toString(),
                      style: TextStyle(
                        color: Colors.black54
                      ),
                    )
                  )
                ],
              )
            ],
          )
        )
      ],
    );
  }
}

class PlayListCardTop extends StatelessWidget {
  final String backgroundImageUrl;
  final String title;

  PlayListCardTop(this.backgroundImageUrl, this.title);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width ,
          height: 200,
          child: backgroundImageUrl == null
          ?
          Container()
          :
          CachedNetworkImage(
            imageUrl: backgroundImageUrl,
            width: MediaQuery.of(context).size.width,
            height: 200,
            fit: BoxFit.fitWidth,
            placeholder: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.grey,
            ),
          )
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white70,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                child: Text(
                  title == null ? '' : title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              )
            ],
          )
        )
      ],
    );
  }
}