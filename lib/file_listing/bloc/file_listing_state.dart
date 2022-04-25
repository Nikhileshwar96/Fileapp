part of 'file_listing_bloc.dart';

enum FileListingStatus { loading, loaded, error }

class FileListingState extends Equatable {
  final String groupName;
  final List<FileEntity> files;
  final FileListingStatus status;

  const FileListingState({
    required this.groupName,
    required this.files,
    required this.status,
  });

  @override
  List<Object?> get props => [groupName, files];
}
