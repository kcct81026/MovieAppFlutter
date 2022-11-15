import 'package:flutter/material.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/credit_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/movie_data_agent.dart';
import 'package:movie_app/network/retrofit_data_agent_impl.dart';

import '../persistence/daos/actor_dao.dart';
import '../persistence/daos/genre_dao.dart';
import '../persistence/daos/movie_dao.dart';
import 'movie_model.dart';
import 'package:rxdart/rxdart.dart';

class MovieModelImpl extends MovieModel{

  MovieDataAgent mDataAgent = RetrofitDataAgentImpl();

  static final MovieModelImpl _singleton = MovieModelImpl._internal();

  factory MovieModelImpl(){
    return _singleton;
  }


  MovieModelImpl._internal();

  // Daos
  MovieDao mMovieDao = MovieDao();
  ActorDao mActorDao = ActorDao();
  GenreDao mGenreDao = GenreDao();
  @override
  void getNowPlayingMovies(int page) {
    // return mDataAgent.getNowPlayingMovies(page);
    mDataAgent.getNowPlayingMovies(page)?.then((movies) async{

      debugPrint("now playing MovieModelImpl async database ${movies.length}");
      List<MovieVO> nowPlayingMovies = movies.map((movie){
        movie.isNowPlaying = true;
        movie.isPopular = false;
        movie.isTopRated = false;
        return movie;
      }).toList();

      mMovieDao.saveMovies(nowPlayingMovies);

    }).catchError((error){
      debugPrint("now playing MovieModelImpl async database error ${error.toString()}");
    });
  }

  @override
  void getPopularMovies(int page) {
    // return mDataAgent.getPopularMovies(page);
    mDataAgent.getPopularMovies(page)?.then((movies) {
      List<MovieVO> popularMovies = movies.map((movie){
        movie.isTopRated = false;
        movie.isPopular = true;
        movie.isNowPlaying = false;
        return movie;
      }).toList();
      mMovieDao.saveMovies(popularMovies);
    });
  }

  @override
  void getTopRatedMovies(int page) {

    // return mDataAgent.getTopRatedMovies(page);
    mDataAgent.getTopRatedMovies(page)?.then((movies) async{
      List<MovieVO> topRatedMovies = movies.map((movie) {
        movie.isNowPlaying = false;
        movie.isPopular = false;
        movie.isTopRated = true;
        return movie;
      }).toList();
      mMovieDao.saveMovies(topRatedMovies);
    });
  }

  @override
  Future<List<GenreVO>>? getGenres() {
    // return mDataAgent.getGenres();
    return mDataAgent.getGenres()?.then((genres){
      mGenreDao.saveAllGenres(genres);
      return Future.value(genres);
    });
  }

  @override
  Future<List<MovieVO>>? getMoviesByGenre(int genreId) {
    return mDataAgent.getMoviesByGenre(genreId);
  }


  @override
  Future<List<ActorVO>>? getActors(int page) {
    return mDataAgent.getActors(page)?.then((actors){
      mActorDao.saveAllActors(actors);
      return Future.value(actors);
    });
  }

  @override
  Future<List<CreditVO>>? getCreditsByMovie(int movieId) {
    return mDataAgent.getCreditsByMovie(movieId);
  }

  @override
  Future<MovieVO>? getMovieDetails(int movieId) {
    return mDataAgent.getMovieDetails(movieId)?.then((movie) async{
      mMovieDao.saveSingleMovie(movie);
      return Future.value(movie);
    });
  }

  // Database

  @override
  Future<List<ActorVO>>? getActorsFromDatabase() {
    this.getActors(1);
    return mActorDao
        .getActorssEventStream()
        .startWith(mActorDao.getActorsStream())
    .map((event) => mActorDao.getAllActors())
    .first;
  }

  @override
  Future<List<GenreVO>>? getGenresFromDatabase() {
    //return Future.value(mGenreDao.getAllGenres());
    this.getGenres();
    return mGenreDao.getGenresEventStream()
        .startWith(mGenreDao.getGenresStream())
        .map((event) => mGenreDao.getAllGenres())
        .first;
  }

  @override
  Future<MovieVO>? getMovieDetailsFromDatabase(int movieId) {
    return Future.value(mMovieDao.getMovieById(movieId));
  }

  @override
  Future<List<MovieVO>>? getNowPlayingMoviesFromDatabase() {
    this.getNowPlayingMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getNowPlayingMoviesStream())
        .map((event) => mMovieDao.getNowPlayingMovie()).first;

  }

  @override
  Future<List<MovieVO>>? getPopularMoviesFromDatabase() {
    this.getPopularMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getPopularMoviesStream())
        .map((event) => mMovieDao.getPopularMovie()).first;

  }

  @override
  Future<List<MovieVO>>? getTopRatedMoviesFromDatabase() {
    this.getTopRatedMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getTopRatedMoviesStream())
        .map((event) => mMovieDao.getTopRatedMovie()).first;

  }

  ///Reactive Programming
  @override
  Stream<List<MovieVO>> getNowPlayingMoviesFromDatabaseReactive() {
    this.getNowPlayingMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getNowPlayingMoviesStream())
        .map((event) => mMovieDao.getNowPlayingMovie());

  }

  @override
  Stream<List<MovieVO>> getNowTopRelatedMoviesFromDatabaseReactive() {
    this.getTopRatedMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getTopRatedMoviesStream())
        .map((event) => mMovieDao.getTopRatedMovie());
  }

  @override
  Stream<List<MovieVO>> getPopularMoviesFromDatabaseReactive() {
    this.getPopularMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getPopularMoviesStream())
        .map((event) => mMovieDao.getPopularMovie());
  }


}