// @JsonSerializable(includeIfNull: false)
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/helper.dart';

part 'notes_model.freezed.dart';
part 'notes_model.g.dart';

@freezed
class NotesModel with _$NotesModel {
  const NotesModel._();
  const factory NotesModel({
    // TODO: How can I refactor it in order to use the useMongoDbBackend?
    // @ObjectIdJsonConverter() @JsonKey(name: '_id', toJson: omitEmpty, includeIfNull: false) String? id,
    @JsonKey(toJson: omitEmpty, includeIfNull: false) String? id,
    @JsonKey(toJson: omitEmpty) required String description,
    @Default('') @JsonKey(toJson: omitEmpty, includeIfNull: false) String content,
    @Default('') @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false) String createdAt,
    @Default('') @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false) String updatedAt,
  }) = _NotesModel;

  factory NotesModel.fromJson(Map<String, dynamic> json) =>
      _$NotesModelFromJson(json);

  String get title => description;

  static const List<String> fields = ['id', 'description', 'content', 'createdAt', 'updatedAt'];

  // TODO: refactor - how can I access properties by name?
  dynamic getProp(String key) => <String, dynamic>{
    'id': id,
    'title': title,
    'description': description,
    'content': content,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  }[key];
  // or use this one?
  dynamic operator[](prop) {
    if (prop == "id") { return id; }
    else if (prop == "title") { return title; }
    else if (prop == "description") { return description; }
    else if (prop == "content") { return content; }
    else if (prop == "createdAt") { return createdAt; }
    else if (prop == "updatedAt") { return updatedAt; }
    else { throw('unknown property: $prop'); }
  }
}

omitEmpty(value) {
  itgLogVerbose('omitEmpty - value: $value');
  return value == null || value == '' ? null : value;
}

class ObjectIdJsonConverter implements JsonConverter<String?, Map<String, dynamic>> {
  const ObjectIdJsonConverter();

  @override
  String? fromJson(Map<String, dynamic> json) => getId(json);

  @override
  Map<String, dynamic> toJson(String? object) => {r"$oid":"$object"};
}

class DateStringJsonConverter implements JsonConverter<String, String> {
  const DateStringJsonConverter();

  @override
  String fromJson(String json) => jsonValueAsString(json);

  @override
  String toJson(String object) => jsonStringAsStringValue(object, valueType: 'date');
}

