// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'links_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LinksModel _$LinksModelFromJson(Map<String, dynamic> json) {
  return _LinksModel.fromJson(json);
}

/// @nodoc
class _$LinksModelTearOff {
  const _$LinksModelTearOff();

  _LinksModel call(
      {@JsonKey(toJson: omitEmpty, includeIfNull: false)
          String? id,
      @JsonKey(toJson: omitEmpty)
          required String description,
      @JsonKey(toJson: omitEmpty, includeIfNull: false)
          String notes = '',
      @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
          String createdAt = '',
      @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
          String updatedAt = ''}) {
    return _LinksModel(
      id: id,
      description: description,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  LinksModel fromJson(Map<String, Object?> json) {
    return LinksModel.fromJson(json);
  }
}

/// @nodoc
const $LinksModel = _$LinksModelTearOff();

/// @nodoc
mixin _$LinksModel {
// TODO: How can I refactor it in order to use the useMongoDbBackend?
// @ObjectIdJsonConverter() @JsonKey(name: '_id', toJson: omitEmpty, includeIfNull: false) String? id,
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  String? get id => throw _privateConstructorUsedError; //** fields start **//
  @JsonKey(toJson: omitEmpty)
  String get description => throw _privateConstructorUsedError;
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  String get notes => throw _privateConstructorUsedError; //** fields end **//
  @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LinksModelCopyWith<LinksModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinksModelCopyWith<$Res> {
  factory $LinksModelCopyWith(
          LinksModel value, $Res Function(LinksModel) then) =
      _$LinksModelCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(toJson: omitEmpty, includeIfNull: false)
          String? id,
      @JsonKey(toJson: omitEmpty)
          String description,
      @JsonKey(toJson: omitEmpty, includeIfNull: false)
          String notes,
      @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
          String createdAt,
      @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
          String updatedAt});
}

/// @nodoc
class _$LinksModelCopyWithImpl<$Res> implements $LinksModelCopyWith<$Res> {
  _$LinksModelCopyWithImpl(this._value, this._then);

  final LinksModel _value;
  // ignore: unused_field
  final $Res Function(LinksModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? description = freezed,
    Object? notes = freezed,
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
      notes: notes == freezed
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
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
abstract class _$LinksModelCopyWith<$Res> implements $LinksModelCopyWith<$Res> {
  factory _$LinksModelCopyWith(
          _LinksModel value, $Res Function(_LinksModel) then) =
      __$LinksModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(toJson: omitEmpty, includeIfNull: false)
          String? id,
      @JsonKey(toJson: omitEmpty)
          String description,
      @JsonKey(toJson: omitEmpty, includeIfNull: false)
          String notes,
      @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
          String createdAt,
      @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
          String updatedAt});
}

/// @nodoc
class __$LinksModelCopyWithImpl<$Res> extends _$LinksModelCopyWithImpl<$Res>
    implements _$LinksModelCopyWith<$Res> {
  __$LinksModelCopyWithImpl(
      _LinksModel _value, $Res Function(_LinksModel) _then)
      : super(_value, (v) => _then(v as _LinksModel));

  @override
  _LinksModel get _value => super._value as _LinksModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? description = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_LinksModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      notes: notes == freezed
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
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
class _$_LinksModel extends _LinksModel {
  const _$_LinksModel(
      {@JsonKey(toJson: omitEmpty, includeIfNull: false)
          this.id,
      @JsonKey(toJson: omitEmpty)
          required this.description,
      @JsonKey(toJson: omitEmpty, includeIfNull: false)
          this.notes = '',
      @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
          this.createdAt = '',
      @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
          this.updatedAt = ''})
      : super._();

  factory _$_LinksModel.fromJson(Map<String, dynamic> json) =>
      _$$_LinksModelFromJson(json);

  @override // TODO: How can I refactor it in order to use the useMongoDbBackend?
// @ObjectIdJsonConverter() @JsonKey(name: '_id', toJson: omitEmpty, includeIfNull: false) String? id,
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  final String? id;
  @override //** fields start **//
  @JsonKey(toJson: omitEmpty)
  final String description;
  @override
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  final String notes;
  @override //** fields end **//
  @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
  final String updatedAt;

  @override
  String toString() {
    return 'LinksModel(id: $id, description: $description, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LinksModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.notes, notes) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(notes),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(updatedAt));

  @JsonKey(ignore: true)
  @override
  _$LinksModelCopyWith<_LinksModel> get copyWith =>
      __$LinksModelCopyWithImpl<_LinksModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LinksModelToJson(this);
  }
}

abstract class _LinksModel extends LinksModel {
  const factory _LinksModel(
      {@JsonKey(toJson: omitEmpty, includeIfNull: false)
          String? id,
      @JsonKey(toJson: omitEmpty)
          required String description,
      @JsonKey(toJson: omitEmpty, includeIfNull: false)
          String notes,
      @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
          String createdAt,
      @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
          String updatedAt}) = _$_LinksModel;
  const _LinksModel._() : super._();

  factory _LinksModel.fromJson(Map<String, dynamic> json) =
      _$_LinksModel.fromJson;

  @override // TODO: How can I refactor it in order to use the useMongoDbBackend?
// @ObjectIdJsonConverter() @JsonKey(name: '_id', toJson: omitEmpty, includeIfNull: false) String? id,
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  String? get id;
  @override //** fields start **//
  @JsonKey(toJson: omitEmpty)
  String get description;
  @override
  @JsonKey(toJson: omitEmpty, includeIfNull: false)
  String get notes;
  @override //** fields end **//
  @JsonKey(name: 'created_at', toJson: omitEmpty, includeIfNull: false)
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at', toJson: omitEmpty, includeIfNull: false)
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$LinksModelCopyWith<_LinksModel> get copyWith =>
      throw _privateConstructorUsedError;
}
