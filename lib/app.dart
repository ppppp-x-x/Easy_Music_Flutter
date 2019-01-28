import 'package:flutter/material.dart';

import './pages/recommand/index.dart';
import './pages/songList/index.dart';
import './pages/rank/index.dart';

class MyApp extends StatefulWidget{
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  List<Widget> _body = [
    new Recommand(),
    new SongList(),
    new Rank()
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
      length: 3,
      vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy_Music',
      home: Scaffold(
        drawer: Drawer(
          child: Text('data'),
        ),
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '发现音乐'
              ),
              IconButton(
                onPressed: () {
                  print('暂未开发');
                },
                icon: ImageIcon(
                 AssetImage(
                   'assets/images/find.png'
                 ),
                 color: Colors.white,
                 size: 22,
                )
              )
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: '个性推荐',
              ),
              Tab(
                text: '歌单',
              ),
              Tab(
                text: '排行榜'
              )
            ],
          ),
        ),
        body: Builder(
          builder: (BuildContext context) => 
          Stack(
            children: <Widget>[
              TabBarView(
                controller: _tabController,
                children: _body,
              ),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height - 100
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Row(
                    
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

