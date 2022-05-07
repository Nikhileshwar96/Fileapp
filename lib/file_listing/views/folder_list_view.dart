import 'package:file_app/file_listing/bloc/file_listing_bloc.dart';
import 'package:file_app/model/file_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../providers/platform_service_provider.dart';
import 'file_list.dart';

class FolderListView extends StatelessWidget {
  final FileEntity file;

  const FolderListView(
    this.file, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                'images/folder.png',
                height: 50,
                width: 50,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  file.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (filePageContext) => BlocProvider(
              create: (blocCreatorContext) => FileListingBloc(
                FileListingState(
                  groupName: file.name,
                  files: const [],
                  status: FileListingStatus.loading,
                  folderType: FolderType.directory,
                ),
                RepositoryProvider.of<IPlatformServices>(context),
                file.path,
              )..add(LoadFilesInFolder(file.path)),
              child: const FileDisplay(),
            ),
          ),
        );
        return;
      },
    );
  }
}
