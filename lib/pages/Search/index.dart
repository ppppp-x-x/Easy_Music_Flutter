import 'package:flutter/material.dart';

import './../../utils/request.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  List<Widget> searchHotWidgets = [];
  String lastSearchStr = '';
  List searchList = [];

  @override
  initState() {
    super.initState();
    getSearchHot();
  }

  void Submit(String str) {
    if(str != lastSearchStr) {
      lastSearchStr = str;
      getSearchList(str);
    }
  }

  dynamic getSearchHot() async {
    dynamic _searchHot = await fetchData('http://xinpeng.natapp1.cc/search/hot');
    if(this.mounted) {
      setState(() {
        searchHotWidgets = createSearchHot(_searchHot);  
      });
    }
  }

  dynamic getSearchList(String str) async {
    dynamic _searchList = await fetchData('http://xinpeng.natapp1.cc/search?keywords=' + str);
    if(this.mounted) {
      setState(() {
        searchList = _searchList['result']['songs'];
      });
    }
  }

  List<Widget> createSearchHot(dynamic searchHot) {
    dynamic _searchHot = searchHot['result']['hots'];
    List<Widget> _searchHotWidgets = [];
    for(int i = 0;i < _searchHot.length;i ++) {
      _searchHotWidgets.add(
        Container(
          padding: EdgeInsets.all(2),
          height: 22,
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(3)
          ),
          child: Text(
            _searchHot[i]['first'],
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12
            ),
          ),
        )
      );
    }
    return _searchHotWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: IconButton(
            color: Colors.white,
            icon: Icon(
              Icons.arrow_back
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: TextField(
            style: TextStyle(
              color: Colors.white
            ),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Colors.white
              ),
              hintText: '歌名/歌手/歌单',
              hintStyle: TextStyle(
                color: Colors.white
              ),
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 8),
            ),
            onSubmitted: this.Submit,
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: Icon(
                Icons.search
              )
            )
          ],
        ),
        body:
        searchHotWidgets.length > 0
        ?
        Container(
          margin: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topCenter,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: searchHotWidgets,
            )
          )
        )
        :
        Container()
      ),
    );
  }
}