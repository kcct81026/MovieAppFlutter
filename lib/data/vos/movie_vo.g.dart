// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieVO _$MovieVOFromJson(Map<String, dynamic> json) => MovieVO(
      json['adult'] as bool?,
      json['backdrop_path'] as String?,
      (json['genre_ids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['belongs_to_collection'] == null
          ? null
          : CollectionVO.fromJson(
              json['belongs_to_collection'] as Map<String, dynamic>),
      (json['budget'] as num?)?.toDouble(),
      (json['genres'] as List<dynamic>?)
          ?.map((e) => GenreVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['homepage'] as String?,
      json['id'] as int,
      json['imdb_id'] as String?,
      json['original_language'] as String?,
      json['original_title'] as String?,
      json['overview'] as String?,
      (json['popularity'] as num?)?.toDouble(),
      json['poster_path'] as String?,
      json['release_date'] as String?,
      json['title'] as String?,
      json['revenue'] as int?,
      json['status'] as String?,
      json['tagline'] as String?,
      json['runtime'] as int?,
      (json['production_companies'] as List<dynamic>?)
          ?.map((e) => ProductionCompanyVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['production_countries'] as List<dynamic>?)
          ?.map((e) => ProductionCountryVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['video'] as bool?,
      (json['vote_average'] as num?)?.toDouble(),
      json['vote_count'] as int?,
    );

Map<String, dynamic> _$MovieVOToJson(MovieVO instance) => <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backDropPath,
      'genre_ids': instance.genreIds,
      'belongs_to_collection': instance.belognsToCollection,
      'budget': instance.budget,
      'genres': instance.genres,
      'homepage': instance.homepage,
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'release_date': instance.releaseDate,
      'title': instance.title,
      'revenue': instance.revenue,
      'status': instance.status,
      'tagline': instance.tagline,
      'runtime': instance.runtime,
      'production_companies': instance.prodcutionCompanies,
      'production_countries': instance.prodcutionCountries,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
