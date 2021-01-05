import 'package:flutter/material.dart';
import 'package:moviepad/episodes_page.dart';
import 'moviedb.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'moviesql.dart';
import 'homepage.dart';

class ArcBannerImage extends StatelessWidget {
  ArcBannerImage(this.imageUrl);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return ClipPath(
      clipper: ArcClipper(),
      child: Image.network(
        imageUrl,
        width: screenWidth,
        height: 230.0,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PublishmentDetailHeader extends StatelessWidget {
  PublishmentDetailHeader(this.movie);
  final MoviePage movie;

  @override
  Widget build(BuildContext context) {

    var movieInformation = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title),
        SizedBox(height: 8.0),
        RatingInformation(movie),
        SizedBox(height: 8.0),
      ],
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 140.0),
          child: ArcBannerImage(movie.backdrop_path),
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Poster(
                movie.poster_path,
                height: 180.0,
              ),
              SizedBox(width: 25.0),
              Expanded(child: movieInformation),
            ],
          ),
        ),
      ],
    );
  }
}

class PublishmentDetailsPage extends StatefulWidget {
  PublishmentDetailsPage(this.movie);

  final Publish movie;

  @override
  _PublishmentDetailsPageState createState() => _PublishmentDetailsPageState();
}

class _PublishmentDetailsPageState extends State<PublishmentDetailsPage> {
  MoviePage moviepage;

