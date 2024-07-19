import 'package:app/src/data/models/station/station_detailed_model.dart';
import 'package:app/src/data/models/utils/api_error.dart';
import 'package:app/src/data/services/station_requests.dart';
import 'package:app/src/presenter/blocs/fetcher/fetcher_cubit.dart';
import 'package:app/src/presenter/blocs/fetcher/fetcher_cubit_state.dart';
import 'package:dartz/dartz.dart';

typedef DetailedStationFetcherState = FetcherCubitState<StationDetailedModel?>;
typedef DetailedStationFetcherLoadedState
    = FetcherCubitLoadedState<StationDetailedModel?>;

class DetailedStationFetcherCubit extends FetcherCubit<StationDetailedModel?> {
  DetailedStationFetcherCubit({
    required int? id,
    required StationRequests stationRequests,
  }) : super(
          request: () async => id == null
              ? Future.value(const Right<ApiError, StationDetailedModel?>(null))
              : stationRequests.getStationById(id: id),
        );
}
