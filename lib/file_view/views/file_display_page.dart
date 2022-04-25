import 'dart:io';

import 'package:file_app/home/model/file_entity.dart';
import 'package:file_app/home/model/file_type.dart';
import 'package:file_app/providers/platform_Service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../file_listing/views/delete_confirmation_view.dart';

class FileDisplayPage extends StatefulWidget {
  final FileEntity file;
  const FileDisplayPage(this.file, {Key? key}) : super(key: key);

  @override
  State<FileDisplayPage> createState() => _FileDisplayPageState();
}

class _FileDisplayPageState extends State<FileDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.file.name,
        ),
        actions: [
          Builder(
            builder: (_tempContext) => IconButton(
              onPressed: () {
                showModalBottomSheet<bool>(
                  context: _tempContext,
                  clipBehavior: Clip.hardEdge,
                  builder: (deleteContext) => DeleteConfirmationView(
                    widget.file,
                  ),
                );
              },
              icon: const Icon(
                Icons.delete,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              RepositoryProvider.of<PlatformServices>(context).shareFile(
                widget.file.uri,
              );
            },
            icon: const Icon(
              Icons.share,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: widget.file.type == FileType.image
            ? Center(
                child: Image.file(
                  File(
                    widget.file.path,
                  ),
                ),
              )
            : widget.file.type == FileType.video
                ? VideoPlayer(
                    VideoPlayerController.file(
                      File(
                        widget.file.uri,
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      'File cannot be previewed',
                    ),
                  ),
      ),
    );
  }
}