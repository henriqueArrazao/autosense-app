part of 'station_manager_cubit.dart';

abstract class StationManagerState {}

class StationManagerInitialState extends StationManagerState {}

class StationManagerLoadingState extends StationManagerState {}

class StationManagerErrorState extends StationManagerState {
  final String message;
  StationManagerErrorState({required this.message});
}

class StationManagerSuccessState extends StationManagerState {
  final bool shouldMapBeRefreshed;
  StationManagerSuccessState({
    required this.shouldMapBeRefreshed,
  });
}
