import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './rankList.dart';

import './../../utils//api.dart';

dynamic rankContrast = {
  '云音乐新歌榜': 0,
  '云音乐热歌榜': 1,
  '网易原创歌曲榜': 2,
  '云音乐飙升榜': 3,
  '云音乐电音榜': 4,
  'UK排行榜周榜': 5,
  '美国Billboard周榜': 6,
  'KTV嗨榜': 7,
  'iTunes榜': 8,
  'Hit FM Top榜': 9,
  '日本Oricon周榜': 10,
  '韩国Melon排行榜周榜': 11,
  '韩国Mnet排行榜周榜': 12,
  '韩国Melon原声周榜': 13,
  '中国TOP排行榜(港台榜)': 14,
  '中国TOP排行榜(内地榜)': 15,
  '香港电台中文歌曲龙虎榜': 16,
  '华语金曲榜': 17,
  '中国嘻哈榜': 18,
  '法国 NRJ EuroHot 30周榜': 19,
  '台湾Hito排行榜': 20,
  'Beatport全球电子舞曲榜': 21,
  '云音乐ACG音乐榜': 22,
  '云音乐嘻哈榜': 23
};

class Rank extends StatefulWidget {
  @override
  RankState createState() => new RankState();
}

class RankState extends State<Rank> with AutomaticKeepAliveClientMixin{
  dynamic allRankList;
  List<String> rankListName = ['BillBoard', 'UK'];

  @override
  void initState() {
    super.initState();
    getAllRankList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getAllRankList() async {
    dynamic _allRankList = await getData('toplist', {});
    if (_allRankList == '请求错误') {
      return;
    }
    setState(() {
      allRankList = _allRankList['list'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: 
      allRankList == null
      ?
      Container(
        child: SpinKitDualRing(
          color: Colors.red,
        )
      )
      :
      Container(
        margin: EdgeInsets.only(top: 20),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10
          ),
          itemCount: allRankList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                int _id = rankContrast[allRankList[index]['name']]; 
                if(_id != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RankList(_id)
                    )
                  );
                } else {
                  print('未知id');
                }
              },
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: allRankList[index]['coverImgUrl'],
                      width: 80,
                      height: 80,
                      placeholder: (context, url) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey,
                      ),
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5
                    ),
                    child: Text(
                      allRankList[index]['name'],
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87
                      ),
                    )
                  )
                ],
              )
            );
          },
        )
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}