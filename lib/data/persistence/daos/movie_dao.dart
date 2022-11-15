import 'package:hive/hive.dart';
import 'package:movie_app/data/persistence/hive_constants.dart';

import '../../vos/movie_vo.dart';

class MovieDao{
  static final MovieDao _singleton = MovieDao._internal();
  factory MovieDao(){
    return _singleton;
  }
  MovieDao._internal();

  void saveMovies(List<MovieVO> movies) async {
    Map<int, MovieVO> movieMap = Map.fromIterable(movies,
      key: (movie) => movie.id,
      value: (movie) => movie
    );

    await getMovieBox().putAll(movieMap);
  }

  void saveSingleMovie(MovieVO movie) async{
    return getMovieBox().put(movie.id, movie);
  }

  List<MovieVO> getAllMovies(){
    List<MovieVO> movieListFromDatabase = getMovieBox().values.toList();
    return movieListFromDatabase;
  }

  MovieVO? getMovieById(int movieId){
    return getMovieBox().get(movieId);
  }

  Box<MovieVO> getMovieBox(){
    return Hive.box<MovieVO>(BOX_NAME_MOVIE_VO);
  }

  // Reactive Programming
  Stream<void> getAllMoviesEventStream(){
    return getMovieBox().watch();
  }

  Stream<List<MovieVO>> getNowPlayingMoviesStream(){
    return Stream.value(getAllMovies()
      .where((element) => element?.isNowPlaying ?? false )
        .toList());
  }

  Stream<List<MovieVO>> getPopularMoviesStream(){
    return Stream.value(getAllMovies()
      .where((element) => element?.isPopular ?? false)
            .toList());
  }

  Stream<List<MovieVO>> getTopRatedMoviesStream(){
    return Stream.value(getAllMovies()
      .where((element) => element?.isTopRated ?? false)
    .toList());
  }

  List<MovieVO> getNowPlayingMovie() {
    if ((getAllMovies().isNotEmpty )) {
      print("movie_dao getNowPlayingMovew   is not empty  ");
      return getAllMovies().where((movie) => movie?.isNowPlaying ?? false).toList();
    } else {
      print("movie_dao getNowPlayingMovew   is empty  ");

      return [];
    }


  }

  List<MovieVO> getPopularMovie () {
    if ((getAllMovies().isNotEmpty)) {
      print("movie_dao popular   is  not empty  ");
      return getAllMovies().where((movie) => movie?.isPopular ?? false).toList();
    } else {
      print("movie_dao popular   is  empty  ");

      return [];
    }
  }

  List<MovieVO> getTopRatedMovie () {
    if ((getAllMovies().isNotEmpty )) {
      print("movie_dao top rated   is not  empty  ");

      return getAllMovies().where((movie) => movie?.isTopRated ?? false).toList();
    } else {
      print("movie_dao top rated   is  empty  ");

      return [];
    }
  }

}