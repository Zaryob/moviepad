import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

final String API_KEY="";

Future<List<MoviePageGenre>> fetchCategories(http.Client client) async {
  final response = await client.get(
      'https://api.themoviedb.org/3/genre/movie/list?api_key=$API_KEY');
  return compute(parseCategories, response.body);
}

List<MoviePageGenre> parseCategories(String responseBody) {
  //print(responseBody);
  final parsed = jsonDecode(responseBody)['genres'].cast<Map<String, dynamic>>();
  //print(parsed);
  return parsed.map<MoviePageGenre>((json) => MoviePageGenre.fromJson(json)).toList();
}


Future<List<Publish>> searchMovies(http.Client client, String keyword) async {
  String query = keyword.replaceAll(RegExp(' '), '+');
  final response = await client.get(
      'https://api.themoviedb.org/3/search/movie?api_key=$API_KEY&language=en-US&page=1&query=$query');

  if (response.statusCode == 200) {
    print(response.body);
    return compute(parseMovies, response.body);
  } else {
    throw Exception('Something went wrong !');
  }
}


Future<List<Publish>> fetchMovies(http.Client client) async {
  final response = await client.get(
      'https://api.themoviedb.org/3/trending/movie/day?api_key=$API_KEY');
  return compute(parseMovies, response.body);
}

Future<List<Publish>> fetchCategoryMovies(http.Client client, int id) async {
  //  'https://api.themoviedb.org/3/trending/movie/day?api_key=$API_KEY'
  final response = await client.get(
      'https://api.themoviedb.org/3/discover/movie?api_key=$API_KEY&with_genres=${id}');
  //print(response.body);
  return compute(parseMovies, response.body);

}


List<Publish> parseMovies(String responseBody) {
  //print(responseBody);
  final parsed =
      jsonDecode(responseBody)['results'].cast<Map<String, dynamic>>();
  //print(parsed);
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
  Publish(
      {this.media_type,
      this.id,
      this.title,
      this.backdrop_path,
      this.overview,
      this.poster_path,
      this.vote_average,
      this.release_date});

  factory Publish.fromJson(Map<String, dynamic> ftMovie) {
    String _title = "";
    if (ftMovie['original_title'] != null) {
      _title = ftMovie['original_title'] as String;
    } else {
      _title = ftMovie['original_name'] as String;
    }
    return Publish(
      media_type: ftMovie['media_type'] as String,
      id: ftMovie['id'] as int,
      title: _title,
      backdrop_path: 'https://image.tmdb.org/t/p/original/' +
          ftMovie['backdrop_path'] as String,
      overview: ftMovie['overview'] as String,
      poster_path: 'https://image.tmdb.org/t/p/original/' +
          ftMovie['poster_path'] as String,
      vote_average: double.parse(ftMovie["vote_average"].toString()) as double,
      release_date: ftMovie['release_date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'media_type': media_type,
      'title': title,
      'backdrop_path':backdrop_path,
      'overview':overview,
      'poster_path':poster_path,
      'vote_average':vote_average,
      'release_date':release_date,
    };
  }
}

Future<MoviePage> fetchMovieDetails(http.Client client, int movie_id) async {
  /*
  String jsonString = await _loadAStudentAsset();
  final jsonResponse = json.decode(jsonString);
  Student student = new Student.fromJson(jsonResponse);
  print(student.studentScores);
   */

  final response = await client.get('https://api.themoviedb.org/3/movie/' +
      movie_id.toString() +
      '?api_key=$API_KEY&language=en-US&append_to_response=credits');
  return MoviePage.fromJson(json.decode(response.body));
}

class MoviePage {
  final int id;
  final String name;
  final String backdrop_path;
  final String poster_path;
  final String title;
  final String tagline;
  final String overview;

  final String release_date;
  final double vote_average;
  final String status;
  final List<MoviePageGenre> genres;
  final List<MoviePageCompanies> production_companies;
  // final MoviePageImages images;

  final MoviePageCredits credits;
  MoviePage(
      {this.id,
      this.name,
      this.genres,
      this.backdrop_path,
      this.poster_path,
      this.title,
      this.tagline,
      this.overview,
      this.release_date,
      this.vote_average,
      this.status,
      this.production_companies,
      this.credits,
     // this.images,
      });

  factory MoviePage.fromJson(Map<String, dynamic> parsedJson) {
    List<MoviePageGenre> _genres;

    if (parsedJson['genres'] != null) {
      var genreObjsJson = parsedJson['genres'] as List;
      _genres = genreObjsJson
          .map((tagJson) => MoviePageGenre.fromJson(tagJson))
          .toList();
    } else {
      _genres = [];
    }


    List<MoviePageCompanies> _companies;
    if (parsedJson['production_companies'] != null) {
      var companiesObjsJson = parsedJson['production_companies'] as List;
      _companies = companiesObjsJson
          .map((tagJson) => MoviePageCompanies.fromJson(tagJson))
          .toList();
    } else {
      _companies = [];
    }

    return MoviePage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      // backdrop_path: parsedJson['backdrop_path'],
      backdrop_path: parsedJson['backdrop_path']==null ? null : 'https://image.tmdb.org/t/p/original/' +
          parsedJson['backdrop_path'] as String,
      //poster_path: parsedJson['poster_path'],
      poster_path: parsedJson['poster_path']==null ? null :'https://image.tmdb.org/t/p/original/' +
          parsedJson['poster_path'] as String,
      title: parsedJson['original_title'] as String,
      tagline: parsedJson['tagline'] as String,
      overview: parsedJson['overview'] as String,
      release_date: parsedJson['release_date'] as String,
      vote_average: double.parse(parsedJson["vote_average"].toString()) as double,
      status: parsedJson['status'] as String,
      genres: _genres,
      production_companies: _companies,
      credits: MoviePageCredits.fromJson(parsedJson['credits']),
     // images: MoviePageImages.fromJson(parsedJson['images']),
    );
  }
}

