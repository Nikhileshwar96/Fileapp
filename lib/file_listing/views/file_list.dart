import 'dart:async';

import 'package:file_app/file_listing/views/folder_list_view.dart';
import 'package:file_app/file_listing/views/image_list_view.dart';
import 'package:file_app/file_listing/views/video_list_view.dart';
import 'package:file_app/home/model/file_entity.dart';
import 'package:file_app/home/model/file_type.dart';
import 'package:flutter/material.dart';

import 'audio_list_view.dart';
import 'file_list_view.dart';

class FileDisplay extends StatefulWidget {
  final String fileName;
  final Future<List<FileEntity>> filesFuture;
  const FileDisplay({
    required this.fileName,
    required this.filesFuture,
    Key? key,
  }) : super(key: key);

  @override
  State<FileDisplay> createState() => _FileDisplayState();
}

class _FileDisplayState extends State<FileDisplay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: FutureBuilder<List<FileEntity>>(
        future: widget.filesFuture,
        builder: (cont, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No file present or couldn\'t read folder',
              ),
            );
          }

          var files = snapshot.data!;
          return files.isNotEmpty
              ? ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (_fileContext, _fileIndex) {
                    var file = files[_fileIndex];
                    return getFileView(file);
                  },
                )
              : const Center(
                  child: Text(
                    'No files to display',
                  ),
                );
        },
      ),
    );
  }

  Widget getFileView(FileEntity file) {
    switch (file.type) {
      case FileType.image:
        return ImageListView(file);
      case FileType.audio:
        return AudioListView(file);
      case FileType.directory:
        return FolderListView(file);
      case FileType.file:
        return FileListView(file);
      case FileType.video:
        return VideoListView(file);
    }

    return FileListView(file);
  }
}
