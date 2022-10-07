import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/pages/movie_details_page.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/resources/strings.dart';
import 'package:movie_app/viewitems/actor_view.dart';
import 'package:movie_app/viewitems/banner_view.dart';
import 'package:movie_app/viewitems/movie_view.dart';
import 'package:movie_app/viewitems/showcase_view.dart';
import 'package:movie_app/widgets/actor_and_creators_section_views.dart';
import 'package:movie_app/widgets/see_more_text.dart';
import 'package:movie_app/widgets/title_text.dart';
import 'package:movie_app/widgets/title_text_with_see_more_view.dart';

import '../data/vos/actor_vo.dart';
import '../data/vos/genre_vo.dart';
import '../data/vos/movie_vo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  MovieModel mMovieModel = MovieModelImpl();

  List<MovieVO> mNowPlayingMovieList = [];
  List<MovieVO> mPopularMovieList = [];
  List<MovieVO> mShowCaseMovieList = [];
  List<GenreVO> mGenreList = [];
  List<MovieVO> mMoviesByGenreList = [];
  List<ActorVO> mActors = [];

  @override
  void initState() {
    super.initState();

    // Now Playing Movies
    mMovieModel.getNowPlayingMovies(1)
    ?.then((movieList){
      setState(() {
        mNowPlayingMovieList = movieList ;
      });

    }).catchError((error){
      debugPrint(error.toString());
    });

    // Now Playing Movies Database
    mMovieModel.getNowPlayingMoviesFromDatabase().then((moviesList){
      setState(() {
        mNowPlayingMovieList = moviesList;
      });
    }).catchError((error){
      debugPrint(error.toString());
    });

    mMovieModel.getPopularMovies(1)
        ?.then((movieList){
      setState(() {
        mPopularMovieList = movieList ;
      });

    }).catchError((error){
      debugPrint(error.toString());
    });
    // Get Popular Movies Database
    mMovieModel.getPopularMoviesFromDatabase().then((moviesList){
      setState(() {
        mNowPlayingMovieList = moviesList;
      });
    }).catchError((error){
      debugPrint(error.toString());
    });

    mMovieModel.getTopRatedMovies(1)
        ?.then((movieList){
      setState(() {
        mShowCaseMovieList = movieList ;
      });

    }).catchError((error){
      debugPrint(error.toString());
    });

    // Top Rated Movies Database
    mMovieModel.getTopRatedMoviesFromDatabase().then((moviesList){
      setState(() {
        mNowPlayingMovieList = moviesList;
      });
    }).catchError((error){
      debugPrint(error.toString());
    });

    mMovieModel.getGenres()
        ?.then((genres) {
      setState(() {
        mGenreList = genres;

        ///// Movies by Genre
        _getMoviesByGenreAndRefresh(genres?.first.id ?? 0);
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    // Get Genre Database
    mMovieModel.getGenresFromDatabase()
        ?.then((genres) {
      setState(() {
        mGenreList = genres;

        ///// Movies by Genre
        _getMoviesByGenreAndRefresh(genres?.first.id ?? 0);
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });


    mMovieModel.getActors(1)
        ?.then((actors) {
      setState(() {
        mActors = actors ;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    // Get Actors From Database
    mMovieModel.getActorsFromDatabase()
        ?.then((actors) {
      setState(() {
        mActors = actors ;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void _getMoviesByGenreAndRefresh(int genreId){
    mMovieModel.getMoviesByGenre(genreId)
        ?.then((movies) {
      setState(() {
        mMoviesByGenreList = movies ;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        title: Text(
          MAIN_SCREEN_APP_BAR_TITLE,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w700
          ),
        ),
        leading: Icon(
            Icons.menu
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 0,
              bottom: 0,
              right: MARGIN_MEDIUM_2,
            ) ,
            child: Icon(
                Icons.search
            ),
          )
        ],
      ),
      body: Container(
        color: HOME_SCREEN_BACKGROUND_COLOR,
        child: SingleChildScrollView(
          child: Column(
            children: [
              (mPopularMovieList != null) ?
              BannerSectionView(
                  mPopularMovieList.take(10).toList(),
                    (movieId) => _navigateToMovieDetailsScreen(context, movieId),
              ) : Center(child: CircularProgressIndicator(),) ,
              SizedBox(height: MARGIN_LARGE,),
              BestPopularMoviesAndSeriesSectionView(
                    (movieId) => _navigateToMovieDetailsScreen(context, movieId),
                mNowPlayingMovieList
              ),
              SizedBox(height: MARGIN_LARGE,),
              MovieShowTimeSectionView(),
              SizedBox(height: MARGIN_LARGE,),
              GenreSectionView(
                mGenreList: mGenreList,
                mMoviesListByGenre: mMoviesByGenreList,
                onTapMovie: (movieId) => _navigateToMovieDetailsScreen(context, movieId),
                onTapGenre: (genreId) => _getMoviesByGenreAndRefresh(genreId),


              ),
              SizedBox(height: MARGIN_LARGE,),
              ShowCasesSection(mShowCaseMovieList, (movieId) =>  _navigateToMovieDetailsScreen(context, movieId)),
              SizedBox(height: MARGIN_LARGE,),
              ActorAndCreatorSectionView(BEST_ACTOR_TITLE, BEST_ACTOR_SEE_MORE, mActorList: mActors,),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMovieDetailsScreen(BuildContext context, int movieId) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MovieDetailsPage(movieId))
    );
  }
}



class GenreSectionView extends StatelessWidget {

  final List<GenreVO> mGenreList;
  final List<MovieVO> mMoviesListByGenre;
  final Function(int) onTapMovie;
  final Function(int) onTapGenre;


  const GenreSectionView({
    required this.onTapMovie,
    required this.onTapGenre ,
    required this.mGenreList,
    required this.mMoviesListByGenre,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MARGIN_MEDIUM_2,
          ),
          child: DefaultTabController(
            length: mGenreList.length,
            child: TabBar(
              onTap: (index){
                this.onTapGenre(mGenreList[index].id ?? 0);
              },
              isScrollable: true,
              indicatorColor: PLAY_BUTTON_COLOR,
              unselectedLabelColor: HOME_SCREEN_LIST_TITLE_COLOR,
              tabs: mGenreList
                      .map((genre) => Tab(
                child: Text(genre?.name ?? ""),
              ),
              ).toList(),
            ),
          ),
        ),
        Container(
          color: PRIMARY_COLOR,
          padding: EdgeInsets.only(
            top: MARGIN_MEDIUM_2,
            bottom: MARGIN_LARGE
          ),
          child: HorizontalMovieListView(
              (movieId){
                onTapMovie(movieId);
              },
            movieList: mMoviesListByGenre,
          ),
        ),
      ],
    );
  }
}


class MovieShowTimeSectionView extends StatelessWidget {
  const MovieShowTimeSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PRIMARY_COLOR,
      margin: EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2
      ),
      padding: EdgeInsets.all(MARGIN_LARGE),
      height: SHOWTIME_SECTION_HEIGHT,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                MAIN_SCREEN_SHOWTIME_TITLE,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: TEXT_HEADING_1X,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              SeeMoreText(MAIN_SCREEN_SHOWTIME_SEE_MORE, textColor: Colors.amber,)
            ],
          ),
          Spacer(),
          Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: BANNER_PLAY_BUTTON_SIZE,
          ),
        ],
      ),
    );
  }
}

class ShowCasesSection extends StatefulWidget {

  final List<MovieVO> mShowCaseMovieList;
  final Function(int) onTapMovie;
  ShowCasesSection(this.mShowCaseMovieList, this.onTapMovie);


  @override
  _ShowCasesSectionState createState() => _ShowCasesSectionState();
}

class _ShowCasesSectionState extends State<ShowCasesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: TitleTextWithSeeMoreView(SHOWCASE_TITLE, SEE_MORE_SHOWCASES_TITLE),
        ),
        SizedBox(height: MARGIN_MEDIUM_2,),
        Container(
          height: SHOW_CASES_HEIGHT,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: MARGIN_MEDIUM_2,),
            children: widget.mShowCaseMovieList
                .map((movie) => ShowCaseView(movie,(movieId) => widget.onTapMovie(movieId)),
            ).toList(),
          ),
        ),
      ],
    );
  }
}




