import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:movie_flix/repository/movie_repository.dart';

import '../model/movie_detail_model.dart';

class MovieDetailViewModel extends ChangeNotifier {
  MovieDetailViewModel() {
    _movieApiRepository = MovieApiRepository();
  }

  late final MovieApiRepository _movieApiRepository;

  StreamController<MovieDetailModel> movieDetail = StreamController();

  void getMovieDetail(int id) async {
    var result = await _movieApiRepository.getDetailMovie(id);

    movieDetail.add(result);
  }
}
