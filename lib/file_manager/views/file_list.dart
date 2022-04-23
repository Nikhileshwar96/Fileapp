import 'dart:async';
import 'dart:typed_data';

import 'package:file_app/home/model/file_entity.dart';
import 'package:flutter/material.dart';

import '../../providers/platform_service_provider.dart';

class FileDisplay extends StatefulWidget {
  final Future<List<FileEntity>> filesFuture;
  const FileDisplay({
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
        title: const Text('Files'),
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
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            FutureBuilder<Uint8List>(
                              future: PlatformServices.getThumbnail(
                                  file.type, file.uri, file.id),
                              builder: (imageContext, imageSnapshot) {
                                return imageSnapshot.hasData
                                    ? SizedBox(
                                        child:
                                            Image.memory(imageSnapshot.data!),
                                        width: 50,
                                        height: 50,
                                      )
                                    : const Icon(Icons.image_not_supported);
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
