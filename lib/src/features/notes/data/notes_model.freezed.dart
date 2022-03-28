// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'notes_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NotesModel _$NotesModelFromJson(Map<String, dynamic> json) {
  return _NotesModel.fromJson(json);
}

/// @nodoc
class _$NotesModelTearOff {
  const _$NotesModelTearOff();

  _NotesModel call(
      {@JsonKey(toJson: omitEmpty, includeIfNull: false)
          String? id,
      @JsonKey(toJson: omitEmpty)
          required String description,
      @JsonKey(toJson: omitEmpty, includeIfNull: false)
          String content = '',
      @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
          String createdAt = '',
      @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
          String updatedAt = ''}) {
    return _NotesModel(
      id: id,
      description: description,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  NotesModel fromJson(Map<String, Object?> json) {
    return NotesModel.fromJson(json);
  }
}

/// @nodoc
const $NotesModel = _$NotesModelTearOff();

/// @nodoc
mixin _$NotesModel {
// TODO: How can I refactor it in order to use the useMongoDbBackend?
// @ObjectIdJsonConverter() @JsonKey(name: '_id', toJson: omitEmpty, includeIfNull: false) String? id,
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(toJson: omitEmpty)
  String get description => throw _privateConstructorUsedError;
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotesModelCopyWith<NotesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotesModelCopyWith<$Res> {
  factory $NotesModelCopyWith(
          NotesModel value, $Res Function(NotesModel) then) =
      _$NotesModelCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(toJson: omitEmpty, includeIfNull: false)
          String? id,
      @JsonKey(toJson: omitEmpty)
          String description,
      @JsonKey(toJson: omitEmpty, includeIfNull: false)
          String content,
      @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
          String createdAt,
      @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
          String updatedAt});
}

/// @nodoc
class _$NotesModelCopyWithImpl<$Res> implements $NotesModelCopyWith<$Res> {
  _$NotesModelCopyWithImpl(this._value, this._then);

  final NotesModel _value;
  // ignore: unused_field
  final $Res Function(NotesModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? description = freezed,
    Object? content = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$NotesModelCopyWith<$Res> implements $NotesModelCopyWith<$Res> {
  factory _$NotesModelCopyWith(
          _NotesModel value, $Res Function(_NotesModel) then) =
      __$NotesModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(toJson: omitEmpty, includeIfNull: false)
          String? id,
      @JsonKey(toJson: omitEmpty)
          String description,
      @JsonKey(toJson: omitEmpty, includeIfNull: false)
          String content,
      @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
          String createdAt,
      @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
          String updatedAt});
}

/// @nodoc
class __$NotesModelCopyWithImpl<$Res> extends _$NotesModelCopyWithImpl<$Res>
    implements _$NotesModelCopyWith<$Res> {
  __$NotesModelCopyWithImpl(
      _NotesModel _value, $Res Function(_NotesModel) _then)
      : super(_value, (v) => _then(v as _NotesModel));

  @override
  _NotesModel get _value => super._value as _NotesModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? description = freezed,
    Object? content = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_NotesModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      content: content == freezed
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NotesModel extends _NotesModel {
  const _$_NotesModel(
      {@JsonKey(toJson: omitEmpty, includeIfNull: false)
          this.id,
      @JsonKey(toJson: omitEmpty)
          required this.description,
      @JsonKey(toJson: omitEmpty, includeIfNull: false)
          this.content = '',
      @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
          this.createdAt = '',
      @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
          this.updatedAt = ''})
      : super._();

  factory _$_NotesModel.fromJson(Map<String, dynamic> json) =>
      _$$_NotesModelFromJson(json);

  @override // TODO: How can I refactor it in order to use the useMongoDbBackend?
// @ObjectIdJsonConverter() @JsonKey(name: '_id', toJson: omitEmpty, includeIfNull: false) String? id,
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  final String? id;
  @override
  @JsonKey(toJson: omitEmpty)
  final String description;
  @override
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  final String content;
  @override
  @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
  final String updatedAt;

  @override
  String toString() {
    return 'NotesModel(id: $id, description: $description, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotesModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.content, content) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(content),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(updatedAt));

  @JsonKey(ignore: true)
  @override
  _$NotesModelCopyWith<_NotesModel> get copyWith =>
      __$NotesModelCopyWithImpl<_NotesModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NotesModelToJson(this);
  }
}

abstract class _NotesModel extends NotesModel {
  const factory _NotesModel(
      {@JsonKey(toJson: omitEmpty, includeIfNull: false)
          String? id,
      @JsonKey(toJson: omitEmpty)
          required String description,
      @JsonKey(toJson: omitEmpty, includeIfNull: false)
          String content,
      @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
          String createdAt,
      @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
          String updatedAt}) = _$_NotesModel;
  const _NotesModel._() : super._();

  factory _NotesModel.fromJson(Map<String, dynamic> json) =
      _$_NotesModel.fromJson;

  @override // TODO: How can I refactor it in order to use the useMongoDbBackend?
// @ObjectIdJsonConverter() @JsonKey(name: '_id', toJson: omitEmpty, includeIfNull: false) String? id,
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  String? get id;
  @override
  @JsonKey(toJson: omitEmpty)
  String get description;
  @override
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  String get content;
  @override
  @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$NotesModelCopyWith<_NotesModel> get copyWith =>
      throw _privateConstructorUsedError;
}
