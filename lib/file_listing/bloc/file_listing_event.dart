part of 'file_listing_bloc.dart';

class FileListingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFilesInFolder extends FileListingEvent {
  final String folderPath;

  LoadFilesInFolder(this.folderPath);

  @override
  List<Object?> get props => [folderPath];
}

class LoadCategoryFiles extends FileListingEvent {
  final DefaultContent content;

  LoadCategoryFiles(this.content);

  @override
  List<Object?> get props => [content];
}

class DeleteFile extends FileListingEvent {
  final String filePath;

  DeleteFile(this.filePath);

  @override
  List<Object?> get props => [filePath];
}
