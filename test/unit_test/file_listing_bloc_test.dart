import 'package:bloc_test/bloc_test.dart';
import 'package:file_app/file_listing/bloc/file_listing_bloc.dart';
import 'package:file_app/model/default_content.dart';
import 'package:file_app/model/file_entity.dart';
import 'package:file_app/model/file_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  group('File listing bloc', () {
    var platformServices = MockIPlatformServices();
    var fileBuilder = FileEntityBuilder()
      ..id = 'id'
      ..name = 'name'
      ..isDirectory = true
      ..path = 'path'
      ..uri = 'uri'
      ..size = 0
      ..type = FileType.file
      ..duration = 0;
    setUp(() {
      when(platformServices.getFiles('download'))
          .thenAnswer((realInvocation) async => [
                fileBuilder.build(),
                fileBuilder.build(),
                fileBuilder.build(),
                fileBuilder.build(),
                fileBuilder.build(),
              ]);
      when(platformServices.getFolderFiles(''))
          .thenAnswer((realInvocation) async => [
                fileBuilder.build(),
                fileBuilder.build(),
                fileBuilder.build(),
                fileBuilder.build(),
                fileBuilder.build(),
              ]);
    });
    blocTest(
      'emits [] when nothing is added',
      build: () => FileListingBloc(
        const FileListingState(
          groupName: '',
          files: [],
          status: FileListingStatus.loading,
          folderType: FolderType.directory,
        ),
        platformServices,
        '',
      ),
      expect: () => [],
    );

    blocTest<FileListingBloc, FileListingState>(
      'emits [loadingStatus, loadedStatus] when load file in folders is added',
      build: () => FileListingBloc(
        const FileListingState(
          groupName: '',
          files: [],
          status: FileListingStatus.loading,
          folderType: FolderType.directory,
        ),
        platformServices,
        '',
      ),
      act: (bloc) => bloc.add(LoadFilesInFolder('')),
      expect: () => [
        const FileListingState(
          groupName: '',
          files: [],
          status: FileListingStatus.loading,
          folderType: FolderType.directory,
        ),
        FileListingState(
          groupName: '',
          files: [
            fileBuilder.build(),
            fileBuilder.build(),
            fileBuilder.build(),
            fileBuilder.build(),
            fileBuilder.build(),
          ],
          status: FileListingStatus.loaded,
          folderType: FolderType.directory,
        )
      ],
    );

    blocTest<FileListingBloc, FileListingState>(
      'emits [loadingStatus, loadedStatus] when load file in category is added',
      build: () => FileListingBloc(
        const FileListingState(
          groupName: 'download',
          files: [],
          status: FileListingStatus.loading,
          folderType: FolderType.directory,
        ),
        platformServices,
        '',
      ),
      act: (bloc) => bloc.add(LoadCategoryFiles(DefaultContent.download)),
      expect: () => [
        const FileListingState(
          groupName: 'download',
          files: [],
          status: FileListingStatus.loading,
          folderType: FolderType.directory,
        ),
        FileListingState(
          groupName: 'download',
          files: [
            fileBuilder.build(),
            fileBuilder.build(),
            fileBuilder.build(),
            fileBuilder.build(),
            fileBuilder.build(),
          ],
          status: FileListingStatus.loaded,
          folderType: FolderType.directory,
        )
      ],
    );
  });
}
