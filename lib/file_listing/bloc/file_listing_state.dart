part of 'file_listing_bloc.dart';

enum FileListingStatus { loading, loaded, error, loadingMore }

class FileListingState extends Equatable {
  final String groupName;
  final List<FileEntity> files;
  final FileListingStatus status;
  final FolderType folderType;
  final String? message;

  const FileListingState({
    required this.groupName,
    required this.files,
    required this.status,
    required this.folderType,
    this.message,
  });

  @override
  List<Object?> get props => [groupName, files, message, status];
}

enum FolderType { categories, directory }
