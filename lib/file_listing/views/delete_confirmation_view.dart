import 'package:file_app/home/model/file_entity.dart';
import 'package:file_app/providers/platform_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteConfirmationView extends StatelessWidget {
  final FileEntity file;
  const DeleteConfirmationView(this.file, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Are you sure you want to delete ${file.name}',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  RepositoryProvider.of<PlatformServices>(context)
                      .deleteFile(file.uri);
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    const SnackBar(
                      content: Text('Deleted successfully'),
                    ),
                  );
                  Navigator.pop<bool>(context, true);
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop<bool>(context, false);
                },
                child: const Text('No'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
