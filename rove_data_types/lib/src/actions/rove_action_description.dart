import 'package:json_annotation/json_annotation.dart';

part 'rove_action_description.g.dart';

@JsonSerializable()
class RoveActionDescription {
  @JsonKey(includeIfNull: false)
  final String? prefix;
  @JsonKey(includeIfNull: false)
  final String? body;
  @JsonKey(includeIfNull: false)
  final String? target;

  @JsonKey(includeIfNull: false)
  final String? suffix;

  RoveActionDescription({this.prefix, this.body, this.target, this.suffix});

  factory RoveActionDescription.fromJson(Map<String, dynamic> json) =>
      _$RoveActionDescriptionFromJson(json);
  Map<String, dynamic> toJson() => _$RoveActionDescriptionToJson(this);
}
