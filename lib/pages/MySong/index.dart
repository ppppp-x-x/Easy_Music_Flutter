import 'package:flutter/material.dart';

class MySong extends StatefulWidget {
  @override
  MySongState createState() => new MySongState();
}

class MySongState extends State<MySong> {
  static dynamic getSongListCardTopData() {
    List<dynamic> songListCardTopData = [];
    Map item1 = new Map();
    Map item2 = new Map();
    Map item3 = new Map();
    Map item4 = new Map();
    item1['title'] = '本地音乐';
    item1['iconUrl'] = 'assets/images/phone.png';
    item1['count'] = '666';
    songListCardTopData.add(item1);
    item2['title'] = '最近播放';
    item2['iconUrl'] = 'assets/images/clock.png';
    item2['count'] = '666';
    songListCardTopData.add(item2);
    item3['title'] = '下载管理';
    item3['iconUrl'] = 'assets/images/download.png';
    item3['count'] = '666';
    songListCardTopData.add(item3);
    item4['title'] = '我的收藏';
    item4['iconUrl'] = 'assets/images/shoucang.png';
    item4['count'] = '666';
    songListCardTopData.add(item4);
    return songListCardTopData;
  }

  dynamic songListCardTopData;

  @override
  void initState() {
    super.initState();
    songListCardTopData = getSongListCardTopData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SongListCardTop(songListCardTopData)
        ],
      ),
    );
  }
}

class SongListCardTop extends StatelessWidget {
  dynamic songListCardTopData;
  @override
  SongListCardTop(this.songListCardTopData);

  Widget createSongListCardTopItem(int index, double width, backColor, borderColor) {
    return Container(
      width: width,
      height: 70,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: <BoxShadow> [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 3)
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(backColor),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 1,
                color: Color(borderColor)
              ),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(0, 3)
                )
              ]
            ),
            child: Image.asset(
              songListCardTopData[index]['iconUrl'],
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                songListCardTopData[index]['title'],
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 3),
                child: Text(
                  songListCardTopData[index]['count'],
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12
                  ),
                )
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 185,
      decoration: BoxDecoration(
        color: Colors.grey[100]
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              createSongListCardTopItem(0, MediaQuery.of(context).size.width / 2 - 40, 0XFFFFD700, 0XFFFFD900),
              createSongListCardTopItem(1, MediaQuery.of(context).size.width / 2 - 40, 0XFF87CEFA, 0XFF87CEEB)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              createSongListCardTopItem(2, MediaQuery.of(context).size.width / 2 - 40, 0XFFFF7256, 0XFFFF6347),
              createSongListCardTopItem(3, MediaQuery.of(context).size.width / 2 - 40, 0XFFEEAEEE, 0XFFDDA0DD)
            ],
          )
        ],
      )
    );
  }
}