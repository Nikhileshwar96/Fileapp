import 'package:file_app/providers/platform_Service_provider.dart';
import 'package:flutter/material.dart';

import '../../file_manager/views/file_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'File manager',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            InkWell(
              child: Card(
                child: Column(
                  children: const [Icon(Icons.video_file), Text('Video')],
                ),
              ),
              onTap: () async {
                var videos = PlatformServices.getVideos();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (filePageCOntext) =>
                      FileDisplay(filesFuture: videos),
                ));
              },
            ),
            InkWell(
              child: Card(
                child: Column(
                  children: const [Icon(Icons.image), Text('Image')],
                ),
              ),
              onTap: () async {
                var videos = PlatformServices.getVideos();
                FileDisplay(filesFuture: videos);
              },
            ),
            InkWell(
              child: Card(
                child: Column(
                  children: const [Icon(Icons.download), Text('Download')],
                ),
              ),
              onTap: () {},
            ),
            InkWell(
              child: Card(
                child: Column(
                  children: const [Icon(Icons.file_open), Text('Files')],
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