class MoviePageGenre {
  final int id;
  final String name;

  MoviePageGenre({this.id, this.name});

  factory MoviePageGenre.fromJson(Map<String, dynamic> parsedJson) {
    return MoviePageGenre(id: parsedJson['id'], name: parsedJson['name']);
  }
}

class MoviePageCompanies {
  final int id;
  final String name;
  final String logo_path;

  MoviePageCompanies({this.id, this.name, this.logo_path});

  factory MoviePageCompanies.fromJson(Map<String, dynamic> parsedJson) {
    return MoviePageCompanies(
      id: parsedJson['id'],
      name: parsedJson['name'],
      logo_path: parsedJson['logo_path'] == null ? null: 'https://image.tmdb.org/t/p/original/' + parsedJson['logo_path'],
    );
  }
}

class MoviePageCredits{
  final List<MoviePageCast> cast;
  final List<MoviePageCrew> crew;
  MoviePageCredits({this.cast, this.crew});

  factory MoviePageCredits.fromJson(Map<String, dynamic> parsedJson) {
    //print(parsedJson['cast']);
    return MoviePageCredits(
          cast: (parsedJson['cast'] as List).map((i) => MoviePageCast.fromJson(i)).toList(),
          crew: (parsedJson['crew'] as List).map((i) => MoviePageCrew.fromJson(i)).toList(),
        );
  }
}
class MoviePageCast {
  final int id;
  final String name;
  final String character;
  final String profile_path;
  MoviePageCast({this.id, this.name, this.character, this.profile_path});

  factory MoviePageCast.fromJson(Map<String, dynamic> parsedJson) {
    //print(parsedJson['original_name']);
    return MoviePageCast(
      id: parsedJson['id'],
      name: parsedJson['original_name'],
      character: parsedJson['character'],
      profile_path: parsedJson['profile_path'] == null ? null: 'https://image.tmdb.org/t/p/original/' + parsedJson['profile_path'],
    );
  }
}

class MoviePageCrew {
  final int id;
  final String name;
  final String job;
  final String profile_path;

  MoviePageCrew({this.id, this.name, this.job, this.profile_path});
  factory MoviePageCrew.fromJson(Map<String, dynamic> parsedJson) {
    return MoviePageCrew(
      id: parsedJson['id'],
      name: parsedJson['original_name'],
      job: parsedJson['job'],
      profile_path: parsedJson['profile_path'] == null ? null: 'https://image.tmdb.org/t/p/original/' + parsedJson['profile_path'],
    );
  }
}

/*
class MoviePageImages{
  final List<MoviePageBackdrops> backdrops;
  final List<MoviePagePosters> posters;
  MoviePageImages({this.backdrops, this.posters});

  factory MoviePageImages.fromJson(Map<String, dynamic> parsedJson) {
    return MoviePageImages(
      backdrops: (parsedJson['backdrops'] as List).map((i) => MoviePageBackdrops.fromJson(i)).toList(),
      posters: (parsedJson['posters'] as List).map((i) => MoviePagePosters.fromJson(i)).toList(),
    );
  }
}

class MoviePageBackdrops {
  final String file_path;
  MoviePageBackdrops({this.file_path});

  factory MoviePageBackdrops.fromJson(Map<String, dynamic> parsedJson) {
    return MoviePageBackdrops(
      file_path: parsedJson['file_path'] == null ? null: 'https://image.tmdb.org/t/p/original/' + parsedJson['file_path'],
    );
  }
}

class MoviePagePosters {
  final String file_path;
  MoviePagePosters({this.file_path});

  factory MoviePagePosters.fromJson(Map<String, dynamic> parsedJson) {
    return MoviePagePosters(
      file_path: parsedJson['file_path'] == null ? null: 'https://image.tmdb.org/t/p/original/' + parsedJson['file_path'],
    );
  }
}


 */
