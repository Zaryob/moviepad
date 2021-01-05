import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'context_page.dart';
import 'category_page.dart';
import 'imdb.dart';
import 'moviesql.dart';
import 'notes.dart';
import 'user_dashboard.dart';
import 'moviedb.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final String title;
  final int userNo;
  HomePage({this.title, this.userNo});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  final _pageOptions = [
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
        drawer: AppDrawer(userNo:widget.userNo),
        body: _pageOptions[_selectedPage],
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedPage,
          unselectedItemColor: Colors.lightBlueAccent,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.blue[900],
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
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
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      ExpansionTile(
        title: Text("Favourites"),
        leading: Icon(Icons.tv),
        children: <ListTile>[
          ListTile(
            title: Text("Favourite Films"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () async {

              final allRows = await dbHelper.movies();

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MePageDetailsPageScaffold(FavPublishment:allRows),
              )
              );

            },
          ),
/*
          ListTile(
            title: Text("Favourite Series"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {

              // do something
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CategoryPage("Favourite Series", IMDBSerieList)),
              );


            },
          ),
 */
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
            onTap: () async {

    final allRows = await dbHelper.watchedMovies();

    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => MePageDetailsPageScaffold(FavPublishment:allRows),
    )
    );

    },
          ),
          ListTile(
            title: Text("Waiting to Watch"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () async {

              final allRows = await dbHelper.waitingMovies();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MePageDetailsPageScaffold(FavPublishment:allRows),
                  )
              );

            },
          ),
          /*
          ListTile(
            title: Text("Complated Series"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              /*
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CategoryPage("Complated Series", IMDBFilmList)),
              );

               */
            },
          ),
          ListTile(
            title: Text("Continued Series"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              /*
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CategoryPage("Continued Series", IMDBFilmList)),
              );

               */
            },
          ),

           */
        ],
        trailing: Icon(Icons.arrow_drop_down_circle_outlined),
      ),
      ListTile(
        title: Text("Notes"),
        leading: Icon(Icons.event_note_outlined),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => noteList()),
          );
        },
      ),
    ]);
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Soul").snapshots(),
        builder: (context, snapshot) {
          return ListView.separated(
            itemCount: 1,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              if(snapshot.data.documents.length!=0)
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data.documents[index]['comment']),
              ),
                );
              return Text("data");
                  },
          );
        }
      ),
    );
  }
}

class ListViewSearch extends StatefulWidget {
  _ListViewSearchState createState() => _ListViewSearchState();
}

class _ListViewSearchState extends State<ListViewSearch> {
  //A controller is required to get the value of the textfield
  final searchTextController = new TextEditingController();
  String searchText = "";

 @override
  void dispose() {
    //Dispose the controller when the screen is disposed
    searchTextController.dispose();
    super.dispose();
  }

  //When a movie is clicked navigate to the movie detail screen
  void itemClick(Publish item) {
    //The movie details will be passed via the list
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PublishmentDetailsPage(item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          child: Row(
              children: <Widget>[
            Flexible(
              child: TextField(
                controller: searchTextController,
                decoration: InputDecoration(hintText: 'Enter a search term'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search Movies',
              onPressed: () {
                setState(() {
                  //Set the state with the new value so that the widget will re render
                  searchText = searchTextController.text;
                  //Hide keyboard when the state is set
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                });
              },
            ),
          ]),
          padding: EdgeInsets.all(10),
        ),
        //Only send the service request if the keyword is not empty
        if (searchText.length > 0)
          //A future builder to render the
          FutureBuilder<List<Publish>>(
              //Initiate the service request
              future: searchMovies(http.Client(), searchText),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //if the response has data render the movie list
                  return Expanded(child: MoviesList(Movies: snapshot.data, userNo: 0));
                }else if (snapshot.hasError){
                  print(snapshot.data);
                  print(snapshot.error);
                }
                //if the service call is in progress show the progress indicator
                return Center(child: CircularProgressIndicator());
              }),
      ],
    ));
  }
}

