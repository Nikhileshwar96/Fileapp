import 'package:file_app/home/views/category_tiles.dart';
import 'package:flutter/material.dart';

import '../../file_manager/views/file_list.dart';
import '../../providers/platform_service_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Title(
                color: Colors.yellow,
                child: const Text('Explore'),
              ),
              SizedBox(
                child: Container(
                  child: InkWell(
                    child: const Card(
                      child: Text('All files'),
                    ),
                    onTap: () {
                      var videos = PlatformServices.getFolderFiles("");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (filePageCOntext) =>
                              FileDisplay(filesFuture: videos),
                        ),
                      );
                    },
                  ),
                  height: 100,
                  constraints: const BoxConstraints.expand(height: 100),
                ),
                height: 100,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: const [
                    CategoryTiles('Video'),
                    CategoryTiles('Image'),
                    CategoryTiles('Audio'),
                    CategoryTiles('Downloads'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
