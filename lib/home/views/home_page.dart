import 'package:file_app/constants.dart';
import 'package:file_app/file_listing/bloc/file_listing_bloc.dart';
import 'package:file_app/home/bloc/home_bloc.dart';
import 'package:file_app/home/views/category_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../file_listing/views/file_list.dart';
import '../../providers/platform_service_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Files',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Container(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) => InkWell(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/folder.png',
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                externalDirectoryName,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: state.permissionStatus ==
                              PermissionStatus.permissionGranted
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (filePageCOntext) =>
                                      BlocProvider<FileListingBloc>(
                                    create: (blocCreatorContext) =>
                                        FileListingBloc(
                                      const FileListingState(
                                          groupName: externalDirectoryName,
                                          files: [],
                                          status: FileListingStatus.loading,
                                          folderType: FolderType.directory),
                                      RepositoryProvider.of<IPlatformServices>(
                                          context),
                                      externalDirectoryName,
                                    )..add(
                                            LoadFilesInFolder(
                                              externalDirectoryName,
                                            ),
                                          ),
                                    child: const FileDisplay(),
                                  ),
                                ),
                              );
                            }
                          : () =>
                              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Permission is required to explore device sorage'),
                                ),
                              ),
                    ),
                  ),
                  constraints: const BoxConstraints.expand(height: 60),
                ),
                height: 60,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                constraints: const BoxConstraints.expand(height: 50),
                child: const Text('Categories'),
              ),
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  bloc: BlocProvider.of<HomeBloc>(context),
                  builder: (homeBlocContext, homeState) => GridView.builder(
                    itemCount: homeState.contentTypes.length,
                    itemBuilder: (categoryItemContext, categoryIndex) =>
                        SizedBox(
                      height: 80,
                      child: CategoryTiles(
                        homeState.contentTypes[categoryIndex],
                      ),
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0,
                      childAspectRatio: MediaQuery.of(context).size.width > 0
                          ? MediaQuery.of(context).size.width / 250
                          : 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
