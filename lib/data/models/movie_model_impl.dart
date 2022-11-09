import 'dart:math';

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


  MovieModelImpl._internal(){
    getNowPlayingMoviesFromDatabase();
    getPopularMoviesFromDatabase();
    getTopRatedMoviesFromDatabase();
    getActors(1);
    getActorsFromDatabase();
    getGenres();
    getGenresFromDatabase();
  }

  // Daos
  MovieDao mMovieDao = MovieDao();
  ActorDao mActorDao = ActorDao();
  GenreDao mGenreDao = GenreDao();


  // Home Page State
  List<MovieVO> mNowPlayingMovieList = [];
  List<MovieVO> mPopularMovieList = [];
  List<MovieVO> mShowCaseMovieList = [];
  List<GenreVO> mGenreList = [];
  List<MovieVO> mMoviesByGenreList = [];
  List<ActorVO> mActors = [];


  // Movie Details Page State
  MovieVO? mMovie;
  List<CreditVO> mActorList = [];
  List<CreditVO> mCreatorsList = [];

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
      mNowPlayingMovieList = nowPlayingMovies;
      notifyListeners();

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
      mPopularMovieList = popularMovies;
      notifyListeners();
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
      mShowCaseMovieList = topRatedMovies;
      notifyListeners();
    });
  }

  @override
  void getGenres() {
    // return mDataAgent.getGenres();
    mDataAgent.getGenres()?.then((genres){
      mGenreDao.saveAllGenres(genres);
      mGenreList = genres;
      notifyListeners();
      getMoviesByGenre(genres.first.id);

    });
  }

  @override
  void getMoviesByGenre(int genreId) {
    mDataAgent.getMoviesByGenre(genreId)
        ?.then((movieList) {
          mMoviesByGenreList = movieList;
          notifyListeners();
    });
  }


  @override
  void getActors(int page) {
    mDataAgent.getActors(page)?.then((actors){
      mActorDao.saveAllActors(actors);
      mActors = actors;
      notifyListeners();
    });
  }

  @override
  void getCreditsByMovie(int movieId) {
    mDataAgent.getCreditsByMovie(movieId)
        ?.then((creditList) {
      this.mActorList = creditList.where((credit) => credit.isActor()).toList();
      this.mCreatorsList = creditList.where((credit) => credit.isCreator()).toList();
      notifyListeners();
    });
  }

  @override
  void getMovieDetails(int movieId) {
    mDataAgent.getMovieDetails(movieId)?.then((movie) async{
      mMovieDao.saveSingleMovie(movie);
      mMovie = movie;
      notifyListeners();
    });
  }

  // Database

  @override
  void getActorsFromDatabase() {
    mActors = mActorDao.getAllActors();
    notifyListeners();
    /*this.getActors(1);
    mActorDao
        .getActorssEventStream()
        .startWith(mActorDao.getActorsStream())
    .map((event) => mActorDao.getAllActors())
    .listen((actors){
      mActors = actors;
      notifyListeners();
    });*/
   // return Future.value(mActorDao.getAllActors());
  }

  @override
  void getGenresFromDatabase() {
    mGenreList = mGenreDao.getAllGenres();
    notifyListeners();
   /* this.getGenres();
    mGenreDao.getGenresEventStream()
    .startWith(mGenreDao.getGenresStream())
    .map((event) => mGenreDao.getAllGenres())
    .listen((genres) {
      mGenreList = genres;
      print("-------------------------------------mGenreList 81026 ${mGenreList.length}");

      getMoviesByGenre(genres.first.id);
      notifyListeners();
    });*/
  }

  @override
  void getMovieDetailsFromDatabase(int movieId) {
    mMovie = mMovieDao.getMovieById(movieId);
    notifyListeners();
  }

  @override
  void getNowPlayingMoviesFromDatabase() {
    this.getNowPlayingMovies(1);
    mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getNowPlayingMoviesStream())
        .map((event) => mMovieDao.getNowPlayingMovie())
    .listen((nowPlayingMovies) {
      mNowPlayingMovieList  = nowPlayingMovies;
      print("-------------------------------------mNowPlayingMovieList 81026 ${mNowPlayingMovieList.length}");
      notifyListeners();
    });
  /*  return Future.value(
        mMovieDao
            .getAllMovies()
            .where((movie) => movie.isNowPlaying == true )
            .toList()
    );*/
  }

  @override
  void getPopularMoviesFromDatabase() {
    this.getPopularMovies(1);
    mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getPopularMoviesStream())
        .map((event) => mMovieDao.getPopularMovie())
    .listen((popularMovies) {
      mPopularMovieList = popularMovies;
      print("-------------------------------------mPopularMovieList 81026 ${mPopularMovieList.length}");

      notifyListeners();
    });
    /*return Future.value(
        mMovieDao
            .getAllMovies()
            .where((movie) => movie.isPopular == true)
            .toList()
    );*/
  }

  @override
  void getTopRatedMoviesFromDatabase() {
    this.getTopRatedMovies(1);
    mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getTopRatedMoviesStream())
        .map((event) => mMovieDao.getTopRatedMovie())
    .listen((topRatedMovies) {
      mShowCaseMovieList = topRatedMovies;
      print("-------------------------------------mShowCaseMovieList 81026 ${mShowCaseMovieList.length}");

      notifyListeners();
    });
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