import 'package:json_annotation/json_annotation.dart';
part 'filter_model.g.dart';

@JsonSerializable()
class FilterModel {
  String? eventPerPage;
  String? city;
  String? query;

  FilterModel({
    this.city,
    this.eventPerPage,
    this.query,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) =>
      _$FilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterModelToJson(this);
}
