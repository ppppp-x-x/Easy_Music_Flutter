import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import './../../redux/commonController/action.dart';
import './../../redux/index.dart';

import './../../utils//api.dart';

import './../../components/HomeBanner.dart';

import './recommendListRow.dart';

class Recommend extends StatefulWidget {
  @override
  RecommendState createState() => new RecommendState();
}

class RecommendState extends State<Recommend> with AutomaticKeepAliveClientMixin {
  List<dynamic> bannerList;
  List<dynamic> hotSongList;
  List<dynamic> recommendSongList;
  // var recommendVideos;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchBannner();
      await fetchHotSongList();
      await fetchRecommedSongList();
      // fetchRecommendVideos();
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

  // void fetchRecommendVideos() async {
  //   var _recommendVideos = await fetchData(localBaseUrl + '/personalized/mv');
  //   if (_recommendVideos == '请求错误') {
  //     return;
  //   }
  //   if(this.mounted && this.recommendVideos == null) {
  //     setState(() {
  //       this.recommendVideos =_recommendVideos;
  //     });
  //   }
  // }

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
          Menu(),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                RecommendList(hotSongList, '最热歌单', '最新流行歌单'),
                RecommendList(recommendSongList, '推荐歌单', '为您精挑细选')
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
            color: Colors.red[600],
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