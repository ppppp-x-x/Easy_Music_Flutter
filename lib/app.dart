import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import './pages/recommand/index.dart';
import './pages/songList/index.dart';
import './pages/rank/index.dart';
import './pages/MySong/index.dart';
import './components/customBottomNavigationBar.dart';
import './redux/index.dart';

class MyApp extends StatefulWidget{
  final Store<AppState> store;
  MyApp(this.store);
  @override
  MyAppState createState() => new MyAppState(this.store);
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final Store<AppState> store;
  MyAppState(this.store);
  TabController _tabController;
  List<Widget> _body = [
    new Recommand(),
    new MySong(),
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
      length: 4,
      vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
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
                  text: '我的音乐',
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
          body: TabBarView(
            controller: _tabController,
            children: _body,
          ),
          bottomNavigationBar: CustomBottomNavigationBar()
        ),
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

