import 'package:flutter/material.dart';

import './../../utils/request.dart';
import './../../components/banners.dart';
import './recommandListRow.dart';

class Recommand extends StatefulWidget {
  @override
  RecommandState createState() => new RecommandState();
}

class RecommandState extends State<Recommand> with AutomaticKeepAliveClientMixin {
  var bannerList;
  var recommandList;

  @override
  void initState() {
    super.initState();
    fetchBannner();
    fetchRecommandList();
  }

  void fetchBannner() async {
    var _bannerList = await fetchData('http://xinpeng.natapp1.cc/banner');
    setState(() {
     bannerList = _bannerList['banners']; 
    });
  }

  void fetchRecommandList() async {
    var _recommandList = await fetchData('http://xinpeng.natapp1.cc/top/playlist?limit=10&order=hot');
    setState(() {
     recommandList = _recommandList['playlists']; 
    });
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
          Banners(bannerList),
          Menu(),
          Divider(),
          RecommandList(recommandList)
        ],
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 18),
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0XFFFFD700),
                  border: Border.all(
                    width: 1,
                    color: Color(0XFFFFD900)
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
                  'assets/images/musicBox.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '私人FM'
                )
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blue[300],
                  border: Border.all(
                    width: 1,
                    color: Colors.blue[400]
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
                  'assets/images/date.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '每日推荐'
                )
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.red[300],
                  border: Border.all(
                    width: 1,
                    color: Colors.red[400],
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
                  'assets/images/rank.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '排行榜'
                )
              )
            ],
          )
        ],
      )
    );
  }
}