import 'package:file_app/file_listing/bloc/file_listing_bloc.dart';
import 'package:file_app/model/default_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../file_listing/views/file_list.dart';
import '../../providers/platform_service_provider.dart';
import '../bloc/home_bloc.dart';

class CategoryTiles extends StatelessWidget {
  final DefaultContent category;
  const CategoryTiles(
    this.category, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          bottom: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/${category.name}.png',
              height: 40,
              width: 40,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(getCategoryName(category, context) ?? category.name)
          ],
        ),
      ),
      onTap: BlocProvider.of<HomeBloc>(context).state.permissionStatus ==
              PermissionStatus.permissionGranted
          ? () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (filePageCOntext) => BlocProvider<FileListingBloc>(
                    create: (blocCreatorContext) => FileListingBloc(
                      FileListingState(
                        groupName: category.name,
                        files: const [],
                        status: FileListingStatus.loading,
                        folderType: FolderType.categories,
                      ),
                      RepositoryProvider.of<IPlatformServices>(context),
                      category.name,
                    )..add(LoadCategoryFiles(category)),
                    child: const FileDisplay(),
                  ),
                ),
              );
            }
          : () => ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                const SnackBar(
                  content:
                      Text('Permission is required to explore device sorage'),
                ),
              ),
    );
  }

  String? getCategoryName(
    DefaultContent content,
    BuildContext context,
  ) {
    switch (content) {
      case DefaultContent.video:
        return AppLocalizations.of(context)?.video;
      case DefaultContent.image:
        return AppLocalizations.of(context)?.image;
      case DefaultContent.download:
        return AppLocalizations.of(context)?.download;
      case DefaultContent.audio:
        return AppLocalizations.of(context)?.audio;
    }

    return null;
  }
}
