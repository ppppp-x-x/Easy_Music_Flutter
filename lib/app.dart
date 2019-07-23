import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import './pages/Recommend/index.dart';
import './pages/Rank/index.dart';
import './pages/MySong/index.dart';
import './components/customBottomNavigationBar.dart';
import './redux/index.dart';
import './pages/Search/index.dart';

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
    new Recommend(),
    new CollectSongList(),
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
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Easy_Music',
        home: Scaffold(
          backgroundColor: Colors.white,
          drawer: Drawer(
            child: Text('data'),
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBar(
              backgroundColor: Colors.white,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.menu),
                    color: Colors.black,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              title: Container(
                margin: EdgeInsets.only(top: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '发现音乐',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                    SearchButton()
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.black,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      '发现音乐',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      '我的音乐',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      '排行榜',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                ],
              ),
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

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Search()
            )
          );
        },
        icon: Icon(
          Icons.search,
          size: 22,
          color: Colors.black,
        )
      )
    );
  }
}

