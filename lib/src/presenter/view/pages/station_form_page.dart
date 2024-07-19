import 'package:app/src/data/models/pump/pump_editing_model.dart';
import 'package:app/src/data/models/station/station_create_model.dart';
import 'package:app/src/data/models/station/station_update_model.dart';
import 'package:app/src/data/services/station_requests.dart';
import 'package:app/src/dependency_injection.dart';
import 'package:app/src/presenter/blocs/detailed_station_fetcher/detailed_station_fetcher_cubit.dart';
import 'package:app/src/presenter/blocs/station_manager/station_manager_cubit.dart';
import 'package:app/src/presenter/view/pages/pump_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/fetcher_cubit_handler.dart';

class StationFormPage extends StatefulWidget {
  final int? stationId;
  final double latitude;
  final double longitude;
  const StationFormPage({
    required this.stationId,
    required this.latitude,
    required this.longitude,
    Key? key,
  }) : super(key: key);

  @override
  _StationFormPageState createState() => _StationFormPageState();
}

class _StationFormPageState extends State<StationFormPage> {
  late final DetailedStationFetcherCubit fetcherCubit;
  late final StationManagerCubit cubit;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  List<PumpEditingModel> _pumps = [];
  late final bool isCreating = widget.stationId == null;

  @override
  void initState() {
    super.initState();
    fetcherCubit = DetailedStationFetcherCubit(
      id: widget.stationId,
      stationRequests: getIt<StationRequests>(),
    );
    cubit = StationManagerCubit(
      stationRequests: getIt<StationRequests>(),
    );
  }

  void _createStation() {
    if (_formKey.currentState!.validate()) {
      final station = StationCreateModel(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        latitude: widget.latitude,
        longitude: widget.longitude,
        pumps: _pumps.map((pump) => pump.forceParseToPumpModel()).toList(),
      );

      cubit.createStation(station);
    }
  }

  void _updateStation() {
    if (_formKey.currentState!.validate()) {
      final station = StationUpdateModel(
        id: widget.stationId!,
        name: _nameController.text.trim(),
        pumps: _pumps.map((pump) => pump.forceParseToPumpModel()).toList(),
      );

      cubit.updateStation(station);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => fetcherCubit,
      child: BlocListener<DetailedStationFetcherCubit,
          DetailedStationFetcherState>(
        listener: (context, state) {
          if (state is DetailedStationFetcherLoadedState &&
              state.fetchedData != null) {
            final fetchedData = state.fetchedData!;
            setState(() {
              _nameController.text = fetchedData.name;
              _addressController.text = fetchedData.address;
              _cityController.text = fetchedData.city;
              _pumps = fetchedData.pumps.map((pump) {
                return PumpEditingModel(
                  available: pump.available,
                  fuelType: pump.fuelType,
                  price: pump.price,
                );
              }).toList();
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Station Management'),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.save,
                  color: Colors.green,
                ),
                onPressed: () {
                  if (widget.stationId != null) {
                    _updateStation();
                  } else {
                    _createStation();
                  }
                },
              ),
              if (widget.stationId != null)
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    cubit.deleteStation(widget.stationId!);
                  },
                ),
            ],
          ),
          body: Builder(builder: (context) {
            return FetcherCubitStateHandler(
              cubit: fetcherCubit,
              onLoaded: (data) {
                return BlocProvider(
                  create: (context) => cubit,
                  child: BlocConsumer<StationManagerCubit, StationManagerState>(
                    listener: (context, state) {
                      if (state is StationManagerErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                          ),
                        );
                      } else if (state is StationManagerSuccessState) {
                        Navigator.of(context).pop(state.shouldMapBeRefreshed);
                      }
                    },
                    listenWhen: (prev, _) => prev is StationManagerLoadingState,
                    builder: (context, state) {
                      if (state is StationManagerLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return PopScope(
                        canPop: state is! StationManagerLoadingState,
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Name'),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter the name';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    enabled: isCreating,
                                    controller: _addressController,
                                    decoration: const InputDecoration(
                                        labelText: 'Address'),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter the address';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    enabled: isCreating,
                                    controller: _cityController,
                                    decoration: const InputDecoration(
                                        labelText: 'City'),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter the city';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                  Column(
                                    children: _pumps.map((pump) {
                                      final index = _pumps.indexOf(pump);
                                      return PumpForm(
                                        isStationBeingCreated: isCreating,
                                        pump: pump,
                                        onChange: (pump) {
                                          setState(() {
                                            _pumps.replaceRange(
                                              index,
                                              index + 1,
                                              [pump],
                                            );
                                          });
                                        },
                                        onRemove: () {
                                          setState(() {
                                            _pumps.removeAt(index);
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  if (isCreating)
                                    ElevatedButton.icon(
                                      label: const Text('Add Pump'),
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          _pumps.add(PumpEditingModel());
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
