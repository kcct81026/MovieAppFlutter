import 'package:json_annotation/json_annotation.dart';

part 'base_actor_vo.g.dart';

@JsonSerializable()
class BaseActorVO{

  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "profile_path")
  String profilePath;

  BaseActorVO(this.name, this.profilePath);

  factory BaseActorVO.fromJson(Map<String, dynamic> json) => _$BaseActorVOFromJson(json);

  Map<String, dynamic> toJson() => _$BaseActorVOToJson(this);

}