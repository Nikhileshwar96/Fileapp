import 'dart:io';

import 'package:file_app/model/file_entity.dart';
import 'package:file_app/model/file_type.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FileDisplayPage extends StatefulWidget {
  final FileEntity file;
  const FileDisplayPage(this.file, {Key? key}) : super(key: key);

  @override
  State<FileDisplayPage> createState() => _FileDisplayPageState();
}

class _FileDisplayPageState extends State<FileDisplayPage> {
  VideoPlayerController? videoController;
  @override
  void initState() {
    videoController = widget.file.type == FileType.video
        ? VideoPlayerController.file(
            File(
              widget.file.path,
            ),
          )
        : null;
    videoController?.initialize().then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    videoController?.play();
    return widget.file.type == FileType.image
        ? Center(
            child: Image.file(
              File(
                widget.file.path,
              ),
            ),
          )
        : widget.file.type == FileType.video
            ? Center(
                child: AspectRatio(
                  aspectRatio: videoController?.value.aspectRatio ?? 1,
                  child: VideoPlayer(
                    videoController!,
                  ),
                ),
              )
            : const Center(
                child: Text(
                  'File cannot be previewed',
                ),
              );
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }
}
