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
}