import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';

import './../../redux/index.dart';
import './../../redux/playController/action.dart' as playControllerActions;
import './../../redux/commonController/action.dart';

import './../../components/customBottomNavigationBar.dart';
import '../../components/commonText.dart';

import './../../utils/commonFetch.dart';
import './../../utils/api.dart';

class AlbumDetail extends StatefulWidget {
  final int id;
  AlbumDetail(this.id):super();

  @override
  AlbumDetailState createState() => new AlbumDetailState(id);
}

class AlbumDetailState extends State<AlbumDetail> {
  final int id;
  Color backgroundImageMainColor;
  List albumSongs;
  Map albumInfo;
  int currentIndex;
  bool isRequesting = false;
  dynamic playList = [];
  dynamic albumDetailAction;

  AlbumDetailState(this.id);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchAlbumDetail(id);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void switchIsRequesting() {
    StoreProvider.of<AppState>(context).dispatch(switchIsRequestingAction);
  }

  void fetchAlbumDetail(id) async {
    switchIsRequesting();
    var _albumDetail = await getData('albumDetail', {
      'id': id.toString()
    });
    switchIsRequesting();
    await getColorFromUrl(_albumDetail['album']['blurPicUrl']).then((palette) {
      backgroundImageMainColor = Color.fromRGBO(palette[0], palette[1], palette[2], 1);
    });
    if (_albumDetail == '请求错误') {
      return;
    }
    if(this.mounted && _albumDetail != null) {
      setState(() {
        albumSongs = _albumDetail['songs'];
        albumInfo = _albumDetail['album'];
      });
    }
  }

  List<Widget> createAlbumSongs (state) {
    List<Widget> _albumSongs = [];
    for (int index = 0;index < albumSongs.length; index++) {
      _albumSongs.add(Container(
        child: StoreConnector<AppState, VoidCallback>(
          converter: (store) {
            return () => store.dispatch(playControllerActions.addPlayList(albumDetailAction));
          },
          builder: (BuildContext context, callback) {
            return Material(
              color: Colors.white,
              child: Ink(
                child: InkWell(
                  onTap: () async {
                    albumDetailAction = {};
                    if (this.isRequesting == true) {
                      return null;
                    }
                    this.isRequesting = true;
                    switchIsRequesting();
                    dynamic songDetail = await getSongDetail(albumSongs[index]['id']);
                    dynamic songLyr = await getData('lyric', {
                      'id': albumSongs[index]['id'].toString()
                    });
                    switchIsRequesting();
                    Map _albumDetailActionPayload = {};
                    List<String> _albumSongs = [];
                    songDetail['songLyr'] = songLyr;
                    for(int j = 0;j < albumSongs.length;j ++) {
                      _albumSongs.add(albumSongs[j]['id'].toString());
                    }
                    _albumDetailActionPayload['songList'] = _albumSongs;
                    _albumDetailActionPayload['songIndex'] = index;
                    _albumDetailActionPayload['songDetail'] = songDetail;
                    _albumDetailActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + albumSongs[index]['id'].toString() + '.mp3';
                    albumDetailAction['payload'] = _albumDetailActionPayload;
                    albumDetailAction['type'] = playControllerActions.Actions.addPlayList;
                    this.isRequesting = false;
                    callback();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        state.playControllerState.playList.length > 0 && state.playControllerState.playList[state.playControllerState.currentIndex] != null && state.playControllerState.playList[state.playControllerState.currentIndex]['id'] == albumSongs[index]['id']
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
                                  albumSongs[index]['name'],
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
                                  albumSongs[index]['ar'][0]['name'],
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
      ));
    }
    return _albumSongs;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        return Scaffold(
          body: 
            albumSongs ==null
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
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 270,
                      flexibleSpace: FlexibleSpaceBar(
                        background: AlbumDetailCard(
                        albumInfo == null ? null : albumInfo['blurPicUrl'],
                        albumInfo == null ? null : albumInfo['name'],
                        albumInfo == null ? null : albumInfo['artists'][0]['name'],
                        albumInfo == null ? null : albumInfo['description'],
                        backgroundImageMainColor
                      ),
                    ),
                    pinned: true,
                    backgroundColor: backgroundImageMainColor,
                  ),
                  SliverFixedExtentList(
                    itemExtent: 65,
                    delegate: SliverChildListDelegate(
                      createAlbumSongs(state)
                    ),
                  )
                ],
              )
            ),
            bottomNavigationBar: CustomBottomNavigationBar()
          );
      }
    );
  }
}

class AlbumDetailCard extends StatelessWidget {
  final String backgroundImageUrl;
  final String title;
  final String creatorName;
  final String description;
  final Color backgroundImageMainColor;
  final double blurHeight = 300;

  AlbumDetailCard(this.backgroundImageUrl, this.title, this.creatorName, this.description, this.backgroundImageMainColor);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: blurHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                backgroundImageMainColor,
                Colors.white
              ]
            )
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(40, 80, 40, 0),
          child: Column(
            children: <Widget>[
              AlbumDetailCardInfo(
                this.backgroundImageUrl,
                this.title,
                this.creatorName,
                this.description,
                this.backgroundImageMainColor
              ),
              // PlayListCardButtons()
            ],
          )
        )
      ],
    );
  }
}

class AlbumDetailCardInfo extends StatelessWidget {
  final String backgroundImageUrl;
  final String title;
  final String creatorName;
  final String description;
  final Color backgroundImageMainColor;

  AlbumDetailCardInfo(this.backgroundImageUrl, this.title, this.creatorName, this.description, this.backgroundImageMainColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
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
                decoration: BoxDecoration(
                boxShadow: <BoxShadow> [
                  BoxShadow(
                    color: backgroundImageMainColor,
                    blurRadius: MediaQuery.of(context).size.width * 0.3,
                    spreadRadius: 10,
                    offset: Offset(0, 0)
                  )
                ]
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CommonText(
                  this.title,
                  14,
                  2,
                  Colors.black87,
                  FontWeight.bold,
                  TextAlign.start
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: CommonText(
                    this.creatorName,
                    12,
                    1,
                    Colors.black87,
                    FontWeight.normal,
                    TextAlign.start
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(
              minHeight: 50
            ),
            margin: EdgeInsets.only(top: 10),
            child: CommonText(
              description??'',
              11,
              2,
              Colors.black87,
              FontWeight.normal,
              TextAlign.center
            ),
          ),
        ],
      )
    );
  }
}