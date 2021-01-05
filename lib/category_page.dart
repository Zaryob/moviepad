import 'package:flutter/material.dart';
import 'context_page.dart';
import 'imdb.dart';
import 'moviedb.dart';

import 'package:http/http.dart' as http;


class CategoryPage extends StatefulWidget {
  final MoviePageGenre Genre;
  CategoryPage(this.Genre);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.Genre.name),
        centerTitle: true,
      ),
      body: CategoryBody(widget.Genre.id),
    );
  }
}

class CategoryBody extends StatefulWidget {
  final int id;
  CategoryBody(this.id);

  @override
  _CategoryBodyState createState() => _CategoryBodyState();
}

class _CategoryBodyState extends State<CategoryBody> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Publish>>(
      //Initiate the service request
        future: fetchCategoryMovies(http.Client(), widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GenreList(Movies: snapshot.data);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
                child: Icon(
                  Icons.android,
                  size: 220,
                ));
          }
          return Center(child: CircularProgressIndicator());
          /*
          if (snapshot.hasData) {
            //if the response has data render the movie list
            return Expanded(child: GenreList(Movies: snapshot.data));
          }

          //if the service call is in progress show the progress indicator
          return CircularProgressIndicator();
          */
        });
  }
}

class GenreList extends StatelessWidget {
  final List<Publish> Movies;

  GenreList({Key key, this.Movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),*/
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: 20,
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
                                  Text(
                                    Movies[index].title,
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    Movies[index].release_date,
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  Row(
                                    children: [
                                    /*
                                    Text(
                                        Movies[index].vote_average.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.blueAccent,
                                        ),
                                      ),

                                    */
                                      StarDisplayWidget(
                                        value: ((Movies[index].vote_average) / 2).round(),
                                        filledStar: Icon(Icons.star,
                                            color: Colors.orange, size: 28),
                                        unfilledStar: Icon(Icons.star_border,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
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
