import 'package:flutter/material.dart';
import 'test.dart';
import 'category_page.dart';
import 'imdb.dart';
import 'user_dashboard.dart';


class HomePage extends StatefulWidget {
  final String title;
  final String asd;
  const HomePage({
    this.title,this.asd}
      );

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage=0;
  final _pageOptions=[
    HomeBodyWidget(),
    ListViewSearch(),
    MePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      home: Scaffold(
        appBar: AppBar(
          title: Text('MoviePad'),
          backgroundColor: Colors.blue[900],
        ),
        drawer: AppDrawer(),
        body: _pageOptions[_selectedPage],
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedPage,
          unselectedItemColor: Colors.lightBlueAccent,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.blue[900],
          onTap: (int index){
            setState(() {
              _selectedPage=index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text("Home"),
              backgroundColor: Colors.indigo[900],
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.search),
              title: new Text("Search"),
              backgroundColor: Colors.indigo[900],
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              title: new Text("Me"),
              backgroundColor: Colors.indigo[900],
            ),
          ],
        ),
      ),
    );
  }
}

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text("Favourites"),
            leading: Icon(Icons.tv),
            children: <ListTile>[
              ListTile(
                title: Text("Favourite Films"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("Favourite Films", IMDBFilmList)),
                  );
                },
              ),
              ListTile(
                title: Text("Favourite Series"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  // do something
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("Favourite Series", IMDBSerieList)),
                  );
                },
              ),
            ],
            trailing: Icon(Icons.arrow_drop_down_circle_outlined),
          ),
          ExpansionTile(
            title: Text("Personal List"),
            leading: Icon(Icons.tv),
            children: <ListTile>[
              ListTile(
                title: Text("Watched"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("Watched", IMDBFilmList)),
                  );
                },
              ),
              ListTile(
                title: Text("Waiting to Watch"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("Waiting to Watch", IMDBFilmList)),
                  );
                },

              ),
              ListTile(
                title: Text("Complated Series"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("Complated Series", IMDBFilmList)),
                  );
                },

              ),
              ListTile(
                title: Text("Continued Series"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("Continued Series", IMDBFilmList)),
                  );
                },

              ),
            ],
            trailing: Icon(Icons.arrow_drop_down_circle_outlined),
          ),
          ListTile(
            title: Text("Notes"),
            leading: Icon(Icons.event_note_outlined),
            trailing: Icon(Icons.arrow_forward),
            onTap:() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>Notes() ),
              );
            },
          ),

        ]
    );
  }
}
class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MoviePad'),
    backgroundColor: Colors.blue[900],
      ),
      body: Container(
          child: Center(child: Text('Under Construction')),
      ),
    );
  }
}


class ListViewSearch extends StatefulWidget {
  _ListViewSearchState createState() => _ListViewSearchState();
}

class _ListViewSearchState extends State<ListViewSearch> {
  TextEditingController _textController = TextEditingController();

  List<IMBDListItem> _newData = [];

  _onChanged(String value) {
    setState(() {
      _newData=IMDBList.where((element) => element.title.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'enter text here',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: _onChanged,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        _newData != null && _newData.length != 0
            ? Expanded(
          child: ListView(
            padding: EdgeInsets.all(10.0),
            itemExtent: 106.0,
            children: _newData.map((data) {
              return data;
            }).toList(),
          ),
        )
            : SizedBox(),
      ],
    );
  }
}

class HomeBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      itemExtent: 106.0,
      children: IMDBList,
    );
  }
}

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool showUserDetails = false;
  String accName='Name';
  String accEmail='example@gmail.com';
  Widget _buildDrawerList() {

    return ListView(
        children: <Widget>[
          ListTile(
            title: Text("Category 1"),
            leading: Icon(Icons.info_outline),
            onTap:() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryPage("Category 1",IMDBList)),
              );
            },
          ),
          ExpansionTile(
            title: Text("Category 2"),
            leading: Icon(Icons.tv),
            children: <ListTile>[
              ListTile(
                title: Text("SubCategory 1"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("SubCategory 1",IMDBFilmList)),
                  );
                },
              ),
              ListTile(
                title: Text("SubCategory 2"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("SubCategory 2",IMDBFilmList)),
                  );
                },

              ),
              ListTile(
                title: Text("SubCategory 3"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("SubCategory 3",IMDBFilmList)),
                  );
                },

              ),
              ListTile(
                title: Text("SubCategory 4"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("SubCategory 4",IMDBFilmList)),
                  );
                },

              ),
            ],
            trailing: Icon(Icons.arrow_drop_down_circle_outlined),
          ),
          ExpansionTile(
            title: Text("Category 2"),
            leading: Icon(Icons.tv),
            children: <ListTile>[
              ListTile(
                title: Text("SubCategory 1"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("SubCategory 1",IMDBSerieList)),
                  );
                },
              ),
              ListTile(
                title: Text("SubCategory 2"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("SubCategory 2",IMDBSerieList)),
                  );
                },

              ),
              ListTile(
                title: Text("SubCategory 3"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("SubCategory 3",IMDBSerieList)),
                  );
                },

              ),
              ListTile(
                title: Text("SubCategory 4"),
                trailing: Icon(Icons.arrow_forward),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage("SubCategory 4",IMDBSerieList)),
                  );
                },

              ),
            ],
            trailing: Icon(Icons.arrow_drop_down_circle_outlined),
          ),

        ]
    );
  }

  Widget _buildUserDetail() {

    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          ListTile(
            title: Text("User details"),
            leading: Icon(Icons.info_outline),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        UserAccountsDrawerHeader(
          accountName: Text(accName),
          accountEmail: Text(accEmail),
          currentAccountPicture: ClipRRect(
            borderRadius: BorderRadius.circular(110),
            child: Image.asset("assets/profile/profile.jpg", fit: BoxFit.cover,),
          ),
          decoration: BoxDecoration(
            color: Colors.indigo[900],
          ),
          onDetailsPressed: () {
            setState(() {
              showUserDetails = !showUserDetails;
            });
          },
        ),
        Expanded(child: showUserDetails ? _buildUserDetail() : _buildDrawerList())
      ]),
    );
  }
}