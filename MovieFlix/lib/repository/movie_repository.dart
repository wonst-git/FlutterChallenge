import 'package:movie_flix/model/movie_detail_model.dart';
import 'package:movie_flix/service/api_service.dart';

import '../model/movie_list_response_model.dart';
import '../model/movie_simple_model.dart';

class MovieApiRepository {
  Future<MovieListResponseModel> getPopularMovies() => client.getPopularMovies();

  Future<MovieListResponseModel> getPlayingMovies() => client.getPlayingMovies();

  Future<MovieListResponseModel> getComingSoonMovies() => client.getComingSoonMovies();

  Future<MovieDetailModel> getDetailMovie(int id) => client.getMovieDetail(id);
}
