import 'package:file_app/home/model/file_entity.dart';
import 'package:flutter/material.dart';

import '../../providers/platform_service_provider.dart';
import 'file_list.dart';

class FolderListView extends StatelessWidget {
  final FileEntity file;
  const FolderListView(this.file, {Key? key}) : super(key: key);

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
        var fileEntity = PlatformServices().getFolderFiles(file.path);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (filePageCOntext) => FileDisplay(
              fileName: file.name,
              filesFuture: fileEntity,
            ),
          ),
        );
        return;
      },
    );
  }
}
