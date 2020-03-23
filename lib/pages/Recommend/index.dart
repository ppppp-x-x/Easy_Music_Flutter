import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import './../../redux/commonController/action.dart';
import './../../redux/index.dart';

import './../../utils//api.dart';

import './../../components/HomeBanner.dart';
import '../../components/RecommedSongs.dart';
import '../../components/commonText.dart';

import './recommendListRow.dart';
import './recommandAlbum.dart';

class Recommend extends StatefulWidget {
  @override
  RecommendState createState() => new RecommendState();
}

class RecommendState extends State<Recommend> with AutomaticKeepAliveClientMixin {
  List<dynamic> bannerList;
  List<dynamic> hotSongList;
  List<dynamic> recommendSongList;
  List<dynamic> newSongs;
  dynamic newAlbums;
  bool newSongsRequestOver = false;
  // var recommendVideos;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchBannner();
      fetchHotSongList();
      fetchRecommedSongList();
      fetchNewSongs();
      fetchNewAlbum();
    });
  }

  void switchIsRequesting() {
    StoreProvider.of<AppState>(context).dispatch(switchIsRequestingAction);
  }

  fetchBannner() async {
    switchIsRequesting();
    var _bannerList = await getData('banner', {});
    switchIsRequesting();
    if (_bannerList == '请求错误') {
      return;
    }
    if(this.mounted) {
      setState(() {
        bannerList = _bannerList['banners']; 
      });
    }
  }

  fetchHotSongList() async {
    switchIsRequesting();
    var _hotSongList = await getData('hotPlaylist', {
      'limit': '10',
      'order': 'hot'
    });
    switchIsRequesting();
    if (_hotSongList == '请求错误') {
      return;
    }
    if(this.mounted) {
      setState(() {
        this.hotSongList = _hotSongList['playlists']; 
      });
    }
  }

  fetchRecommedSongList() async {
    switchIsRequesting();
    var _recommendSongList = await getData('recommendList', {});
    switchIsRequesting();
    if (_recommendSongList == '请求错误') {
      return;
    }
    if(this.mounted) {
      setState(() {
        this.recommendSongList = _recommendSongList['result']; 
      });
    }
  }

  fetchNewSongs() async {
    switchIsRequesting();
    var _newSongs = await getData('newSongs', {});
    switchIsRequesting();
    if (_newSongs == '请求错误') {
      return;
    }
    if(this.mounted) {
      setState(() {
        newSongs = _newSongs['result']; 
      });
    }
    for (int i = 0;i < 9;i ++) {
      fetchNewSongHotComments(_newSongs['result'], _newSongs['result'][i]['id'], i);
    }
  }

  fetchNewAlbum() async {
    switchIsRequesting();
    var _newAlbums = await getData('newAlbums', {});
    switchIsRequesting();
    if (_newAlbums == '请求错误') {
      return;
    }
    if(this.mounted) {
      setState(() {
        newAlbums = _newAlbums['albums'].take(5).toList();
      });
    }
  }

  fetchNewSongHotComments(newSongs, int id, int index) async {
    Map<String, String> params = {};
    params['id'] = id.toString();
    params['type'] = '0';
    switchIsRequesting();
    var _hotComment = await getData('hotComments', params);
    switchIsRequesting();
    if (_hotComment == '请求错误') {
      return;
    }
    if (_hotComment['hotComments'].length > 0) {
      newSongs[index]['hotComment'] = _hotComment['hotComments'][0]['content'];
    } else {
      newSongs[index]['hotComment'] = '';
    }
    setState(() {
      newSongs = newSongs;
    });
    if (index == 8) {
      splitNewSongs();
    }
  }

  splitNewSongs() {
    List _newSongs = [[]];
    for (int i = 0;i < 9;i ++) {
      if (_newSongs[_newSongs.length - 1] == null) {
        _newSongs[_newSongs.length - 1] = [];
      } else if (_newSongs[_newSongs.length - 1].length == 3) {
        _newSongs.add([]);
      }
      _newSongs[_newSongs.length - 1].add(newSongs[i]);
    }
    if(this.mounted) {
      setState(() {
        newSongs = _newSongs;
        newSongsRequestOver = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HomeBanner(bannerList),
          // Menu(),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                newSongsRequestOver
                ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                        child: CommonText(
                          '最新流行单曲',
                          13,
                          1,
                          Colors.black,
                          FontWeight.bold,
                          TextAlign.start
                        ),
                      ),
                      RecommedSongs(newSongs, '最新流行歌曲')
                    ],
                  )
                :
                  Container(),
                RecommandAlbum(newAlbums, '最热专辑', '最新热门专辑'),
                RecommendList(hotSongList, '最热歌单', '最新流行歌单'),
                RecommendList(recommendSongList, '推荐歌单', '为您精挑细选'),
              ],
            ),
          )
        ],
      )
    );
  }
}

class Menu extends StatelessWidget {
  Widget createMenu (String title, String iconUrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.black87,
            boxShadow: <BoxShadow> [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 3)
              )
            ]
          ),
          child: Image.asset(
            iconUrl,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87
            ),
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 18),
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          createMenu('歌单', 'assets/images/playList.png'),
          createMenu('私人FM', 'assets/images/musicBox.png'),
          createMenu('每日推荐', 'assets/images/date.png'),
          createMenu('排行榜', 'assets/images/rank.png')
        ],
      )
    );
  }
}