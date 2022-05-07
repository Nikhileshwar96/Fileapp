import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:file_app/constants.dart';
import 'package:file_app/model/default_content.dart';
import 'package:file_app/model/file_entity.dart';
import 'package:file_app/providers/platform_service_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'file_listing_event.dart';
part 'file_listing_state.dart';

class FileListingBloc extends Bloc<FileListingEvent, FileListingState> {
  IPlatformServices platformServices;
  String searchPath;
  FileListingBloc(
    FileListingState initialState,
    this.platformServices,
    this.searchPath,
  ) : super(initialState) {
    on<LoadFilesInFolder>(loadFiles);
    on<LoadCategoryFiles>(loadCategoryFiles);
    on<DeleteFile>(deleteFile);
    on<LoadMoreFiles>(loadMoreFiles);
  }

  loadFiles(LoadFilesInFolder event, Emitter<FileListingState> emit) async {
    emit(
      FileListingState(
        groupName: state.groupName,
        files: const [],
        status: FileListingStatus.loading,
        folderType: state.folderType,
      ),
    );
    var files = await platformServices.getFolderFiles(
      event.folderPath.toLowerCase() == 'internal storage'
          ? ''
          : event.folderPath,
      0,
      queryTakeCount,
    );
    emit(
      FileListingState(
        groupName: state.groupName,
        files: files,
        status: FileListingStatus.loaded,
        folderType: state.folderType,
      ),
    );
  }

  loadCategoryFiles(
      LoadCategoryFiles event, Emitter<FileListingState> emit) async {
    emit(
      FileListingState(
        groupName: state.groupName,
        files: const [],
        status: FileListingStatus.loading,
        folderType: state.folderType,
      ),
    );

    var files = await platformServices.getFiles(
      event.content.name,
      0,
      queryTakeCount,
    );
    emit(
      FileListingState(
        groupName: state.groupName,
        files: files,
        status: FileListingStatus.loaded,
        folderType: state.folderType,
      ),
    );
  }

  deleteFile(DeleteFile event, Emitter<FileListingState> emit) async {
    emit(
      FileListingState(
        groupName: state.groupName,
        files: const [],
        status: FileListingStatus.loading,
        folderType: state.folderType,
      ),
    );

    bool isDeleted = await platformServices.deleteFile(event.filePath);

    var files = state.folderType == FolderType.categories
        ? await platformServices.getFiles(
            searchPath,
            0,
            queryTakeCount,
          )
        : await platformServices.getFolderFiles(
            searchPath.toLowerCase() == 'internal storage' ? '' : searchPath,
            0,
            queryTakeCount,
          );
    emit(
      FileListingState(
          groupName: state.groupName,
          files: files,
          status: FileListingStatus.loaded,
          folderType: state.folderType,
          message: isDeleted ? 'Deleted successfully' : 'Deleting failed'),
    );
  }

  FutureOr<void> loadMoreFiles(
      LoadMoreFiles event, Emitter<FileListingState> emit) async {
    if (state.status == FileListingStatus.loadingMore) {
      return;
    }

    var fileCache = state.files;

    emit(
      FileListingState(
        groupName: state.groupName,
        files: state.files,
        status: FileListingStatus.loadingMore,
        folderType: state.folderType,
      ),
    );

    var files = state.folderType == FolderType.categories
        ? await platformServices.getFiles(
            searchPath,
            event.currentFilesCount,
            queryTakeCount,
          )
        : await platformServices.getFolderFiles(
            searchPath.toLowerCase() == 'internal storage' ? '' : searchPath,
            event.currentFilesCount,
            queryTakeCount,
          );

    fileCache.addAll(files);

    emit(
      FileListingState(
        groupName: state.groupName,
        files: fileCache,
        status: FileListingStatus.loaded,
        folderType: state.folderType,
      ),
    );
  }
}
