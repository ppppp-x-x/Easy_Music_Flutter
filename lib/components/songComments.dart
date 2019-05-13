import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import './../redux/index.dart';

class SongComments extends StatefulWidget {
  SongCommentsState createState () => SongCommentsState();
}

class SongCommentsState extends State<SongComments> {

  @override
  void initState () {
  }

  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        print(state);
        return Container();
      }
    );
  }
}