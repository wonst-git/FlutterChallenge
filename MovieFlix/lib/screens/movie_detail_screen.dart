import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_flix/screens/movie_detail_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatefulWidget {
  static const String screenId = '/movieDetailScreen';

  const MovieDetailScreen({super.key, required this.arguments});

  final Map<String, dynamic> arguments;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final MovieDetailViewModel viewModel = MovieDetailViewModel();

  String makeImageUrl(String path) => 'https://image.tmdb.org/t/p/w500/$path';

  @override
  void initState() {
    viewModel.getMovieDetail(widget.arguments['id']);

    super.initState();
  }

  void openUrl(String strUrl) async {
    var url = Uri.parse(strUrl);

    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    var type = widget.arguments['type'];
    var imageUrl = widget.arguments['imageUrl'];
    var title = widget.arguments['title'];

    return Stack(fit: StackFit.expand, children: [
      Hero(
        tag: type + imageUrl,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          titleSpacing: 0,
          title: const Text(
            'Back to list',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: false,
        ),
        body: StreamBuilder(
          stream: viewModel.movieDetail.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              var movie = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: type + title,
                      child: Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 38,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (var i = 0; i < 10; i++)
                          movie.voteAverage - i >= 1
                              ? const Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.yellow,
                                )
                              : movie.voteAverage - i > 0
                                  ? const Icon(
                                      Icons.star_half_rounded,
                                      color: Colors.yellow,
                                    )
                                  : const Icon(
                                      Icons.star_border_rounded,
                                      color: Colors.yellow,
                                    ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '(${movie.voteAverage})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${movie.runtime ~/ 60}h ${movie.runtime % 60}min | ${movie.genres.map((e) => e.name).join(', ')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Storyline',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      movie.overview,
                      style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      widthFactor: 4,
                      child: FilledButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(const Size(220, 50)),
                          backgroundColor: MaterialStateProperty.all(Colors.yellow),
                          foregroundColor: MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          openUrl(movie.homepage);
                        },
                        child: const Text('Go Homepage'),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      )
    ]);
  }

  @override
  void dispose() {
    viewModel.movieDetail.close();
    super.dispose();
  }
}
