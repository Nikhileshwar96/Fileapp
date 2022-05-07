import 'dart:typed_data';

import 'package:file_app/model/file_entity.dart';
import 'package:file_app/model/file_type.dart';
import 'package:file_app/providers/platform_service_provider.dart';
import 'package:flutter/services.dart';

class PlatformServicesProvider extends IPlatformServices {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  @override
  Future<List<FileEntity>> getFiles(
    String fileType,
    int skipCount,
    int takeCount,
  ) async {
    final List fileObjects = await platform.invokeMethod('getFiles', {
      'type': fileType,
      'skip': skipCount,
      'take': takeCount,
    });

    final List<FileEntity> fileEntityList = <FileEntity>[];
    for (var file in fileObjects) {
      FileType mimeType =
          mapMimeType(file['type']?.toString().toLowerCase() ?? "");
      var fileEntityBuilder = FileEntityBuilder()
        ..name = file['name'] ?? "Untitled"
        ..uri = file['uri']
        ..duration =
            file['duration'] == "null" ? 0 : int.parse(file['duration'])
        ..size = int.parse(file['size'])
        ..id = file['id']
        ..isDirectory = file['isDirectory'] == "true"
        ..path = file['path']
        ..type = mimeType;

      fileEntityList.add(fileEntityBuilder.build());
    }

    return fileEntityList;
  }

  @override
  Future<Uint8List> getThumbnail(
    String fileType,
    String uri,
    String id,
  ) async {
    final Uint8List thumbnailBytes = await platform
        .invokeMethod('getThumbnail', {'type': fileType, 'uri': uri, 'id': id});

    return thumbnailBytes;
  }

  @override
  Future<bool> deleteFile(
    String uri,
  ) async {
    final bool deletedSuccessfully =
        await platform.invokeMethod('deleteFile', {'uri': uri});

    return deletedSuccessfully;
  }

  @override
  Future<List<FileEntity>> getFolderFiles(
    String folder,
    int skipCount,
    int takeCount,
  ) async {
    final List fileObjects = await platform.invokeMethod('getFolderFile', {
      'folder': folder,
      'skip': skipCount,
      'take': takeCount,
    });

    final List<FileEntity> fileEntityList = <FileEntity>[];
    for (var file in fileObjects) {
      FileType mimeType =
          mapMimeType(file['type']?.toString().toLowerCase() ?? "");
      var fileEntityBuilder = FileEntityBuilder()
        ..name = file['name']
        ..uri = file['uri']
        ..duration = file['duration'] == "null" || file['duration'] == null
            ? 0
            : int.parse(file['duration'] ?? '0')
        ..size = int.parse(file['size'] ?? '0')
        ..id = file['id'] ?? ''
        ..isDirectory = file['isDirectory'] == "true"
        ..path = file['path']
        ..type = mimeType;

      fileEntityList.add(fileEntityBuilder.build());
    }

    return fileEntityList;
  }

  @override
  shareFile(String path) {
    platform.invokeMethod('shareFile', {"path": path});
  }

  @override
  Future<bool> checkStoragePermission() async {
    return await platform.invokeMethod('checkStoragePermission');
  }

  @override
  Future<bool> requestStoragePermission() async {
    return await platform.invokeMethod('requestStoragePermission');
  }

  FileType mapMimeType(String mimeType) {
    if (mimeType.startsWith('video')) {
      return FileType.video;
    }

    if (mimeType.startsWith('audio')) {
      return FileType.audio;
    }

    if (mimeType.startsWith('image')) {
      return FileType.image;
    }

    if (mimeType == 'dir') {
      return FileType.directory;
    }

    return FileType.file;
  }
}
