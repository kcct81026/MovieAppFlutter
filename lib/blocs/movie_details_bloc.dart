import 'dart:async';

import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/credit_vo.dart';

import '../data/vos/movie_vo.dart';

class MovieDetailsBloc{

  // StreamControllers
  late StreamController<MovieVO> movieStreamController = StreamController();
  late StreamController<List<CreditVO>> creditStreamController = StreamController();
  late StreamController<List<CreditVO>> actorsStreamController = StreamController();

  // Models
  MovieModel mMovieModel = MovieModelImpl();

  MovieDetailsBloc(int movieId) {
    //  Movie Details
    mMovieModel.getMovieDetails(movieId)?.then((movie){
      movieStreamController.sink.add(movie);
    });

    // Movie Details From Database
    mMovieModel.getMovieDetailsFromDatabase(movieId)?.then((movie){
      movieStreamController.sink.add(movie);
    });

    mMovieModel.getCreditsByMovie(movieId)?.then((creditList){
      actorsStreamController.sink.add(creditList.where((credit) => credit.isActor()).toList());
      creditStreamController.sink.add(creditList.where((credit) => credit.isCreator()).toList());
    });

  }

  void disposeStreams(){
    movieStreamController.close();
    actorsStreamController.close();
    creditStreamController.close();
  }
}