  @override
  void initState() {
    super.initState();
    var call = fetchMovieDetails(http.Client(), widget.movie.id);
    call.then((data) {
      setState(() {
        moviepage = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (moviepage == null) {
      return PublishmentDetailsPageProgressScaffold(widget.movie);
    }

    return PublishmentDetailsPageScaffold(MoviePages: moviepage, Publishment: widget.movie);
  }
}

class PublishmentDetailsPageProgressScaffold extends StatelessWidget {
  final Publish movie;
  PublishmentDetailsPageProgressScaffold(this.movie);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Center(child: Text(movie.title)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}

class PublishmentDetailsPageScaffold extends StatefulWidget {
  MoviePage MoviePages;
  Publish Publishment;

  PublishmentDetailsPageScaffold({Key key, this.MoviePages, this.Publishment});

  @override
  _PublishmentDetailsPageScaffoldState createState() => _PublishmentDetailsPageScaffoldState();
}

class _PublishmentDetailsPageScaffoldState extends State<PublishmentDetailsPageScaffold> {
  final commentController = new TextEditingController();

  final dbHelper = DatabaseHelper.instance;
  bool inFavourite = false;

  Item selectedUser;
  List<Item> users = <Item>[
    const Item('Waiting To Watch',Icon(Icons.assignment_sharp,color: Colors.red)),
    const Item('Watched',Icon(Icons.assignment_turned_in_outlined,color:  Colors.green)),
  ];


  @override
  void initState() {

    setStateOfExisting();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Center(child: Text(widget.MoviePages.title)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [

                PublishmentDetailHeader(widget.MoviePages),
                SizedBox(height: 20.0),
                Text(widget.MoviePages.tagline,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
                InkWell(
                  child: Chip(
                    backgroundColor: Colors.blue,
                    label: Text(
                      "Status: " + widget.MoviePages.status,
                      style: TextStyle(color: Colors.white),
                    ),
                    deleteIcon: Icon(Icons.merge_type_outlined),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 8.0),
                  child: Row(
                    children: [
                      RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)),
                          color: inFavourite == false ? Colors.lightGreen : Colors.redAccent,
                          textColor: Colors.white,
                          child: inFavourite == false ? Text("Insert into Favourites") : Text("Remove from Favourites"),
                          //    style: TextStyle(fontSize: 14)
                          onPressed: () {
                            setState(() {
                              if (inFavourite==true){
                                removeFromDatabase();
                              }else{
                                pushDatabase();
                              }
                              inFavourite = !inFavourite;
                            });
                          }
                      ),
                      SizedBox(width: 20),
                      Container(
                        color: Colors.blue[100],
                        child: DropdownButton<Item>(
                          hint: Text("   Add to Watchlist"),
                          value: selectedUser,
                          onChanged: (Item Value) {
                            setState(() {
                              selectedUser = Value;
                              if(selectedUser.name=='Watched'){
                                pushDatabaseWatched("watched");
                              }else if (selectedUser.name=='Waiting To Watch'){
                                pushDatabaseWatched("not_watched");
                              }
                            });
                          },
                          items: users.map((Item user) {
                            return  DropdownMenuItem<Item>(
                              value: user,
                              child: Row(
                                children: <Widget>[
                                  user.icon,
                                  SizedBox(width: 10,),
                                  Text(
                                    user.name,
                                    style:  TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Genres(widget.MoviePages),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Storyline(widget.MoviePages.overview),
                ),

                //PhotoScroller(MoviePages.images.posters),
                //SizedBox(height: 20.0),
                // BackdropsScroller(MoviePages.images.backdrops),
                // SizedBox(height: 20.0),
                //   _episodeAdder(),
                ActorScroller(widget.MoviePages.credits.cast),
                SizedBox(height: 20.0),
                CrewScroller(widget.MoviePages.credits.crew),
                SizedBox(height: 20.0),
                ProductorScroller(widget.MoviePages.production_companies),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3.0,color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    children: [
                      Text(""),
                      Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Comment',
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                      width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xFF1565C0),
                                      width: 2),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline,
                            color: Colors.blue[900],),
                            tooltip: 'Search Movies',
                            onPressed: () {
                              setState(() {
                                //Set the state with the new value so that the widget will re render
                                if(commentController.text!=""){
                                FirebaseFirestore.instance//.collection("Comments").doc(UserClass.userInfo2)
                                    .collection(widget.MoviePages.title).doc("${HomePage().userNo}")
                                    .set( {'comment': commentController.text,});}
                              });
                            },
                          ),
                        ],
                      ),
                      Text(""),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    color: Colors.blue[200],
                    child: Container(
                      width: 400,
                        height: 50,
                        child: Center(
                            child: Text(
                              widget.MoviePages.title+"'s Comments",textScaleFactor: 1.5,))),),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection(widget.MoviePages.title).snapshots(),
                      builder: (context, snapshot) {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          separatorBuilder: (BuildContext context, int index) => Divider(height: 4,),
                          itemBuilder: (BuildContext context, int index) {
                            if(snapshot.data.documents.length!=0)
                              return Card(
                                elevation: 10,
                                color: Colors.blue[100],
                                child: ListTile(
                                  title: Text(snapshot.data.documents[index]['comment']),
                                  subtitle: Text("Anonymous User"),
                                  trailing: GestureDetector(
                                      child: Icon(
                                        Icons.delete_outline,
                                        size: 20.0,
                                        color: Colors.brown[900],
                                      ),

                                ),
                                  onTap: (){
                                    setState(() {
                                      FirebaseFirestore.instance
                                          .collection(widget.MoviePages.title).document("${HomePage().userNo}")
                                          .delete()
                                          .then((value) => print("Comment deleted"))
                                          .catchError((error)=> print("catched $error"));
                                    });
                                  },
                                ),
                              );
                            return Text("");
                          },
                        );
                      }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setStateOfExisting() async{
    final state = await dbHelper.find(widget.Publishment.id);
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
    if(state==true){
      print("Already stated in to table.");
      inFavourite=true;
    }else {
      print("Not found in the table.");
      inFavourite=false;
    }
  }
  void pushDatabase() async {
    //Set the state with the new value so that the widget will re render
    Map<String, dynamic> row = {
      DatabaseHelper.columnId : widget.Publishment.id,
      DatabaseHelper.columnTitle  : widget.Publishment.title,
      DatabaseHelper.columnDate : widget.Publishment.release_date,
      DatabaseHelper.columnMT : widget.Publishment.media_type,
      DatabaseHelper.columnOverV: widget.Publishment.overview,
      DatabaseHelper.columnBPath: widget.Publishment.backdrop_path,
      DatabaseHelper.columnPPath: widget.Publishment.poster_path,
      DatabaseHelper.columnVote: widget.Publishment.vote_average,

    };
    final state = await dbHelper.find(widget.Publishment.id);
    if(state==true){
      print("Already stated in to table.");
    }else {
      print("Not found in the table.");
      final id = await dbHelper.insert(row);
      print('inserted row id: $id');
    }

    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void removeFromDatabase() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(widget.Publishment.id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  void pushDatabaseWatched(String status) async {
    //Set the state with the new value so that the widget will re render
    Map<String, dynamic> row = {
      DatabaseHelper.columnId : widget.Publishment.id,
      DatabaseHelper.columnTitle  : widget.Publishment.title,
      DatabaseHelper.columnDate : widget.Publishment.release_date,
      DatabaseHelper.columnMT : widget.Publishment.media_type,
      DatabaseHelper.columnOverV: widget.Publishment.overview,
      DatabaseHelper.columnBPath: widget.Publishment.backdrop_path,
      DatabaseHelper.columnPPath: widget.Publishment.poster_path,
      DatabaseHelper.columnVote: widget.Publishment.vote_average,
      DatabaseHelper.watched: status,
    };
    final state = await dbHelper.findWatched(widget.Publishment.id);
    if(state==true){
      print("Already stated in to table.");
      final id =await dbHelper.updateWatched(row);
      print('inserted row id: $id');
    }else {
      print("Not found in the table.");
      final id = await dbHelper.insertWatched(row);
      print('inserted row id: $id');
    }

    final allRows = await dbHelper.queryAllRowsWatched();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void removeFromDatabaseWatched() async {
    final id = await dbHelper.queryRowCountWatched();
    final rowsDeleted = await dbHelper.deleteWatched(widget.Publishment.id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}

class Episode extends StatelessWidget {
  bool flag = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        minWidth: 150,
        color: Colors.blue[800],
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: EdgeInsets.all(8.0),
        splashColor: Colors.blue,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage2('Episodes', flag)));
        },
        child: Text(
          "Episodes",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}

class ActorScroller extends StatelessWidget {
  ActorScroller(this.actors);
  final List<MoviePageCast> actors;

  Widget _buildActor(BuildContext ctx, int index) {
    var actor = actors[index];

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            child: actor.profile_path == null
                ? Icon(Icons.account_circle)
                : ClipOval(
                    child: Image.network(
                      actor.profile_path,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
            radius: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(actor.name),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(actor.character,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lenght = 4;
    if (actors.length > 4) {
      lenght = 4;
    } else {
      lenght = actors.length;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Actors',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        SizedBox.fromSize(
          size: const Size.fromHeight(150.0),
          child: ListView.builder(
            itemCount: lenght,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20.0),
            itemBuilder: _buildActor,
          ),
        ),
      ],
    );
  }
}

class CrewScroller extends StatelessWidget {
  CrewScroller(this.crews);
  final List<MoviePageCrew> crews;

  Widget _buildActor(BuildContext ctx, int index) {
    var crew = crews[index];

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            child: crew.profile_path == null
                ? Icon(Icons.account_circle)
                : ClipOval(
                    child: Image.network(
                    crew.profile_path,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )),
            radius: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(crew.name),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(crew.job,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lenght = 4;
    if (crews.length > 4) {
      lenght = 4;
    } else {
      lenght = crews.length;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Crews',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        SizedBox.fromSize(
          size: const Size.fromHeight(150.0),
          child: ListView.builder(
            itemCount: lenght,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 12.0, left: 20.0),
            itemBuilder: _buildActor,
          ),
        ),
      ],
    );
  }
}

class ProductorScroller extends StatelessWidget {
  ProductorScroller(this.productors);
  final List<MoviePageCompanies> productors;

  Widget _buildProductor(BuildContext ctx, int index) {
    var productor = productors[index];

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            child: productor.logo_path == null
                ? Icon(Icons.movie_creation_outlined)
                : Image.network(
                    productor.logo_path,
                    fit: BoxFit.scaleDown,
                  ),
            radius: 40.0,
            backgroundColor: Colors.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(productor.name),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Productor Companies',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ),
        SizedBox(height: 10.0),
        SizedBox.fromSize(
          size: const Size.fromHeight(120.0),
          child: ListView.builder(
            itemCount: productors.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 12.0, left: 20.0),
            itemBuilder: _buildProductor,
          ),
        ),
      ],
    );
  }
}

/*
class PhotoScroller extends StatelessWidget {
  PhotoScroller(this.photoUrls);
  final List<MoviePagePosters> photoUrls;

  Widget _buildPhoto(BuildContext context, int index) {
    var photo = photoUrls[index];
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.network(
          photo.file_path,
          width: 160.0,
          height: 120.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var blenght = 4;
    if (photoUrls.length > 4) {
      blenght = 4;
    } else {
      blenght = photoUrls.length;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Posters',
          ),
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(100.0),
          child: ListView.builder(
            itemCount: blenght,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 8.0, left: 20.0),
            itemBuilder: _buildPhoto,
          ),
        ),
      ],
    );
  }
}

class BackdropsScroller extends StatelessWidget {
  BackdropsScroller(this.photoUrls);
  final List<MoviePageBackdrops> photoUrls;

  Widget _buildPhoto(BuildContext context, int index) {
    var photo = photoUrls[index];

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.network(
          photo.file_path,
          width: 160.0,
          height: 120.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var blenght = 4;
    if (photoUrls.length > 4) {
      blenght = 4;
    } else {
      blenght = photoUrls.length;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Backdrops',
          ),
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(100.0),
          child: ListView.builder(
            itemCount: blenght,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 8.0, left: 20.0),
            itemBuilder: _buildPhoto,
          ),
        ),
      ],
    );
  }
}
*/

class Poster extends StatelessWidget {
  static const POSTER_RATIO = 0.7;

  Poster(
    this.posterUrl, {
    this.height = 100.0,
  });

  final String posterUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    var width = POSTER_RATIO * height;

    return Material(
      borderRadius: BorderRadius.circular(4.0),
      elevation: 2.0,
      color: Colors.blue,
      child: Image.network(
        posterUrl,
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
    );
  }
}

class RatingInformation extends StatelessWidget {
  RatingInformation(this.movie);
  final MoviePage movie;

  Widget _buildRatingBar(ThemeData theme) {
    var stars = <Widget>[];

    for (var i = 1; i <= 5; i++) {
      var color = i <= (movie.vote_average / 2).round()
          ? theme.accentColor
          : Colors.black12;
      var star = Icon(
        Icons.star,
        color: color,
      );

      stars.add(star);
    }

    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var ratingCaptionStyle = textTheme.caption.copyWith(color: Colors.black45);

    var numericRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          movie.vote_average.toString(),
          style: textTheme.title.copyWith(
            fontWeight: FontWeight.w400,
            color: theme.accentColor,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          'Ratings',
          style: ratingCaptionStyle,
        ),
      ],
    );

    var starRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRatingBar(theme),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        numericRating,
        SizedBox(width: 16.0),
        starRating,
      ],
    );
  }
}

class Storyline extends StatelessWidget {
  Storyline(this.storyline);
  final String storyline;

  @override
  Widget build(BuildContext context) {
    //var theme = Theme.of(context);
    //var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Story line',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )
            // style: textTheme.subhead.copyWith(fontSize: 18.0),
            ),
        SizedBox(height: 8.0),
        new Container(
          child: new DescriptionTextWidget(text: storyline),
        ),
      ],
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({@required this.text});

  @override
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 70) {
      firstHalf = widget.text.substring(0, 50);
      secondHalf = widget.text.substring(50, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? new Text(firstHalf)
          : new Column(
              children: <Widget>[
                new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf)),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        flag ? "show more" : "show less",
                        style: new TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

class Genres extends StatelessWidget {
  Genres(this.movie);
  final MoviePage movie;

  List<Widget> _buildCategoryChips() {
    return movie.genres.map((category) {
      return Expanded(
          child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Chip(
          label: Text(category.name),
          backgroundColor: Colors.black12,
        ),
      ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Genres',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          //style: textTheme.subhead.copyWith(fontSize: 18.0),
        ),
        SizedBox(height: 8.0),
        Row(children: _buildCategoryChips()),
      ],
    );
  }
}
