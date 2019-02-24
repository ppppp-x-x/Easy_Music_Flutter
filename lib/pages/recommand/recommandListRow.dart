import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './../SongList/playList.dart';

class RecommandList extends StatelessWidget {
  var recommandList;

  String computePlayCount(int number) {
    return (number / 10000).toStringAsFixed(0);
  }

  RecommandList(this.recommandList);
  @override
  Widget build(BuildContext context) {
    return recommandList == null
    ?
    Container()
    :
    Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 5,
                    height: 20,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      '最新歌单',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87
                      ),
                    ),
                  )
                ],
              ),
              Text(
                '更多',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(10),
            itemCount: recommandList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayList(recommandList[index]['id'], index.toString())
                    )
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Hero(
                              tag: index.toString(),
                              child: CachedNetworkImage(
                                imageUrl: recommandList[index]['coverImgUrl'],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black26, Colors.white24]
                              ),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                              computePlayCount(recommandList[index]['playCount']) + '万',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.grey[200]
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: 100,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          recommandList[index]['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 12
                          ),
                        ),
                      )
                    ],
                  ),
                )
              );
            },
          ),
        )
      ],
    );
  }
}