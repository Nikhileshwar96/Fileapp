import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:file_app/home/model/file_type.dart';
part 'file_entity.g.dart';

abstract class FileEntity implements Built<FileEntity, FileEntityBuilder> {
  static Serializer<FileEntity> get serializer => _$fileEntitySerializer;

  String get name;

  String get uri;

  String get path;

  FileType get type;

  String get id;

  int get duration;

  int get size;

  bool get isDirectory;

  factory FileEntity([void Function(FileEntityBuilder) updates]) = _$FileEntity;
  FileEntity._();
}
