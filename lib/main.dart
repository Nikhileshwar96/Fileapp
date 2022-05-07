import 'package:file_app/home/bloc/home_bloc.dart';
import 'package:file_app/home/views/home_page.dart';
import 'package:file_app/model/default_content.dart';
import 'package:file_app/providers/platform_service_implementation.dart';
import 'package:file_app/providers/platform_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const FileApp());
}

class FileApp extends StatelessWidget {
  const FileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IPlatformServices>(
      create: (providerContext) => PlatformServicesProvider(),
      child: Builder(
        builder: (providerInjectContext) => BlocProvider<HomeBloc>(
          create: (homeBlocProviderContext) => HomeBloc(
            HomeState(
              contentTypes: DefaultContent.values.toList(),
            ),
            RepositoryProvider.of<IPlatformServices>(providerInjectContext),
          )..add(CheckPermission()),
          child: MaterialApp(
            title: 'File App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('hi', ''),
              Locale('ta', '')
            ],
            home: const HomePage(),
          ),
        ),
      ),
    );
  }
}
