import 'package:dio/dio.dart';
import 'package:movie_flix/model/movie_detail_model.dart';
import 'package:movie_flix/model/movie_list_response_model.dart';
import 'package:movie_flix/model/movie_simple_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';

part 'api_service.g.dart';

const baseUrl = 'https://movies-api.nomadcoders.workers.dev/';
const popularMovies = 'popular';
const playingMovies = 'now-playing';
const comingSoonMovies = 'coming-soon';
const detailMovie = 'movie';

final client = ApiService(Dio()..interceptors.add(PrettyDioLogger()));

@RestApi(baseUrl: baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET(popularMovies)
  Future<MovieListResponseModel> getPopularMovies();

  @GET(playingMovies)
  Future<MovieListResponseModel> getPlayingMovies();

  @GET(comingSoonMovies)
  Future<MovieListResponseModel> getComingSoonMovies();

  @GET(detailMovie)
  Future<MovieDetailModel> getMovieDetail(@Query('id') int id);
}
