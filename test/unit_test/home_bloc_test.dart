import 'package:bloc_test/bloc_test.dart';
import 'package:file_app/home/bloc/home_bloc.dart';
import 'package:file_app/model/default_content.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  group('Home bloc', () {
    var platformServices = MockIPlatformServices();

    setUpAll(() {
      when(platformServices.checkStoragePermission())
          .thenAnswer((realInvocation) async => true);
    });

    blocTest<HomeBloc, HomeState>(
      'emits [] when nothing is added',
      build: () => HomeBloc(
        HomeState(
          contentTypes: DefaultContent.values.toList(),
        ),
        platformServices,
      ),
      expect: () => [],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [permission granted] when check permission event is added',
      build: () => HomeBloc(
        HomeState(
          contentTypes: DefaultContent.values.toList(),
        ),
        platformServices,
      ),
      act: (bloc) => bloc.add(CheckPermission()),
      expect: () => [
        HomeState(
          contentTypes: DefaultContent.values.toList(),
          permissionStatus: PermissionStatus.permissionGranted,
        )
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [permission denied] when check permission event is added and fails',
      build: () {
        when(platformServices.checkStoragePermission())
            .thenAnswer((realInvocation) async => false);
        when(platformServices.requestStoragePermission())
            .thenAnswer((realInvocation) async => false);
        return HomeBloc(
          HomeState(
            contentTypes: DefaultContent.values.toList(),
          ),
          platformServices,
        );
      },
      act: (bloc) => bloc.add(CheckPermission()),
      expect: () => [
        HomeState(
          contentTypes: DefaultContent.values.toList(),
          permissionStatus: PermissionStatus.permissionDenied,
        )
      ],
    );
  });
}
