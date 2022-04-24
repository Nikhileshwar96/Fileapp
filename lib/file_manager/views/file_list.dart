import 'dart:async';
import 'dart:typed_data';

import 'package:file_app/file_manager/views/file_display_page.dart';
import 'package:file_app/home/model/file_entity.dart';
import 'package:flutter/material.dart';

import '../../providers/platform_service_provider.dart';

class FileDisplay extends StatefulWidget {
  final String fileName;
  final Future<List<FileEntity>> filesFuture;
  const FileDisplay({
    required this.fileName,
    required this.filesFuture,
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
        title: Text(widget.fileName),
      ),
      body: FutureBuilder<List<FileEntity>>(
        future: widget.filesFuture,
        builder: (cont, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No file present or couldn\'t read folder',
              ),
            );
          }

          var files = snapshot.data!;
          return files.isNotEmpty
              ? ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (_fileContext, _fileIndex) {
                    var file = files[_fileIndex];
                    return InkWell(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              file.type == 'dir'
                                  ? Image.asset('images/folder.png')
                                  : FutureBuilder<Uint8List>(
                                      future: PlatformServices().getThumbnail(
                                          file.type, file.uri, file.id),
                                      builder: (imageContext, imageSnapshot) {
                                        return imageSnapshot.hasData
                                            ? SizedBox(
                                                child: Image.memory(
                                                    imageSnapshot.data!),
                                                width: 50,
                                                height: 50,
                                              )
                                            : Image.asset(
                                                'images/${file.type}.png',
                                              );
                                      },
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
                        if (file.type == "dir") {
                          var fileEntity =
                              PlatformServices().getFolderFiles(file.uri);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (filePageCOntext) => FileDisplay(
                                fileName: file.name,
                                filesFuture: fileEntity,
                              ),
                            ),
                          );
                          return;
                        }

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (imageContext) => FileDisplayPage(file),
                          ),
                        );
                      },
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'No files to display',
                  ),
                );
        },
      ),
    );
  }
}
