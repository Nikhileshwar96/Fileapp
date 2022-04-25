import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'file_type.g.dart';

class FileType extends EnumClass {
  static Serializer<FileType> get serializer => _$fileTypeSerializer;

  static const FileType image = _$image;
  static const FileType video = _$video;
  static const FileType audio = _$audio;
  static const FileType file = _$file;
  static const FileType directory = _$directory;

  const FileType._(String name) : super(name);

  static BuiltSet<FileType> get values => _$values;
  static FileType valueOf(String name) => _$valueOf(name);
}
