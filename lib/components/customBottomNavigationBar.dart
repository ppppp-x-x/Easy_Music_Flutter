import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';

import './../redux/index.dart';
import './../pages/Play/play.dart';
import './../redux/playController/action.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  CustomBottomNavigationBarState createState() => new CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        return
        state.playControllerState.currentIndex == 0 || state.playControllerState.playList.length == 0 || state.playControllerState.playList[state.playControllerState.currentIndex - 1] == null
        ?
        Container(
          width: MediaQuery.of(context).size.width,
          height: 0,
        )
        : 
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow> [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, -1)
              )
            ]
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Play()
                      )
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      state.playControllerState.playList[state.playControllerState.currentIndex - 1]['al']['picUrl'] == null
                      ?
                      Container()
                      :
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: state.playControllerState.playList[state.playControllerState.currentIndex - 1]['al']['picUrl'],
                          width: 40,
                          height: 40,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/album_avatar_default.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.fill,
                          ),
                        )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 220,
                        height: 70,
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              state.playControllerState.playList[state.playControllerState.currentIndex - 1]['name'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Text(
                                state.playControllerState.playList[state.playControllerState.currentIndex - 1]['ar'][0]['name'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black54
                                ),
                              )
                            )
                          ],
                        )
                      )
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          'assets/images/bottomNagivationBar_prev.png',
                          fit: BoxFit.fitHeight,
                        )
                      ),
                      Container(
                        child: StoreConnector<AppState, VoidCallback>(
                        converter: (store) {
                          var _action = new Map();
                          if (state.playControllerState.playing) {
                            _action['type'] = Actions.pause;
                          } else {
                            _action['type'] = Actions.play;
                          }
                          return () => store.dispatch(_action);
                        },
                        builder: (context, callback) {
                          return GestureDetector(
                            onTap: callback,
                            child: Container(
                              width: 20,
                              height: 20,
                              child: state.playControllerState.playing
                              ?
                              Image.asset(
                                'assets/images/bottomNagivationBar_pause.png',
                                fit: BoxFit.fitHeight,
                              )
                              :
                              Image.asset(
                                'assets/images/bottomNagivationBar_play.png'
                              )
                            ),
                          );
                        }
                      ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          'assets/images/bottomNagivationBar_next.png',
                          fit: BoxFit.fitHeight,
                        )
                      )
                    ],
                  )
                )
              ],
            ),
          ),
        );
      },
    );
  }
}