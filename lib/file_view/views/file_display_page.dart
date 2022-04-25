import 'dart:io';

import 'package:file_app/file_listing/bloc/file_listing_bloc.dart';
import 'package:file_app/home/model/file_entity.dart';
import 'package:file_app/home/model/file_type.dart';
import 'package:file_app/providers/platform_service_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.file.name,
        ),
        actions: [
          Builder(
            builder: (_tempContext) => IconButton(
              onPressed: () async {
                bool isDeleteConfirmed = await showModalBottomSheet<bool>(
                      context: _tempContext,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      builder: (deleteContext) => DeleteConfirmationView(
                        widget.file,
                      ),
                    ) ??
                    false;
                if (isDeleteConfirmed) {
                  Navigator.pop(context);
                  BlocProvider.of<FileListingBloc>(context)
                      .add(DeleteFile(widget.file.path));
                }
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
                  ),
      ),
    );
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }
}
