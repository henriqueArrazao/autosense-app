import 'package:app/src/data/services/station_requests.dart';
import 'package:app/src/dependency_injection.dart';
import 'package:app/src/presenter/blocs/all_stations_fetcher/all_stations_fetcher_cubit.dart';
import 'package:app/src/presenter/view/pages/station_form_page.dart';
import 'package:app/src/presenter/view/widgets/fetcher_cubit_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AllStationsFetcherCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = AllStationsFetcherCubit(
      stationRequests: getIt<StationRequests>(),
    );
  }

  void _upsertStation(
    int? stationId,
    double latitude,
    double longitude,
  ) async {
    final shouldRefresh = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return StationFormPage(
            stationId: stationId,
            latitude: latitude,
            longitude: longitude,
          );
        },
      ),
    );

    if (shouldRefresh) {
      cubit.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllStationsFetcherCubit(
        stationRequests: getIt<StationRequests>(),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(47.377645, 8.540079),
                initialZoom: 13,
                minZoom: 10,
                maxZoom: 18,
                onLongPress: (tapPosition, point) async {
                  _upsertStation(
                    null,
                    point.latitude,
                    point.longitude,
                  );
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  tileBuilder: (context, widget, tile) {
                    return widget;
                  },
                ),
                FetcherCubitStateHandler(
                    cubit: cubit,
                    onLoaded: (stations) {
                      if (stations.isEmpty) {
                        return Container();
                      }

                      return MarkerLayer(
                        markers: stations
                            .map(
                              (station) => Marker(
                                point:
                                    LatLng(station.latitude, station.longitude),
                                child: GestureDetector(
                                  onTap: () => _upsertStation(
                                    station.id,
                                    station.latitude,
                                    station.longitude,
                                  ),
                                  onLongPress: () => _upsertStation(
                                    station.id,
                                    station.latitude,
                                    station.longitude,
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }),
                Positioned(
                  bottom: kBottomNavigationBarHeight + 20,
                  right: 20,
                  left: 20,
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('- Long press where you want to add a station'),
                          Text('- Click on a station to edit or delete it'),
                          Text('- Only name and prices are editable'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
