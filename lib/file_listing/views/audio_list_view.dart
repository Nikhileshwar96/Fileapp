import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/file_entity.dart';
import '../../providers/platform_service_provider.dart';
import '../../file_view/views/file_display_page.dart';
import '../bloc/file_listing_bloc.dart';

class AudioListView extends StatelessWidget {
  final FileEntity file;

  const AudioListView(this.file, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              FutureBuilder<Uint8List>(
                future: RepositoryProvider.of<PlatformServices>(context)
                    .getThumbnail(file.type.name, file.uri, file.id),
                builder: (imageContext, imageSnapshot) {
                  return imageSnapshot.hasData
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (imageContext) => BlocProvider<FileListingBloc>.value(
              value: BlocProvider.of<FileListingBloc>(context),
              child: FileDisplayPage(file),
            ),
          ),
        );
      },
    );
  }
}
