import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';

import './../redux/index.dart';
import './../pages/Play/play.dart';
import './../redux/playController/action.dart' as playControllerActions;

import 'commonText.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  CustomBottomNavigationBarState createState() => new CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  bool isRequesting = false;

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
        state.playControllerState.playList.length == 0 || state.playControllerState.playList[state.playControllerState.currentIndex] == null
        ?
        Container(
          width: MediaQuery.of(context).size.width,
          height: 0,
        )
        : 
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO((state.playControllerState.coverMainColor[0] / 1.5).round(), (state.playControllerState.coverMainColor[1] / 1.5).round(),
          (state.playControllerState.coverMainColor[2] / 1.5).round(), 1),
            boxShadow: <BoxShadow> [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, -1)
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: InkWell(
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
                    children: <Widget>[
                      state.playControllerState.playList[state.playControllerState.currentIndex]['al']['picUrl'] == null
                      ?
                      Container()
                      :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          child: CachedNetworkImage(
                            imageUrl: state.playControllerState.playList[state.playControllerState.currentIndex]['al']['picUrl'],
                            width: 40,
                            height: 40,
                            placeholder: (context, url) => ClipRRect(
                              child: Image.asset(
                                'assets/images/album_avatar_default.png',
                                width: 40,
                                height: 40,
                              ),
                              borderRadius: BorderRadius.circular(20)
                            )
                          )
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 60,
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CommonText(
                                state.playControllerState.playList[state.playControllerState.currentIndex]['name'],
                                12,
                                1,
                                Colors.white,
                                FontWeight.bold
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                child: 
                                CommonText(
                                  state.playControllerState.playList[state.playControllerState.currentIndex]['ar'][0]['name'],
                                  10,
                                  1,
                                  Colors.white70,
                                  FontWeight.normal
                                )
                              )
                            ],
                          )
                        )
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  StoreConnector<AppState, VoidCallback>(
                    converter: (store) {
                      return () => store.dispatch(playControllerActions.playePrevSong);
                    },
                    builder: (BuildContext context, callback) {
                      return Material(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () async {
                            if (isRequesting == true) {
                              return null;
                            }
                            isRequesting = true;
                            await callback();
                            isRequesting = false;
                          },
                          icon: Icon(Icons.skip_previous, size: 25, color: Colors.white)
                        )
                      );
                    }
                  ),
                  StoreConnector<AppState, VoidCallback>(
                    converter: (store) {
                      var _action = new Map();
                      if (state.playControllerState.playing == true) {
                        _action['type'] = playControllerActions.Actions.pause;
                      } else {
                        _action['type'] = playControllerActions.Actions.play;
                      }
                      return () => store.dispatch(_action);
                    },
                    builder: (BuildContext context, callback) {
                      return IconButton(
                        iconSize: 35,
                        onPressed: () {
                          callback();
                        },
                        icon: 
                        state.playControllerState.playing
                        ?
                          Icon(Icons.pause, size: 35, color: Colors.white)
                        :
                          Icon(Icons.play_arrow, size: 35, color: Colors.white)
                      );
                    }
                  ),
                  StoreConnector<AppState, VoidCallback>(
                    converter: (store) {
                      return () => store.dispatch(playControllerActions.playeNextSong);
                    },
                    builder: (BuildContext context, callback) {
                      return Material(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () async {
                            if (isRequesting == true) {
                              return null;
                            }
                            isRequesting = true;
                            await callback();
                            isRequesting = false;
                          },
                          icon: Icon(Icons.skip_next, size: 25, color: Colors.white)
                        )
                      );
                    }
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}