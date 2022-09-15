import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/data/vos/collection_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/production_company_vo.dart';
import 'package:movie_app/data/vos/production_country_vo.dart';

part 'movie_vo.g.dart';

@JsonSerializable()
class MovieVO{
  @JsonKey(name: "adult")
  bool? adult;

  @JsonKey(name: "backdrop_path")
  String? backDropPath;

  @JsonKey(name: "genre_ids")
  List<int>? genreIds;

  @JsonKey(name: 'belongs_to_collection')
  CollectionVO? belognsToCollection;

  @JsonKey(name: 'budget')
  double? budget;

  @JsonKey(name: 'genres')
  List<GenreVO>? genres;

  @JsonKey(name: 'homepage')
  String? homepage;

  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "imdb_id")
  String? imdbId;

  @JsonKey(name: "original_language")
  String? originalLanguage;

  @JsonKey(name: "original_title")
  String? originalTitle;

  @JsonKey(name: "overview")
  String? overview;

  @JsonKey(name: "popularity")
  double? popularity;

  @JsonKey(name: "poster_path")
  String? posterPath;

  @JsonKey(name: "release_date")
  String? releaseDate;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "revenue")
  int? revenue;

  @JsonKey(name: "status")
  String? status;

  @JsonKey(name: "tagline")
  String? tagline;

  @JsonKey(name: "runtime")
  int? runtime;


  @JsonKey(name: 'production_companies')
  List<ProductionCompanyVO>? prodcutionCompanies;

  @JsonKey(name: 'production_countries')
  List<ProductionCountryVO>? prodcutionCountries;


  @JsonKey(name: "video")
  bool? video;

  @JsonKey(name: "vote_average")
  double? voteAverage;

  @JsonKey(name: "vote_count")
  int? voteCount;


  MovieVO(
      this.adult,
      this.backDropPath,
      this.genreIds,
      this.belognsToCollection,
      this.budget,
      this.genres,
      this.homepage,
      this.id,
      this.imdbId,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.revenue,
      this.status,
      this.tagline,
      this.runtime,
      this.prodcutionCompanies,
      this.prodcutionCountries,
      this.video,
      this.voteAverage,
      this.voteCount);

  static MovieVO empty(){
    return MovieVO(false, "", [],  null, 0, [], "", 0, "0",  "", "","", 0, "", "", "", 0, "0" , "", 1, [], [], false, 0, 0);
  }

  factory MovieVO.fromJson(Map<String, dynamic> json) => _$MovieVOFromJson(json);

  Map<String, dynamic> toJson() => _$MovieVOToJson(this);

  @override
  String toString() {
    return 'MovieVO{adult: $adult, backDropPath: $backDropPath, genreIds: $genreIds, id: $id, originalLanguage: $originalLanguage, originalTitle: $originalTitle, overview: $overview, popularity: $popularity, posterPath: $posterPath, releaseDate: $releaseDate, title: $title, video: $video, voteAverage: $voteAverage, voteCount: $voteCount}';
  }
}

