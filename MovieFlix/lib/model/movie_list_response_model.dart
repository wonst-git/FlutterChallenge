import 'package:movie_flix/model/movie_simple_model.dart';

class MovieListResponseModel {
  final int page;
  final List<MovieSimpleModel> results;
  final int totalPages;
  final int totalResults;

  MovieListResponseModel({required this.page, required this.results, required this.totalPages, required this.totalResults});

  MovieListResponseModel.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        results = [for (var movie in json['results']) MovieSimpleModel.fromJson(movie)],
        totalPages = json['total_pages'],
        totalResults = json['total_results'];

  @override
  String toString() => "page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults";
}
