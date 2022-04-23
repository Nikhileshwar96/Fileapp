import 'package:file_app/home/model/file_entity.dart';
import 'package:flutter/services.dart';

class PlatformServices {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  static Future<List<FileEntity>> getVideos() async {
    final List fileObjects =
        await platform.invokeMethod('getFiles', ['Videos']);

    final List<FileEntity> fileEntityList = <FileEntity>[];
    for (var file in fileObjects) {
      var fileEntityBuilder = FileEntityBuilder()
        ..name = file['name']
        ..uri = file['uri'];

      fileEntityList.add(fileEntityBuilder.build());
    }

    return fileEntityList;
  }

  static Future<List<FileEntity>> getImages() async {
    final List fileObjects =
        await platform.invokeMethod('getFiles', ['Images']);

    final List<FileEntity> fileEntityList = <FileEntity>[];
    for (var file in fileObjects) {
      var fileEntityBuilder = FileEntityBuilder()
        ..name = file['name']
        ..uri = file['uri'];

      fileEntityList.add(fileEntityBuilder.build());
    }

    return fileEntityList;
  }
}
