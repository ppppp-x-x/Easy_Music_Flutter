import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './../../redux/index.dart';
class CollectSongList extends StatefulWidget {
  @override
  CollectSongListState createState() => CollectSongListState();
}

class CollectSongListState extends State<CollectSongList> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        return state.playControllerState.collectSongs.length > 0
          ? 
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView.builder(
              physics: new NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.playControllerState.collectSongs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              width: 50,
                              height: 50,
                              imageUrl: state.playControllerState.collectSongs[index]['cover'],
                              placeholder: (context, url) => Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey,
                              ),
                            )
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  state.playControllerState.collectSongs[index]['name'],
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                  ),
                                ),
                                Text(
                                  state.playControllerState.collectSongs[index]['author'],
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                  ),
                                )
                              ],
                            )
                          )
                        ],
                      ),
                      Icon(
                        Icons.more_vert,
                        color: Colors.black45,
                      )
                    ],
                  )
                );
              }
            )
          )
          :
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  '还没有收藏过歌曲',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54
                  ),
                ),
              )
            ],
          );
      });
  }
}