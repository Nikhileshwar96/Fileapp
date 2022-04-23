// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_entity.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FileEntity> _$fileEntitySerializer = new _$FileEntitySerializer();

class _$FileEntitySerializer implements StructuredSerializer<FileEntity> {
  @override
  final Iterable<Type> types = const [FileEntity, _$FileEntity];
  @override
  final String wireName = 'FileEntity';

  @override
  Iterable<Object?> serialize(Serializers serializers, FileEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'uri',
      serializers.serialize(object.uri, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  FileEntity deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FileEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'uri':
          result.uri = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$FileEntity extends FileEntity {
  @override
  final String name;
  @override
  final String uri;

  factory _$FileEntity([void Function(FileEntityBuilder)? updates]) =>
      (new FileEntityBuilder()..update(updates)).build();

  _$FileEntity._({required this.name, required this.uri}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'FileEntity', 'name');
    BuiltValueNullFieldError.checkNotNull(uri, 'FileEntity', 'uri');
  }

  @override
  FileEntity rebuild(void Function(FileEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FileEntityBuilder toBuilder() => new FileEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FileEntity && name == other.name && uri == other.uri;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), uri.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FileEntity')
          ..add('name', name)
          ..add('uri', uri))
        .toString();
  }
}

class FileEntityBuilder implements Builder<FileEntity, FileEntityBuilder> {
  _$FileEntity? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _uri;
  String? get uri => _$this._uri;
  set uri(String? uri) => _$this._uri = uri;

  FileEntityBuilder();

  FileEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _uri = $v.uri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FileEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FileEntity;
  }

  @override
  void update(void Function(FileEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FileEntity build() {
    final _$result = _$v ??
        new _$FileEntity._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'FileEntity', 'name'),
            uri: BuiltValueNullFieldError.checkNotNull(
                uri, 'FileEntity', 'uri'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
