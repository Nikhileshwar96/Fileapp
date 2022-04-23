import 'package:file_app/home/views/home_page.dart';
import 'package:flutter/material.dart';

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
      home: const HomePage(),
    );
  }
}
