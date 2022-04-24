import 'dart:typed_data';

import 'package:file_app/home/model/file_entity.dart';
import 'package:flutter/services.dart';

class PlatformServices {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  Future<List<FileEntity>> getFiles(String fileType) async {
    final List fileObjects =
        await platform.invokeMethod('getFiles', {'type': fileType});

    final List<FileEntity> fileEntityList = <FileEntity>[];
    for (var file in fileObjects) {
      String mimeType =
          mapMimeType(file['type']?.toString().toLowerCase() ?? "");
      var fileEntityBuilder = FileEntityBuilder()
        ..name = file['name'] ?? "Untitled"
        ..uri = file['uri']
        ..duration =
            file['duration'] == "null" ? 0 : int.parse(file['duration'])
        ..size = int.parse(file['size'])
        ..id = file['id']
        ..isDirectory = file['isDirectory'] == "true"
        ..type = mimeType;

      fileEntityList.add(fileEntityBuilder.build());
    }

    return fileEntityList;
  }

  Future<Uint8List> getThumbnail(
    String fileType,
    String uri,
    String id,
  ) async {
    final Uint8List thumbnailBytes = await platform
        .invokeMethod('getThumbnail', {'type': fileType, 'uri': uri, 'id': id});

    return thumbnailBytes;
  }

  Future<bool> deleteFile(
    String uri,
  ) async {
    final bool deletedSuccessfully =
        await platform.invokeMethod('deleteFile', {'uri': uri});

    return deletedSuccessfully;
  }

  Future<List<FileEntity>> getFolderFiles(
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
        ..duration = file['duration'] == "null" || file['duration'] == null
            ? 0
            : int.parse(file['duration'] ?? '0')
        ..size = int.parse(file['size'] ?? '0')
        ..id = file['id'] ?? ''
        ..isDirectory = file['isDirectory'] == "true"
        ..type = file['type'] ?? 'dir';

      fileEntityList.add(fileEntityBuilder.build());
    }

    return fileEntityList;
  }

  shareFile(String path) {
    platform.invokeMethod('shareFile', {"path": path});
  }

  Future<bool> checkStoragePermission() async {
    return await platform.invokeMethod('checkStoragePermission');
  }

  Future<bool> requestStoragePermission() async {
    return await platform.invokeMethod('requestStoragePermission');
  }

  String mapMimeType(String mimeType) {
    if (mimeType.startsWith('video')) {
      return 'video';
    }

    if (mimeType.startsWith('audio')) {
      return 'audio';
    }

    if (mimeType.startsWith('image')) {
      return 'image';
    }

    return 'file';
  }
}
