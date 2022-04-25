import 'package:file_app/home/model/file_entity.dart';
import 'package:flutter/material.dart';

class DeleteConfirmationView extends StatelessWidget {
  final FileEntity file;
  const DeleteConfirmationView(this.file, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 12,
          ),
          Text(
            'Are you sure you want to delete ${file.name}',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop<bool>(context, true);
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Yes delete!',
                ),
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
