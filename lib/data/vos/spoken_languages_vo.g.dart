// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spoken_languages_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpokenLanguagesVO _$SpokenLanguagesVOFromJson(Map<String, dynamic> json) =>
    SpokenLanguagesVO(
      json['english_name'] as String?,
      json['iso_639_1'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$SpokenLanguagesVOToJson(SpokenLanguagesVO instance) =>
    <String, dynamic>{
      'english_name': instance.englishName,
      'iso_639_1': instance.iso6391,
      'name': instance.name,
    };
