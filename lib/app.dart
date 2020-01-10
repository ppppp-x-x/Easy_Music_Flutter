import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import './redux/index.dart';

import './pages/Recommend/index.dart';
import './pages/Rank/index.dart';
import './pages/Search/index.dart';
import './pages/MySong/index.dart';

import './components/customBottomNavigationBar.dart';

class MyApp extends StatefulWidget {
  final Store<AppState> store;
  MyApp(this.store);
  @override
  MyAppState createState() => new MyAppState(this.store);
}

// AutomaticKeepAliveClientMixin：keep tab pages alive
class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  Store<AppState> store;
  MyAppState(this.store);
  TabController _tabController;
  List<Widget> _body = [new Recommend(), new CollectSongList(), new Rank()];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget createTab(String title) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Easy_Music',
          home: Scaffold(
              backgroundColor: Colors.white,
              // todo：left drawer content
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
                          style: TextStyle(color: Colors.black),
                        ),
                        SearchButton()
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.black,
                    tabs: <Widget>[
                      createTab('发现音乐'),
                      createTab('我的音乐'),
                      createTab('排行榜'),
                    ],
                  ),
                ),
              ),
              body: StoreConnector<AppState, dynamic>(
                  converter: (store) => store.state,
                  builder: (BuildContext context, state) {
                    return Stack(
                      children: <Widget>[
                        TabBarView(
                          controller: _tabController,
                          children: _body,
                        ),
                        state.commonState.isRequesting
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                child: SpinKitDoubleBounce(
                                  color: Colors.red[300],
                                ),
                              )
                            : Container()
                      ],
                    );
                  }),
              bottomNavigationBar: CustomBottomNavigationBar()),
        ));
  }

  // @override
  // bool get wantKeepAlive => true;
}

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
            icon: Icon(
              Icons.search,
              size: 22,
              color: Colors.black,
            )));
  }
}
