import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_flix/screens/movie_detail_screen.dart';
import 'package:movie_flix/screens/movie_list_view_model.dart';

class MovieListScreen extends StatefulWidget {
  static const String screenId = '/movieListScreen';

  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final MovieListViewModel viewModel = MovieListViewModel();

  String makeImageUrl(String path) => 'https://image.tmdb.org/t/p/w500/$path';

  void onPressed(BuildContext context, int id, String type, String imageUrl, String title) {
    Navigator.of(context).pushNamed(
      MovieDetailScreen.screenId,
      arguments: {
        'id': id,
        'type': type,
        'imageUrl': imageUrl,
        'title': title,
      },
    );
  }

  @override
  void initState() {
    viewModel.getPopularMovieList();
    viewModel.getPlayingMovieList();
    viewModel.getComingSoonMovieList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(
                height: 40,
              ),
              const TitleTextWidget(title: 'Popular Movies'),
              StreamBuilder(
                stream: viewModel.popularMovies.stream,
                builder: (context, snapshot) {
                  // print('popularMovies: ${widget.viewModel.popularMovies.stream.last}');
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        var imageUrl = makeImageUrl(snapshot.data![index].posterPath);
                        var id = snapshot.data![index].id;
                        var title = snapshot.data![index].title;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PopularWidget(
                            imageUrl: imageUrl,
                            type: 'popular',
                            onPressed: () {
                              onPressed(context, id, 'popular', imageUrl, title);
                            },
                          ),
                        );
                      },
                      itemCount: snapshot.data?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                    ),
                  );
                },
              ),
              const TitleTextWidget(title: 'Now In Cinemas'),
              StreamBuilder(
                stream: viewModel.playingMovies.stream,
                builder: (context, snapshot) {
                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        var imageUrl = makeImageUrl(snapshot.data![index].posterPath);
                        var title = snapshot.data![index].title;
                        var id = snapshot.data![index].id;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MovieWidget(
                            imageUrl: imageUrl,
                            title: title,
                            type: 'playing',
                            onPressed: () {
                              onPressed(context, id, 'playing', imageUrl, title);
                            },
                          ),
                        );
                      },
                      itemCount: snapshot.data?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                    ),
                  );
                },
              ),
              const TitleTextWidget(title: 'Coming Soon'),
              StreamBuilder(
                stream: viewModel.comingSoonMovies.stream,
                builder: (context, snapshot) {
                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        var imageUrl = makeImageUrl(snapshot.data![index].posterPath);
                        var title = snapshot.data![index].title;
                        var id = snapshot.data![index].id;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MovieWidget(
                            imageUrl: imageUrl,
                            title: title,
                            type: 'comingsoon',
                            onPressed: () {
                              onPressed(context, id, 'comingsoon', imageUrl, title);
                            },
                          ),
                        );
                      },
                      itemCount: snapshot.data?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                    ),
                  );
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    viewModel.popularMovies.close();
    viewModel.comingSoonMovies.close();
    viewModel.playingMovies.close();
    super.dispose();
  }
}

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class PopularWidget extends StatelessWidget {
  const PopularWidget({super.key, required this.imageUrl, required this.type, required this.onPressed});

  final String imageUrl, type;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              offset: Offset(3, 3),
              color: Colors.black38,
              blurRadius: 4,
            )
          ],
        ),
        child: Hero(
          tag: type + imageUrl,
          child: Image.network(
            imageUrl,
            width: 300,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class MovieWidget extends StatelessWidget {
  const MovieWidget({super.key, required this.imageUrl, required this.title, required this.type, required this.onPressed});

  final String imageUrl, title, type;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              width: 160,
              height: 160,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: const [
                BoxShadow(
                  offset: Offset(3, 3),
                  color: Colors.black38,
                  blurRadius: 4,
                )
              ]),
              child: Hero(
                tag: type + imageUrl,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Hero(
              tag: type + title,
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
