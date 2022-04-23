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
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'duration',
      serializers.serialize(object.duration,
          specifiedType: const FullType(int)),
      'size',
      serializers.serialize(object.size, specifiedType: const FullType(int)),
      'isDirectory',
      serializers.serialize(object.isDirectory,
          specifiedType: const FullType(bool)),
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
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'duration':
          result.duration = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'size':
          result.size = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'isDirectory':
          result.isDirectory = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
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
  @override
  final String type;
  @override
  final String id;
  @override
  final int duration;
  @override
  final int size;
  @override
  final bool isDirectory;

  factory _$FileEntity([void Function(FileEntityBuilder)? updates]) =>
      (new FileEntityBuilder()..update(updates)).build();

  _$FileEntity._(
      {required this.name,
      required this.uri,
      required this.type,
      required this.id,
      required this.duration,
      required this.size,
      required this.isDirectory})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'FileEntity', 'name');
    BuiltValueNullFieldError.checkNotNull(uri, 'FileEntity', 'uri');
    BuiltValueNullFieldError.checkNotNull(type, 'FileEntity', 'type');
    BuiltValueNullFieldError.checkNotNull(id, 'FileEntity', 'id');
    BuiltValueNullFieldError.checkNotNull(duration, 'FileEntity', 'duration');
    BuiltValueNullFieldError.checkNotNull(size, 'FileEntity', 'size');
    BuiltValueNullFieldError.checkNotNull(
        isDirectory, 'FileEntity', 'isDirectory');
  }

  @override
  FileEntity rebuild(void Function(FileEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FileEntityBuilder toBuilder() => new FileEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FileEntity &&
        name == other.name &&
        uri == other.uri &&
        type == other.type &&
        id == other.id &&
        duration == other.duration &&
        size == other.size &&
        isDirectory == other.isDirectory;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, name.hashCode), uri.hashCode),
                        type.hashCode),
                    id.hashCode),
                duration.hashCode),
            size.hashCode),
        isDirectory.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FileEntity')
          ..add('name', name)
          ..add('uri', uri)
          ..add('type', type)
          ..add('id', id)
          ..add('duration', duration)
          ..add('size', size)
          ..add('isDirectory', isDirectory))
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

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _duration;
  int? get duration => _$this._duration;
  set duration(int? duration) => _$this._duration = duration;

  int? _size;
  int? get size => _$this._size;
  set size(int? size) => _$this._size = size;

  bool? _isDirectory;
  bool? get isDirectory => _$this._isDirectory;
  set isDirectory(bool? isDirectory) => _$this._isDirectory = isDirectory;

  FileEntityBuilder();

  FileEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _uri = $v.uri;
      _type = $v.type;
      _id = $v.id;
      _duration = $v.duration;
      _size = $v.size;
      _isDirectory = $v.isDirectory;
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
            uri:
                BuiltValueNullFieldError.checkNotNull(uri, 'FileEntity', 'uri'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, 'FileEntity', 'type'),
            id: BuiltValueNullFieldError.checkNotNull(id, 'FileEntity', 'id'),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, 'FileEntity', 'duration'),
            size: BuiltValueNullFieldError.checkNotNull(
                size, 'FileEntity', 'size'),
            isDirectory: BuiltValueNullFieldError.checkNotNull(
                isDirectory, 'FileEntity', 'isDirectory'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
