// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'links_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LinksModel _$$_LinksModelFromJson(Map<String, dynamic> json) =>
    _$_LinksModel(
      id: json['id'] as String?,
      description: json['description'] as String,
      notes: json['notes'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );

Map<String, dynamic> _$$_LinksModelToJson(_$_LinksModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', omitEmpty(instance.id));
  val['description'] = omitEmpty(instance.description);
  writeNotNull('notes', omitEmpty(instance.notes));
  writeNotNull('created_at', omitEmpty(instance.createdAt));
  writeNotNull('updated_at', omitEmpty(instance.updatedAt));
  return val;
}
