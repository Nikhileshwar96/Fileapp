import 'dart:typed_data';

import 'package:file_app/home/model/file_entity.dart';
import 'package:flutter/services.dart';

class PlatformServices {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  static Future<List<FileEntity>> getFiles(String fileType) async {
    final List fileObjects =
        await platform.invokeMethod('getFiles', {'type': fileType});

    final List<FileEntity> fileEntityList = <FileEntity>[];
    for (var file in fileObjects) {
      var fileEntityBuilder = FileEntityBuilder()
        ..name = file['name']
        ..uri = file['uri']
        ..duration =
            file['duration'] == "null" ? 0 : int.parse(file['duration'])
        ..size = int.parse(file['size'])
        ..id = file['id']
        ..type = fileType;

      fileEntityList.add(fileEntityBuilder.build());
    }

    return fileEntityList;
  }

  static Future<Uint8List> getThumbnail(
    String fileType,
    String uri,
    String id,
  ) async {
    final Uint8List thumbnailBytes = await platform
        .invokeMethod('getThumbnail', {'type': fileType, 'uri': uri, 'id': id});

    return thumbnailBytes;
  }

  static Future<bool> deleteFile(
    String uri,
    String id,
  ) async {
    final bool deletedSuccessfully =
        await platform.invokeMethod('deleteFile', {'uri': uri, 'id': id});

    return deletedSuccessfully;
  }

  static Future<List<FileEntity>> getFolderFiles(
    String folder,
  ) async {
    final List fileObjects = await platform.invokeMethod('getFolderFile', {
      'folder': folder,
    });

    final List<FileEntity> fileEntityList = <FileEntity>[];
    for (var file in fileObjects) {
      var fileEntityBuilder = FileEntityBuilder()
        ..name = file['name']
        ..uri = file['uri']
        ..duration =
            file['duration'] == "null" ? 0 : int.parse(file['duration'])
        ..size = int.parse(file['size'])
        ..id = file['id']
        ..isDirectory = file['isDirectory']
        ..type = file['type'];

      fileEntityList.add(fileEntityBuilder.build());
    }

    return fileEntityList;
  }
}
