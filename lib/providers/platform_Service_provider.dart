import 'dart:typed_data';

import 'package:file_app/model/file_entity.dart';
import 'package:flutter/services.dart';

abstract class IPlatformServices {
  static const platform = MethodChannel('samples.flutter.dev/battery');

  Future<List<FileEntity>> getFiles(
    String fileType,
    int skipCount,
    int takeCount,
  );

  Future<Uint8List> getThumbnail(
    String fileType,
    String uri,
    String id,
  );

  Future<bool> deleteFile(
    String uri,
  );

  Future<List<FileEntity>> getFolderFiles(
    String folder,
    int skipCount,
    int takeCount,
  );

  shareFile(String path);

  Future<bool> checkStoragePermission();

  Future<bool> requestStoragePermission();
}
