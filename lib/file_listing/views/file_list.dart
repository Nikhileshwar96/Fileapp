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
  ScrollController? listController;
  FileListingBloc? fileListBLoc;
  int currentFilesCount = 0;

  @override
  void initState() {
    listController = ScrollController();
    listController?.addListener(handleListScroll);
    super.initState();
  }

  @override
  void dispose() {
    listController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocConsumer<FileListingBloc, FileListingState>(
          builder: (cont, fileListingState) => Text(
            fileListingState.groupName,
            key: Key(
              'listing_title_${fileListingState.groupName}',
            ),
          ),
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
          fileListBLoc ??= BlocProvider.of<FileListingBloc>(context);

          switch (fileListingState.status) {
            case FileListingStatus.loading:
              return const Center(
                child: Text(
                  'Loading',
                  key: Key('loading_placeholder'),
                ),
              );
            case FileListingStatus.loaded:
            case FileListingStatus.loadingMore:
              currentFilesCount = fileListingState.files.length +
                  (fileListingState.status == FileListingStatus.loadingMore
                      ? 1
                      : 0);
              var files = fileListingState.files;
              return files.isNotEmpty
                  ? ListView.builder(
                      itemCount: files.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_fileContext, _fileIndex) {
                        var file = files[_fileIndex];
                        if (_fileIndex < fileListingState.files.length) {
                          return getFileView(file);
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                      controller: listController,
                    )
                  : const Center(
                      child: Text(
                        'No files to display',
                        key: Key('empty_placeholder'),
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

  void handleListScroll() {
    if (listController?.position.outOfRange ?? false) {
      fileListBLoc?.add(LoadMoreFiles(currentFilesCount));
    }
  }
}
