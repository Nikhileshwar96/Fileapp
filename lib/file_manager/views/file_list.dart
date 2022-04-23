import 'dart:async';

import 'package:file_app/home/model/file_entity.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
                            const Icon(Icons.file_copy),
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
