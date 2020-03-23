import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../redux/index.dart';
import '../redux/playController/action.dart' as playControllerActions;
import '../redux/commonController/action.dart';

import '../components/commonText.dart';

import '../utils/commonFetch.dart';
import '../utils//api.dart';

class RecommedSongs extends StatelessWidget {
  final songs;
  final String title;
  RecommedSongs(this.songs, this.title);
  
  @override
  Widget build(BuildContext context) {
    return songs == null
    ?
    Container(
      width: MediaQuery.of(context).size.width,
      height: 160,
      color: Colors.grey,
    )
    :
    Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return RecommemdSongsColumn(songs[index]);
        },
        itemCount: songs.length,
        control: SwiperControl(
          iconNext: null,
          iconPrevious: null
        ),
        loop: false
      )
    );
  }
}

class RecommemdSongsColumn extends StatelessWidget {
  final songsColumn;
  final Map playListAction = {};

  RecommemdSongsColumn(this.songsColumn);

  String composeArtistNames (List artists) {
    String name = '';
    if (artists.length > 0) {
      for (int i = 0;i < artists.length;i ++) {
        name += artists[i]['name'] + '/';
      }
      return name.substring(0, name.length - 1);
    } else {
      return name;
    }
  }

  void switchIsRequesting(context) {
    StoreProvider.of<AppState>(context).dispatch(switchIsRequestingAction);
  }

  List<Widget> createRecommendSongsColumn (context) {
    List<Widget> recommendSongsColumn = [];
    for (int i = 0;i < songsColumn.length;i ++) {
      Map song = songsColumn[i];
      Container recommendSongsSingle = Container(
        margin: EdgeInsets.fromLTRB(20, 3, 20, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: song['picUrl'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: CommonText(
                                  song['name'],
                                  13,
                                  1,
                                  Colors.black87,
                                  FontWeight.bold,
                                  TextAlign.start
                                )
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: CommonText(
                                  composeArtistNames(song['song']['artists']),
                                  11,
                                  1,
                                  Colors.black54,
                                  FontWeight.normal,
                                  TextAlign.start
                                )
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: CommonText(
                              song['hotComment'], 
                              11,
                              1,
                              Colors.black54,
                              FontWeight.normal,
                              TextAlign.start
                              ),
                          )
                        ],
                      ),
                    )
                  )
                ],
              ),
            ),
            StoreConnector<AppState, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(playControllerActions.addPlayList(playListAction));
              },
              builder: (BuildContext context, callback) {
                return IconButton(
                  onPressed: () async {
                    switchIsRequesting(context);
                    dynamic songDetail = await getSongDetail(song['id']);
                    dynamic songLyr = await getData('lyric', {
                      'id': song['id'].toString()
                    });
                    switchIsRequesting(context);
                    Map _playListActionPayload = {};
                    List<String> _playList = [];
                    songDetail['songLyr'] = songLyr;
                    _playList.add(song['id'].toString());
                    _playListActionPayload['songList'] = _playList;
                    _playListActionPayload['songIndex'] = 0;
                    _playListActionPayload['songDetail'] = songDetail;
                    _playListActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + song['id'].toString() + '.mp3';
                    playListAction['payload'] = _playListActionPayload;
                    playListAction['type'] = playControllerActions.Actions.addPlayList;
                    callback();
                  },
                  icon: Icon(
                    Icons.play_arrow,
                    size: 20,
                  ),
                );
              }
            )
          ],
        ),
      );
      recommendSongsColumn.add(recommendSongsSingle);
    }
    return recommendSongsColumn;
  }

  Widget build(BuildContext context) {
    return Column(
      children: createRecommendSongsColumn(context)
    );
  }
}