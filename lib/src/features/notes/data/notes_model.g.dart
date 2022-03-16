// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NotesModel _$$_NotesModelFromJson(Map<String, dynamic> json) =>
    _$_NotesModel(
      id: json['id'] as String?,
      description: json['description'] as String,
      content: json['content'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );

Map<String, dynamic> _$$_NotesModelToJson(_$_NotesModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', omitEmpty(instance.id));
  val['description'] = omitEmpty(instance.description);
  writeNotNull('content', omitEmpty(instance.content));
  writeNotNull('created_at', omitEmpty(instance.createdAt));
  writeNotNull('updated_at', omitEmpty(instance.updatedAt));
  return val;
}
