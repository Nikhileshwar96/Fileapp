import 'package:flutter/material.dart';

import '../../file_manager/views/file_list.dart';
import '../../providers/platform_service_provider.dart';

class CategoryTiles extends StatelessWidget {
  final String category;
  const CategoryTiles(
    this.category, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Column(
          children: [
            const Expanded(
              child: Icon(
                Icons.video_file,
              ),
            ),
            Text(category)
          ],
        ),
      ),
      onTap: () async {
        var fileEntity = PlatformServices.getFiles(category);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (filePageCOntext) => FileDisplay(filesFuture: fileEntity),
          ),
        );
      },
    );
  }
}
