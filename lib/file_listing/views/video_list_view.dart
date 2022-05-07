import 'dart:typed_data';

import 'package:file_app/model/file_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../providers/platform_service_provider.dart';

class VideoListView extends StatelessWidget {
  final FileEntity file;
  final Function onClick;
  const VideoListView(
    this.file,
    this.onClick, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              FutureBuilder<Uint8List>(
                future: RepositoryProvider.of<IPlatformServices>(context)
                    .getThumbnail(file.type.name, file.uri, file.id),
                builder: (imageContext, imageSnapshot) {
                  return imageSnapshot.hasData && imageSnapshot.data!.isNotEmpty
                      ? SizedBox(
                          child: Image.memory(imageSnapshot.data!),
                          width: 50,
                          height: 50,
                        )
                      : Image.asset(
                          'images/${file.type}_logo.png',
                          height: 50,
                          width: 50,
                        );
                },
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
        onClick();
      },
    );
  }
}
