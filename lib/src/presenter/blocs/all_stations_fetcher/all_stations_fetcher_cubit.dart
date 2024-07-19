import 'package:app/src/data/models/station/station_simple_model.dart';
import 'package:app/src/data/services/station_requests.dart';
import 'package:app/src/presenter/blocs/fetcher/fetcher_cubit.dart';
import 'package:app/src/presenter/blocs/fetcher/fetcher_cubit_state.dart';

typedef AllStationsFetcherState = FetcherCubitState<List<StationSimpleModel>>;

class AllStationsFetcherCubit extends FetcherCubit<List<StationSimpleModel>> {
  AllStationsFetcherCubit({
    required StationRequests stationRequests,
  }) : super(
          request: () => stationRequests.getAllStations(),
        );
}
