import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './../SongList/playList.dart';

class RecommendList extends StatelessWidget {
  List recommendList;
  String listTitle;

  RecommendList(this.recommendList, this.listTitle);

  Widget createRowList (List<Map<String, dynamic>> rowData, String rowCount) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        itemCount: rowData.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayList(rowData[index]['id'])
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
                          tag: rowCount + index.toString() + this.listTitle,
                          child: CachedNetworkImage(
                            imageUrl: rowData[index]['coverImgUrl'] ?? rowData[index]['picUrl'],
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
                          (rowData[index]['playCount'] / 10000).toStringAsFixed(0) + '万',
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
                      rowData[index]['name'],
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
    );
  }

  List<Widget> createRow () {
    int count = 0;
    int rowCount = 0;
    List<Map<String, dynamic>> rowData = [];
    List<Widget> allRowData = [];
    allRowData.add(
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
                  color: Colors.red,
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    this.listTitle,
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
                color: Colors.red
              ),
            )
          ],
        ),
      ),
    );
    for(int i = 0;i < this.recommendList.length; i++) {
      count ++;
      rowData.add(this.recommendList[i]);
      if (this.recommendList.length <= i || count == 9) {
        rowCount ++;
        count = 0;
        allRowData.add(createRowList(rowData, rowCount.toString()));
        rowData = [];
      }
    }
    return allRowData;
  }

  @override
  Widget build(BuildContext context) {
    return recommendList == null
    ?
    Container()
    :
    Column(
      children: createRow()
    );
  }
}