class HomeBodyWidget extends StatelessWidget {
  final int userNo;
  HomeBodyWidget({this.userNo});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Publish>>(
      future: fetchMovies(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //print(userNo);
          return MoviesList(Movies: snapshot.data, userNo: userNo);
        } else if (snapshot.hasError) {
          return Center(
              child: Icon(
            Icons.android,
            size: 220,
          ));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class AppDrawer extends StatefulWidget {
  final int userNo;
  AppDrawer({this.userNo});
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool showUserDetails = false;

  Widget _buildDrawerList() {
    return ListView(children: <Widget>[
      ListTile(
        title: Text("Latest"),
        leading: Icon(Icons.info_outline),
        onTap: () {
          /*
          *
          * */
        },
      ),
      FutureBuilder<List<MoviePageGenre>>(
          //Initiate the service request
          future: fetchCategories(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //if the response has data render the movie list
              return CategoryTiles(Genres: snapshot.data);
            }
            //if the service call is in progress show the progress indicator
            return Center(child: CircularProgressIndicator());
          }),
    ]);
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('usersInfo')
          .snapshots(),
      builder: (context, snapshot) {
        return Drawer(
          child: Column(children: [
            Container(
              height: 130,
              child: UserAccountsDrawerHeader(

                accountName: Text(snapshot.data.documents[widget.userNo]['userName']),
                accountEmail: Text(snapshot.data.documents[widget.userNo]['mail']),
                /*currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(110),
                  child: Image.asset(
                    "assets/profile/profile.jpg",
                    fit: BoxFit.cover,
                  ),
                ),*/
                decoration: BoxDecoration(
                  color: Colors.indigo[900],
                ),
                onDetailsPressed: () {
                  setState(() {
                    showUserDetails = !showUserDetails;
                  });
                },
              ),
            ),
            Expanded(
                child: showUserDetails ? _buildUserDetail() : _buildDrawerList())
          ]),
        );
      }
    );
  }
}

class CategoryTiles extends StatelessWidget {
  final List<MoviePageGenre> Genres;

  const CategoryTiles({Key key, this.Genres}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < Genres.length; i++) {
      children.add(
        new ListTile(
          title: Text(Genres[i].name),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CategoryPage(Genres[i])),
            );
          },
        ),
      );
    }

    return ExpansionTile(
      title: Text("Films"),
      leading: Icon(Icons.tv),
      trailing: Icon(Icons.arrow_drop_down_circle_outlined),
      children: children,
    );
  }
}

class MoviesList extends StatelessWidget {
  final List<Publish> Movies;
  final int userNo;

  MoviesList({Key key, this.Movies,this.userNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(Movies.length);
    var lenght = 20;
    if (Movies.length < 20) {
      lenght = Movies.length;
    }

    return ListView.separated(
      /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),*/
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: lenght,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.blue[50],
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PublishmentDetailsPage(Movies[index])),
              );
            },
            title: Row(
              children: [
                /*SizedBox(
                width: 200,
                child: Text(games[index].title),
              ),*/
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Image.network(Movies[index].poster_path),
                              width: 100,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Text(
                                      Movies[index].title,
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    width: 250,
                                  ),
                                  Text(
                                    Movies[index].release_date,
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  StarDisplayWidget(
                                    value: ((Movies[index].vote_average) / 2)
                                        .round(),
                                    filledStar: Icon(Icons.star,
                                        color: Colors.orange, size: 28),
                                    unfilledStar: Icon(Icons.star_border,
                                        color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            //onTap: ,
          ),
        );
      },
    );
  }
}


class MePageDetailsPageScaffold extends StatefulWidget {
  List<Publish> FavPublishment;

  MePageDetailsPageScaffold({Key key, this.FavPublishment});

  @override
  _MePageDetailsPageScaffoldState createState() => _MePageDetailsPageScaffoldState();
}

class _MePageDetailsPageScaffoldState extends State<MePageDetailsPageScaffold> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Center(child: Text("Favourite Filmes")),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: MoviesList(Movies:widget.FavPublishment, userNo:0),
    );
  }

}
