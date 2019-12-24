import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './../../redux/index.dart';

import './../../utils/commonFetch.dart';
import './../../utils//api.dart';
import './../../utils//tools.dart';

import './../../redux/playController/action.dart' as playControllerActions;
import './../../components/customBottomNavigationBar.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  bool searched = false;
  bool showSpinner = false;
  String lastSearchStr = '';
  List<Widget> searchHotWidgets = [];
  List<dynamic> searchList = [];
  Map<String, dynamic> playListAction;

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

  void Submit(String str) {
    if(str != lastSearchStr) {
      lastSearchStr = str;
      getSearchList(str);
    }
  }

  dynamic getSearchHot() async {
    Map _searchHot = await getData('hotSearch', {});
    if(this.mounted) {
      setState(() {
        searchHotWidgets = createSearchHot(_searchHot);  
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

  // create hot search list widget
  List<Widget> createSearchHot(Map searchHot) {
    List _searchHot = searchHot['result']['hots'];
    List<Widget> _searchHotWidgets = [];
    for(int i = 0;i < _searchHot.length;i ++) {
      _searchHotWidgets.add(
        GestureDetector(
          onTap: () {
            this.searchController.text = _searchHot[i]['first'];
            this.Submit(this.searchController.text);
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
            height: 22,
            decoration: BoxDecoration(
              color: randomColor(),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Text(
              _searchHot[i]['first'],
              maxLines: 1,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 10
              ),
            ),
          )
        )
      );
    }
    return _searchHotWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(
              Icons.arrow_back
            ),
            onPressed: () {
              Navigator.pop(context);
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
                fontSize: 12
              ),
              fillColor: Colors.black,
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 8),
            ),
            onSubmitted: this.Submit,
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: Icon(
                Icons.search
              )
            )
          ],
        ),
        body:
        showSpinner
        ?
        Container(
          child:  SpinKitDualRing(
            color: Colors.red,
          )
        )
        :
        searchHotWidgets.length > 0 && !searched
        ?
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topCenter,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: searchHotWidgets,
            )
          )
        )
        :
        Container(
          margin: EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemCount: searchList.length,
            itemBuilder: (BuildContext context, int index) {
              return  Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        width: 30,
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            fontSize: 12,
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
                                String songLyr = await getData('lyric', {
                                  'id': searchList[index]['id']
                                });
                                Map songDetail = await getSongDetail(searchList[index]['id']);
                                Map _playListActionPayLoad = {};
                                List _playList = [];
                                songDetail['songLyr'] = songLyr;
                                playListAction = {};
                                for(int j = 0;j < searchList.length;j ++) {
                                  _playList.add(searchList[j]['id'].toString());
                                }
                                _playListActionPayLoad['songList'] = _playList;
                                _playListActionPayLoad['songIndex'] = index;
                                _playListActionPayLoad['songDetail'] = songDetail;
                                _playListActionPayLoad['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + searchList[index]['id'].toString() + '.mp3';
                                playListAction['payLoad'] = _playListActionPayLoad;
                                playListAction['type'] = playControllerActions.Actions.addPlayList;
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
                                        searchList[index]['name'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        searchList[index]['album']['name'] + '——' + searchList[index]['artists'][0]['name'],
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
      ),
    );
  }
}