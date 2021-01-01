import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

final String API_KEY="";

/*
Future<List<Publish>> fetchAll(http.Client client) async {
  final response =
  await client.get('https://api.themoviedb.org/3/trending/all/day?api_key=$API_KEY');
  return compute(parseMovies, response.body);
}

Future<List<Publish>> fetchSeries(http.Client client) async {
  final response =
  await client.get('https://api.themoviedb.org/3/trending/tv/day?api_key=$API_KEY');
  return compute(parseMovies, response.body);
}*/

Future<List<Publish>> fetchSearchMovies(String rawQuery) async {
  String query = rawQuery.replaceAll(RegExp(' '), '+');
  print(rawQuery);
  final response =
  await http.get('https://api.themoviedb.org/3/search/movie?api_key=$API_KEY&language=en-US&page=1&query='+query);
  //print('https://api.themoviedb.org/3/search/movie?api_key=$API_KEY&language=en-US&page=1&query=$query');
  return compute(parseMovies, response.body);
}
Future<List<Publish>> fetchMovies(http.Client client) async {
  final response =
  await client.get('https://api.themoviedb.org/3/trending/movie/day?api_key=$API_KEY');
  return compute(parseMovies, response.body);
}
List<Publish> parseMovies(String responseBody) {
  final parsed = jsonDecode(responseBody)['results'].cast<Map<String, dynamic>>();

  return parsed.map<Publish>((json) => Publish.fromJson(json)).toList();
}


class Publish {
  final String media_type;
  final int id;
  final String title;
  final String backdrop_path;
  final String overview;
  final String poster_path;
  final double vote_average;
  final String release_date;
  final List<int> genre_ids;
  Publish({this.media_type,this.id, this.title,this.backdrop_path,this.overview,this.poster_path,
    this.vote_average,this.release_date, this.genre_ids});
  factory Publish.fromJson(Map<String, dynamic> ftMovie) {
    return Publish(
      media_type: ftMovie['media_type'] as String,
      id: ftMovie['id']as int,
      title: ftMovie['original_title'],
      backdrop_path: 'https://image.tmdb.org/t/p/original/'+ ftMovie['backdrop_path']as String,
      overview: ftMovie['overview']as String,
      poster_path: 'https://image.tmdb.org/t/p/original/'+ftMovie['poster_path']as String,
      vote_average: ftMovie['vote_average']as double,
      release_date: ftMovie['release_date'] as String,
      genre_ids: List<int>.from(ftMovie['genre_ids'].map((x) => x)),
    );
  }

}




Future<List<MovieDetails>> fetchMoviePage(int movie_id) async {
  final response =  await http.get('https://api.themoviedb.org/3/movie/$movie_id?api_key=$API_KEY&language=en-US');
  return compute(parseMoviesPage, response.body);
}
List<MovieDetails> parseMoviesPage(String responseBody) {
  final parsed = jsonDecode(responseBody)['genres'].cast<Map<String, dynamic>>();
  return parsed.map<MovieDetails>((json) => Publish.fromJson(json)).toList();
}

class MovieDetails {
  final int id;
  final String title;
  //final List<String> genre_ids;
  MovieDetails({this.id,this.title});
  factory MovieDetails.fromJson(Map<String, dynamic> genres) {
    return MovieDetails(
      id: genres['id'] as int,
      title: genres['name'] as String,
    //  genre_ids: List<String>.from(genres['genre_ids'].map((x) => x['name'])),
    );
  }
}

