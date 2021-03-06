import 'package:file_app/providers/platform_service_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/default_content.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  IPlatformServices platformServices;
  HomeBloc(initialState, this.platformServices) : super(initialState) {
    on<CheckPermission>(checkPermission);
  }

  checkPermission(CheckPermission event, Emitter<HomeState> emit) async {
    if (await platformServices.checkStoragePermission()) {
      emit(
        HomeState(
          contentTypes: state.contentTypes,
          permissionStatus: PermissionStatus.permissionGranted,
        ),
      );

      return;
    }

    var permissionResult = await platformServices.requestStoragePermission();
    emit(
      HomeState(
        contentTypes: state.contentTypes,
        permissionStatus: permissionResult
            ? PermissionStatus.permissionGranted
            : PermissionStatus.permissionDenied,
      ),
    );
  }
}
