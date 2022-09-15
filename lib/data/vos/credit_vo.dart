import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/data/vos/base_actor_vo.dart';

part 'credit_vo.g.dart';

@JsonSerializable()
class CreditVO extends BaseActorVO{

  @JsonKey(name: 'adult')
  bool? id;

  @JsonKey(name: 'gender')
  int? gender;

  @JsonKey(name: 'known_for_department')
  String? knowForDepartment;
/*
  @JsonKey(name: 'name')
  String? name;*/

  @JsonKey(name: 'original_name')
  String? originalName;

  @JsonKey(name: 'popularity')
  double? popularity;

/*

  @JsonKey(name: 'profile_path')
  String? profilePath;
*/

  @JsonKey(name: 'cast_id')
  int? castId;

  @JsonKey(name: 'character')
  String? character;

  @JsonKey(name: 'credit_id')
  String? creditId;

  @JsonKey(name: 'order')
  int? order;



  bool isActor(){
    return knowForDepartment == KNOWN_FOR_DEPARTMENT_ACTING;
  }

  bool isCreator(){
    return knowForDepartment != KNOWN_FOR_DEPARTMENT_ACTING;
  }


  CreditVO(this.id, this.gender, this.knowForDepartment, this.originalName,
      this.popularity, this.castId, this.character, this.creditId, this.order, String name, String profilePath): super(name,profilePath);

  factory CreditVO.fromJson(Map<String, dynamic> json) => _$CreditVOFromJson(json);

  Map<String, dynamic> toJson() => _$CreditVOToJson(this);
}

const String KNOWN_FOR_DEPARTMENT_ACTING = "Acting";


