import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';

import './../redux/playList/state.dart';

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
    return StoreConnector<PlayListModelState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        return
        state.currentIndex == 0 || state.playList.length == 0 || state.playList[state.currentIndex - 1] == null
        ?
        Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: state.playList[state.currentIndex - 1]['albumBg'],
                        width: 40,
                        height: 40,
                        placeholder: Image.asset(
                          'assets/images/album_avatar_default.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.fill,
                        ),
                      )
                    ),
                    Container(
                      width: 200,
                      height: 70,
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            state.playList[state.currentIndex - 1]['name'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Text(
                              state.playList[state.currentIndex - 1]['singer'],
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
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          'assets/images/bottomNagivationBar_play.png',
                          fit: BoxFit.fitHeight,
                        )
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