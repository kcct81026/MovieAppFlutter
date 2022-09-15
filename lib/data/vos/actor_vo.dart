import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/data/vos/base_actor_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';

part 'actor_vo.g.dart';

@JsonSerializable()
class ActorVO extends BaseActorVO{

 /* @JsonKey(name: "profile_path")
  String? profilePath;
*/
  @JsonKey(name: "adult")
  bool? adult;

  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "known_for")
  List<MovieVO>? knownFor;
/*

  @JsonKey(name: "name")
  String? name;
*/

  @JsonKey(name: "popularity")
  double? popularity;


  ActorVO(this.adult, this.id, this.knownFor, this.popularity , String name, String profilePath): super(name,profilePath);

  factory ActorVO.fromJson(Map<String, dynamic> json) => _$ActorVOFromJson(json);

  Map<String,dynamic> toJson() => _$ActorVOToJson(this);
}
