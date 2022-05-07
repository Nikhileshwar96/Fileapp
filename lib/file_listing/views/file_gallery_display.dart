import 'package:file_app/file_listing/bloc/file_listing_bloc.dart';
import 'package:file_app/file_view/views/delete_confirmation_view.dart';
import 'package:file_app/file_view/views/file_display_page.dart';
import 'package:file_app/model/file_entity.dart';
import 'package:file_app/model/file_type.dart';
import 'package:file_app/providers/platform_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileGalleryPage extends StatefulWidget {
  final List<FileEntity> parentFile;
  final int currentFileIndex;
  const FileGalleryPage(
    this.parentFile,
    this.currentFileIndex, {
    Key? key,
  }) : super(key: key);

  @override
  State<FileGalleryPage> createState() => _FileGalleryPageState();
}

class _FileGalleryPageState extends State<FileGalleryPage> {
  List<FileEntity> fileList = [];
  PageController? pageController;
  FileEntity? currentFile;

  @override
  void initState() {
    fileList = widget.parentFile
        .where((element) => element.type != FileType.directory)
        .toList();
    currentFile = widget.parentFile[widget.currentFileIndex];
    var fileIndex = fileList.indexOf(currentFile!);
    pageController = PageController(initialPage: fileIndex);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentFile?.name ?? '',
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
                        currentFile!,
                      ),
                    ) ??
                    false;
                if (isDeleteConfirmed) {
                  Navigator.pop(context);
                  BlocProvider.of<FileListingBloc>(context)
                      .add(DeleteFile(currentFile!.path));
                }
              },
              icon: const Icon(
                Icons.delete,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              RepositoryProvider.of<IPlatformServices>(context).shareFile(
                currentFile!.uri,
              );
            },
            icon: const Icon(
              Icons.share,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: PageView.builder(
          controller: pageController,
          itemCount: widget.parentFile.length,
          itemBuilder: (fileContext, index) => FileDisplayPage(
            fileList[index],
          ),
          onPageChanged: (selectedPage) {
            setState(() {
              currentFile = fileList[selectedPage];
            });
          },
        ),
      ),
    );
  }
}
