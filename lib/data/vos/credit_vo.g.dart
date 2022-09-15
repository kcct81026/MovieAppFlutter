// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditVO _$CreditVOFromJson(Map<String, dynamic> json) => CreditVO(
      json['adult'] as bool?,
      json['gender'] as int?,
      json['known_for_department'] as String?,
      json['original_name'] as String?,
      (json['popularity'] as num?)?.toDouble(),
      json['cast_id'] as int?,
      json['character'] as String?,
      json['credit_id'] as String?,
      json['order'] as int?,
      json['name'] as String,
      json['profile_path'] as String,
    );

Map<String, dynamic> _$CreditVOToJson(CreditVO instance) => <String, dynamic>{
      'name': instance.name,
      'profile_path': instance.profilePath,
      'adult': instance.id,
      'gender': instance.gender,
      'known_for_department': instance.knowForDepartment,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'cast_id': instance.castId,
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
    };