class BestPopularMoviesAndSeriesSectionView extends StatelessWidget {

  final Function(int) onTapMovie;

  final List<MovieVO> mNowPlayingMovieList;

  BestPopularMoviesAndSeriesSectionView(this.onTapMovie, this.mNowPlayingMovieList);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: MARGIN_MEDIUM_2),
          //alignment: Alignment.topLeft,
          child: TitleText(BEST_POPULAR_TITLE),
        ),
        SizedBox(height: MARGIN_MEDIUM_2,),
        HorizontalMovieListView(
            (movieId){ onTapMovie(movieId);},
          movieList: mNowPlayingMovieList,
        ),
      ],
    );
  }
}

class HorizontalMovieListView extends StatelessWidget {

  final Function(int) onTapMovie;
  final List<MovieVO> movieList;

  HorizontalMovieListView(this.onTapMovie, {required this.movieList } );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MOVIE_LIST_HEIGHT,
      child: (movieList != null) ? ListView.builder(
        padding: EdgeInsets.only(left: MARGIN_MEDIUM_2),
        itemCount: movieList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index){
          return MovieView(
              (movieId){
                onTapMovie(movieId);
              },
            movieList[index],
          );
        },
      ) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class BannerSectionView extends StatefulWidget {
  final List<MovieVO> mPopularMovieList;
  final Function(int) onTapMovie;

  BannerSectionView(this.mPopularMovieList, this.onTapMovie);

  @override
  _BannerSectionViewState createState() => _BannerSectionViewState();
}

class _BannerSectionViewState extends State<BannerSectionView> {
  double _postiion = 0;




  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 4,
          child: PageView(
            onPageChanged: (page){
              setState(() {
                _postiion = page.toDouble();
              });
            },
            children: widget.mPopularMovieList
              .map((popularMovie) => BannerView(
              (movieId) => widget.onTapMovie(movieId),  popularMovie,
            ),
            ).toList(),
          ),
        ),
        SizedBox(height: MARGIN_MEDIUM_2,),
        DotsIndicator(
            //dotsCount : widget.mPopularMovieList.length ,
            dotsCount : 10 ,
            position : _postiion,
            decorator : DotsDecorator(
              color: HOME_SCREEN_BANNER_INACTIVE_COLOR,
              activeColor: PLAY_BUTTON_COLOR,
            )
        ),
      ],
    );
  }
}
