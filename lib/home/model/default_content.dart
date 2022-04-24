import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'default_content.g.dart';

class DefaultContent extends EnumClass {
  static Serializer<DefaultContent> get serializer =>
      _$defaultContentSerializer;

  static const DefaultContent image = _$image;
  static const DefaultContent video = _$video;
  static const DefaultContent audio = _$audio;
  static const DefaultContent download = _$file;

  const DefaultContent._(String name) : super(name);

  static BuiltSet<DefaultContent> get values => _$values;
  static DefaultContent valueOf(String name) => _$valueOf(name);
}
