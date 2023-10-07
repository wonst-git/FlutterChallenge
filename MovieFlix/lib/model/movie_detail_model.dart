import 'movie_genre_model.dart';

class MovieDetailModel {
  final bool adult;
  final String backdropPath;
  final int budget;
  final List<MovieGenreModel> genres;
  final String homepage;
  final int id;
  final String imdbId;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final num popularity;
  final String posterPath;
  final String releaseDate;
  final int runtime;
  final String title;
  final bool video;
  final num voteAverage;
  final int voteCount;

  const MovieDetailModel({
    required this.adult,
    required this.backdropPath,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.runtime,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  MovieDetailModel.fromJson(Map<String, dynamic> json)
      : adult = json['adult'],
        backdropPath = json['backdrop_path'],
        budget = json['budget'],
        genres = [for (var genre in json['genres']) MovieGenreModel.fromJson(genre)],
        homepage = json['homepage'],
        id = json['id'],
        imdbId = json['imdb_id'],
        originalLanguage = json['original_language'],
        originalTitle = json['original_title'],
        overview = json['overview'],
        popularity = json['popularity'],
        posterPath = json['poster_path'],
        releaseDate = json['release_date'],
        runtime = json['runtime'],
        title = json['title'],
        video = json['video'],
        voteAverage = json['vote_average'],
        voteCount = json['vote_count'];

  @override
  String toString() => "adult: $adult, backdropPath: $backdropPath, budget: $budget, genres: $genres, id: $id, imdbId: $imdbId, originalLanguage: $originalLanguage, originalTitle: $originalTitle, "
      "overview: $overview, popularity: $popularity, posterPath: $posterPath, releaseDate: $releaseDate, runtime: $runtime, title: $title, video: $video, voteAverage: $voteAverage, voteCount: $voteCount";
}
