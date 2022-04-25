import 'package:file_app/file_listing/bloc/file_listing_bloc.dart';
import 'package:file_app/file_listing/views/folder_list_view.dart';
import 'package:file_app/file_listing/views/image_list_view.dart';
import 'package:file_app/file_listing/views/video_list_view.dart';
import 'package:file_app/model/file_entity.dart';
import 'package:file_app/model/file_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'audio_list_view.dart';
import 'file_list_view.dart';

class FileDisplay extends StatefulWidget {
  const FileDisplay({
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
        title: BlocConsumer<FileListingBloc, FileListingState>(
          builder: (cont, fileListingState) => Text(fileListingState.groupName),
          listener: (listenerContext, state) => (state.message != null)
              ? ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message!,
                    ),
                  ),
                )
              : () {},
        ),
      ),
      body: BlocBuilder<FileListingBloc, FileListingState>(
        builder: (cont, fileListingState) {
          switch (fileListingState.status) {
            case FileListingStatus.loading:
              return const Center(
                child: Text(
                  'No files to display',
                ),
              );
            case FileListingStatus.loaded:
              var files = fileListingState.files;
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
            case FileListingStatus.error:
              return const Center(
                child: Text(
                  'No file present or couldn\'t read folder',
                ),
              );
          }
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
