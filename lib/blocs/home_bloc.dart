import 'dart:async';

import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';

import '../data/models/movie_model.dart';
import '../data/models/movie_model_impl.dart';

class HomeBloc{

  // Reactive Streams
  late StreamController<List<MovieVO>> mNowPlayingStreamController = StreamController();
  late StreamController<List<MovieVO>> mPopularMovieListStreamController = StreamController();
  late StreamController<List<GenreVO>> mGenreListStreamController = StreamController();
  late StreamController<List<MovieVO>> mTopRatedListStreamController = StreamController();
  late StreamController<List<ActorVO>> mActorStreamController = StreamController();
  late StreamController<List<MovieVO>> mMovieByGenreListStreamController = StreamController();

  //Models
  MovieModel mMovieModel = MovieModelImpl();

  HomeBloc(){
    /// Now Playing Movies From Database
    mMovieModel.getNowPlayingMoviesFromDatabase()?.then((movieList) {
      mNowPlayingStreamController.sink.add(movieList);
    }).catchError((error){});

    /// Popular Movies From Database
    mMovieModel.getPopularMoviesFromDatabase()?.then((popularMovies){
      mPopularMovieListStreamController.sink.add(popularMovies);
    }).catchError((error){});

    /// Genres
    mMovieModel.getGenresFromDatabase()?.then((genres){
      mGenreListStreamController.sink.add(genres);

      /// Movies By Genre
      getMoviesByGenreAndRefresh(genres.first.id);
    });

    /// Top Rated Movies From Databse
    mMovieModel.getTopRatedMoviesFromDatabase()?.then((topRatedMovies){
      mTopRatedListStreamController.sink.add(topRatedMovies);
    });

    /// Actors From Database
    mMovieModel.getActorsFromDatabase()?.then((actors){
      mActorStreamController.sink.add(actors);
    });
  }

  void getMoviesByGenreAndRefresh(int genreId){
    mMovieModel.getMoviesByGenre(genreId)?.then((movieByGenres){
      mMovieByGenreListStreamController.sink.add(movieByGenres);
    });
  }
  void dispose(){
    mNowPlayingStreamController.close();
    mPopularMovieListStreamController.close();
    mGenreListStreamController.close();
    mTopRatedListStreamController.close();
    mActorStreamController.close();
    mMovieByGenreListStreamController.close();
  }
}