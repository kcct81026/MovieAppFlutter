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
  Future<List<MovieVO>>? getNowPlayingMovies(int page) {
    return mDataAgent.getNowPlayingMovies(page)?.then((movies) async{
      List<MovieVO> nowPlayingMovies = movies.map((movie){
        movie.isNowPlaying = true;
        movie.isPopular = false;
        movie.isTopRated = false;
      }).cast<MovieVO>().toList();

      mMovieDao.saveMovies(nowPlayingMovies);
      return Future.value(movies);
    });
  }

  @override
  Future<List<MovieVO>>? getPopularMovies(int page) {
    return mDataAgent.getPopularMovies(page)?.then((movies) {
      List<MovieVO> popularMovies = movies.map((movie){
        movie.isTopRated = false;
        movie.isPopular = true;
        movie.isNowPlaying = false;
      }).cast<MovieVO>().toList();
      mMovieDao.saveMovies(popularMovies);
      return Future.value(movies);
    });
  }

  @override
  Future<List<MovieVO>>? getTopRatedMovies(int page) {
    return mDataAgent.getTopRatedMovies(page)?.then((movies) async{
        List<MovieVO> topRatedMovies = movies.map((movie) {
          movie.isNowPlaying = false;
          movie.isPopular = false;
          movie.isTopRated = true;
        }).cast<MovieVO>().toList();
        mMovieDao.saveMovies(topRatedMovies);
        return Future.value(movies);
    });
  }

  @override
  Future<List<GenreVO>>? getGenres() {
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
  Future<List<ActorVO>> getActorsFromDatabase() {
    return Future.value(mActorDao.getAllActors());
  }

  @override
  Future<List<GenreVO>> getGenresFromDatabase() {
    return Future.value(mGenreDao.getAllGenres());
  }

  @override
  Future<MovieVO>? getMovieDetailsFromDatabase(int movieId) {
    return Future.value(mMovieDao.getMovieById(movieId));
  }

  @override
  Future<List<MovieVO>> getNowPlayingMoviesFromDatabase() {
    return Future.value(
      mMovieDao
      .getAllMovies()
          .where((movie) => movie.isNowPlaying == true )
          .toList()
    );
  }

  @override
  Future<List<MovieVO>> getPopularMoviesFromDatabase() {
    return Future.value(
      mMovieDao
      .getAllMovies()
          .where((movie) => movie.isPopular == true)
          .toList()
    );
  }

  @override
  Future<List<MovieVO>> getTopRatedMoviesFromDatabase() {
    return Future.value(
        mMovieDao
            .getAllMovies()
            .where(
                (movie) => movie.isTopRated == true
        ).toList());
  }






}