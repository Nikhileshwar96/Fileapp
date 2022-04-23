import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
part 'file_entity.g.dart';

abstract class FileEntity implements Built<FileEntity, FileEntityBuilder> {
  static Serializer<FileEntity> get serializer => _$fileEntitySerializer;

  String get name;

  String get uri;

  factory FileEntity([void Function(FileEntityBuilder) updates]) = _$FileEntity;
  FileEntity._();
}
