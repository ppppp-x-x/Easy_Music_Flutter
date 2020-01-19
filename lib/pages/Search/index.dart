import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './../../redux/index.dart';

import './../../utils/commonFetch.dart';
import './../../utils//api.dart';

import './../../redux/playController/action.dart' as playControllerActions;
import './../../redux/commonController/action.dart';

import '../../components/CustomBottomNavigationBar.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  bool searched = false;
  bool showSpinner = false;
  bool isRequesting = false;
  String lastSearchStr = '';
  List<dynamic> searchList = [];
  Map<String, dynamic> playListAction;
  dynamic searchHot = [];
  TextEditingController searchController;

  @override
  initState() {
    super.initState();
    searchController = new TextEditingController();
    getSearchHot();
    searched = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void switchIsRequesting() {
    StoreProvider.of<AppState>(context).dispatch(switchIsRequestingAction);
  }

  void submit(String str) {
    lastSearchStr = str;
    getSearchList(str);
  }

  dynamic getSearchHot() async {
    dynamic _searchHot = await getData('hotSearch', {});
    if(this.mounted) {
      setState(() {
        searchHot = _searchHot['data'];  
      });
    }
  }

  dynamic getSearchList(String str) async {
    setState(() {
      showSpinner = true;  
    });
    dynamic _searchList = await getData('search', {
      'keywords': str
    });
    if(this.mounted) {
      setState(() {
        searched = true;
        searchList = _searchList['result']['songs'];
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(
              Icons.arrow_back
            ),
            onPressed: () {
              if (searched) {
                this.setState(() {
                  searched = false;
                  searchList = [];
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: TextField(
            controller: searchController,
            style: TextStyle(
              color: Colors.black
            ),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Colors.black
              ),
              hintText: '歌名/歌手/歌单',
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 16
              ),
              fillColor: Colors.black,
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 4),
            ),
            onSubmitted: submit,
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
              child: IconButton(
                color: Colors.black,
                icon: Icon(
                  Icons.search,                  
                ),
                onPressed: () {
                  submit(lastSearchStr);
                },
              )
            )
          ],
        ),
        body:
        showSpinner
        ?
        Container(
          child:  SpinKitDoubleBounce(
            color: Colors.red,
          )
        )
        :
        searchHot.length > 0 && !searched
        ?
        Container(
          padding: EdgeInsets.only(top: 20),
          color: Colors.white,
          child: ListView.builder(
            itemCount: searchHot.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  this.searchController.text = searchHot[index]['searchWord'];
                  this.submit(this.searchController.text);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Text(
                              index.toString(),
                              style: TextStyle(
                                color: index < 4 ? Colors.red : Colors.black54,
                                fontSize: 16
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    searchHot[index]['searchWord'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                      fontWeight: index < 4 ? FontWeight.bold : FontWeight.normal
                                    ),
                                  ),
                                  searchHot[index]['iconUrl'] != null
                                  ?
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Image.network(
                                        searchHot[index]['iconUrl'],
                                        width: 28,
                                        height: 16,
                                      )
                                    )
                                  :
                                    Container()
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                child: Text(
                                  searchHot[index]['content'],
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Text(
                        searchHot[index]['score'].toString(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12
                        ),
                      )
                    ],
                  ),
                )
              );
            },
          ),
        )
        :
        Container(
          padding: EdgeInsets.only(top: 20),
          color: Colors.white,
          child: ListView.builder(
            itemCount: searchList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: StoreConnector<AppState, VoidCallback>(
                        converter: (store) {
                          return () => store.dispatch(playControllerActions.addPlayList(playListAction));
                        },
                        builder: (BuildContext context, callback) {
                          return InkWell(
                            onTap: () async {
                              playListAction = {};
                              if (isRequesting == true) {
                                return null;
                              }
                              isRequesting = true;
                              switchIsRequesting();
                              dynamic songDetail = await getSongDetail(searchList[index]['id']);
                              dynamic songLyr = await getData('lyric', {
                                'id': searchList[index]['id'].toString()
                              });
                              switchIsRequesting();
                              Map _playListActionPayload = {};
                              List<String> _playList = [];
                              songDetail['songLyr'] = songLyr;
                              for(int j = 0;j < searchList.length;j ++) {
                                _playList.add(searchList[j]['id'].toString());
                              }
                              _playListActionPayload['songList'] = _playList;
                              _playListActionPayload['songIndex'] = index;
                              _playListActionPayload['songDetail'] = songDetail;
                              _playListActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + searchList[index]['id'].toString() + '.mp3';
                              playListAction['payload'] = _playListActionPayload;
                              playListAction['type'] = playControllerActions.Actions.addPlayList;
                              isRequesting = false;
                              callback();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 100,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      searchList[index]['name'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      searchList[index]['album']['name'] + ' — ' + searchList[index]['artists'][0]['name'],
                                      maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12,
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
                )
              );
            },
          )
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}