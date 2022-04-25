import 'package:equatable/equatable.dart';
import 'package:file_app/home/model/default_content.dart';
import 'package:file_app/home/model/file_entity.dart';
import 'package:file_app/providers/platform_service_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'file_listing_event.dart';
part 'file_listing_state.dart';

class FileListingBloc extends Bloc<FileListingEvent, FileListingState> {
  PlatformServices platformServices;
  FileListingBloc(FileListingState initialState, this.platformServices)
      : super(initialState) {
    on<LoadFilesInFolder>(loadFiles);
    on<LoadCategoryFiles>(loadCategoryFiles);
  }

  loadFiles(LoadFilesInFolder event, Emitter<FileListingState> emit) async {
    emit(
      FileListingState(
        groupName: state.groupName,
        files: const [],
        status: FileListingStatus.loading,
      ),
    );
    var files = await platformServices.getFolderFiles(
      event.folderPath.toLowerCase() == 'internal storage'
          ? ''
          : event.folderPath,
    );
    emit(
      FileListingState(
        groupName: state.groupName,
        files: files,
        status: FileListingStatus.loaded,
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
      ),
    );
    var files = await platformServices.getFiles(event.content.name);
    emit(
      FileListingState(
          groupName: state.groupName,
          files: files,
          status: FileListingStatus.loaded),
    );
  }
}
