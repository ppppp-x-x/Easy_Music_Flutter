import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';

import './../../utils/commonFetch.dart';
import './../../utils//api.dart';

import './../../redux/index.dart';
import './../../redux/playController/action.dart';

import './../../components/customBottomNavigationBar.dart';

class RankList extends StatefulWidget {
  final int rankListId;
  RankList(this.rankListId);

  @override
  RankListState createState () => RankListState(rankListId);
}

class RankListState extends State<RankList> {
  final int rankListId;
  RankListState(this.rankListId);

  Map<String, dynamic> rankDec;
  Map playListAction;
  List<dynamic> rankTracks;

  void initState() {
    super.initState();
    getRankDetail();
  }

  void dispose() {
    super.dispose();
  }

  void getRankDetail () async {
    dynamic _rankDetail = await getData('topDetail', {
      'idx': rankListId.toString()
    });
    setState(() {
      rankTracks = _rankDetail['playlist']['tracks'];
      rankDec = _rankDetail['playlist']['creator'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic> (
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
      return Scaffold(
        body: 
        rankDec == null
        ?
        SpinKitDualRing(
          color: Colors.red,
        )
        :
        Material(
          child:ListView.builder(
            itemCount: rankTracks.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return RankDes(rankDec);
              }
              return  Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      state.playControllerState.songList != null && state.playControllerState.songList.length > 1 && 
                      state.playControllerState.songList[state.playControllerState.songList.length - 1] == rankTracks[index - 1]['id']
                      ?
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(left: 15),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/playingAudio.png',
                          width: 25,
                          height: 25,
                        )
                      )
                      :
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        width: 30,
                        child: Text(
                          (index).toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54
                          ),
                        ),
                      ),
                      Container(
                        child: StoreConnector<AppState, VoidCallback>(
                          converter: (store) {
                            return () => store.dispatch(playListAction);
                          },
                          builder: (BuildContext context, callback) {
                            return InkWell(
                              onTap: () async {
                                dynamic songDetail = await getSongDetail(rankTracks[index - 1]['id']);
                                dynamic songLyr = await getData('lyric', {
                                  'id': rankTracks[index - 1]['id'].toString()
                                });
                                songDetail['songLyr'] = songLyr;
                                playListAction = new Map();
                                var _playListActionPayLoad = new Map();
                                dynamic _playList = [];
                                for(int j = 0;j < rankTracks.length;j ++) {
                                  _playList.add(rankTracks[j]['id'].toString());
                                }
                                _playListActionPayLoad['songList'] = _playList;
                                _playListActionPayLoad['songIndex'] = index;
                                _playListActionPayLoad['songDetail'] = songDetail;
                                _playListActionPayLoad['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + rankTracks[index - 1]['id'].toString() + '.mp3';
                                playListAction['payLoad'] = _playListActionPayLoad;
                                playListAction['type'] = Actions.addPlayList;
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
                                        rankTracks[index - 1]['name'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        rankTracks[index - 1]['al']['name'] + '——' + rankTracks[index - 1]['ar'][0]['name'],
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
                            );
                          }
                        ) 
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
              );
            },
          )
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ); 
      },
    );
  }
}

class RankDes extends StatelessWidget {
  Map<String, dynamic> rankDec;
  RankDes(rankDec);

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: rankDec['avatarUrl'],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.6,
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.6,
              color: Colors.grey,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.6 - 70),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            color: Colors.black54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  rankDec['nickname'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  rankDec['signature'] == null
                  ?
                  ''
                  :
                  rankDec['signature'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                )
              ],
            ),
          )
        ],
      )
    );
  }
}