import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_flix/model/movie_simple_model.dart';
import 'package:movie_flix/repository/movie_repository.dart';

class MovieListViewModel with ChangeNotifier {
  MovieListViewModel() {
    _movieApiRepository = MovieApiRepository();
  }

  late final MovieApiRepository _movieApiRepository;

  final StreamController<List<MovieSimpleModel>> popularMovies = StreamController();

  final StreamController<List<MovieSimpleModel>> playingMovies = StreamController();

  final StreamController<List<MovieSimpleModel>> comingSoonMovies = StreamController();

  void getPopularMovieList() async {
    var result = await _movieApiRepository.getPopularMovies();

    print("popular: $result");
    popularMovies.add(result.results);
  }

  void getPlayingMovieList() async {
    var result = await _movieApiRepository.getPlayingMovies();

    playingMovies.add(result.results);
  }

  void getComingSoonMovieList() async {
    var result = await _movieApiRepository.getComingSoonMovies();

    comingSoonMovies.add(result.results);
  }
}
