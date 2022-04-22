import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const FileApp());
}

class FileApp extends StatelessWidget {
  const FileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FileDisplay(),
    );
  }
}

class FileDisplay extends StatefulWidget {
  const FileDisplay({
    Key? key,
  }) : super(key: key);

  @override
  State<FileDisplay> createState() => _FileDisplayState();
}

class _FileDisplayState extends State<FileDisplay> {
  Completer<List<String>> filesCompleter = Completer<List<String>>();

  @override
  void initState() {
    getFiles();
    super.initState();
  }

  getFiles() async {
    if (await Permission.storage.isRestricted) {
      Permission.storage.request();
    }

    var directoryList = await getExternalStorageDirectories();
    filesCompleter.complete(directoryList?.map<String>((e) => e.path).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
      ),
      body: FutureBuilder<List<String>>(
        future: filesCompleter.future,
        builder: (_fileListContext, _fileListSnapshot) {
          return _fileListSnapshot.hasData
              ? ListView.builder(
                  itemCount: _fileListSnapshot.data?.length ?? 0,
                  itemBuilder: (_fileContext, _fileIndex) {
                    var file = _fileListSnapshot.data![_fileIndex];
                    return Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(file),
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
