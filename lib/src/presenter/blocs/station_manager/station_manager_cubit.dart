import 'package:app/src/data/models/station/station_create_model.dart';
import 'package:app/src/data/models/station/station_update_model.dart';
import 'package:app/src/data/services/station_requests.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'station_manager_state.dart';

class StationManagerCubit extends Cubit<StationManagerState> {
  final StationRequests stationRequests;

  StationManagerCubit({required this.stationRequests})
      : super(StationManagerInitialState());

  Future<void> createStation(StationCreateModel station) async {
    emit(StationManagerLoadingState());
    final result = await stationRequests.createStation(station: station);
    result.fold(
      (error) => emit(StationManagerErrorState(
        message: error.messageOrGeneralDefaultMessage,
      )),
      (station) => emit(StationManagerSuccessState(
        shouldMapBeRefreshed: true,
      )),
    );
  }

  Future<void> updateStation(StationUpdateModel station) async {
    emit(StationManagerLoadingState());
    final result = await stationRequests.updateStation(station: station);
    result.fold(
      (error) => emit(StationManagerErrorState(
          message: error.messageOrGeneralDefaultMessage)),
      (_) => emit(StationManagerSuccessState(
        shouldMapBeRefreshed: false,
      )),
    );
  }

  Future<void> deleteStation(int id) async {
    emit(StationManagerLoadingState());
    final result = await stationRequests.deleteStation(id: id);
    result.fold(
      (error) => emit(StationManagerErrorState(
          message: error.messageOrGeneralDefaultMessage)),
      (_) => emit(StationManagerSuccessState(
        shouldMapBeRefreshed: true,
      )),
    );
  }
}
