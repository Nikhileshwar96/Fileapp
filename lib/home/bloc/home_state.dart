part of 'home_bloc.dart';

enum PermissionStatus {
  permissionGranted,
  permissionStatusUnaware,
  permissionDenied,
}

class HomeState extends Equatable {
  const HomeState({
    required this.contentTypes,
    this.permissionStatus = PermissionStatus.permissionStatusUnaware,
  });

  final PermissionStatus permissionStatus;
  final List<DefaultContent> contentTypes;

  @override
  List<Object?> get props => [permissionStatus];
}
