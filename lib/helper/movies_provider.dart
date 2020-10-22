import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies/model/movies_model.dart';
import 'package:http/http.dart' as http;

class Movies extends ChangeNotifier {
  List<MovieModel> movieList = [];
  Future<List<MovieModel>> getMovies() async {
    try {
      String url = "https://yts.mx/api/v2/list_movies.json";
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        var dataList = decodedData['data']['movies'];
        for (var data in dataList) {
          MovieModel movies = MovieModel(
            id: data['id'],
            title: data['title'],
            description: data['description_full'],
            rate: data['rating'],
            image: data['large_cover_image'],
          );
          movieList.add(movies);
        }
        print(movieList.length);
      }
    } catch (e) {
      print(e);
    }
    return movieList;
  }

  Future<MovieModel> getMovieDetails({int id}) async {
    MovieModel movie;
    String url = "https://yts.mx/api/v2/movie_details.json?movie_id=$id";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      var details = decodedData['data'];
      movie = MovieModel(
        title: details['movie']['title'],
        rate: details['movie']['rating'],
        description: details['movie']['description_full'],
        image: details['movie']['large_cover_image'],
        genres: details['movie']['genres'],
      );
    }
    print(movie.rate);
    return movie;
  }
}
