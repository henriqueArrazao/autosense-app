import 'package:app/src/data/models/station/station_create_model.dart';
import 'package:app/src/data/models/station/station_detailed_model.dart';
import 'package:app/src/data/models/station/station_simple_model.dart';
import 'package:app/src/data/models/station/station_update_model.dart';
import 'package:app/src/data/models/utils/api_error.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class StationRequests {
  static const _stationsBaseUrl = '/stations';
  final Dio dio;
  StationRequests({required this.dio});

  Future<Either<ApiError, List<StationSimpleModel>>> getAllStations() async {
    return ApiError.requestHandler(() async {
      final response = await dio.get(_stationsBaseUrl);
      return (response.data as List)
          .map((stationJson) => StationSimpleModel.fromJson(stationJson))
          .toList();
    });
  }

  Future<Either<ApiError, StationDetailedModel>> getStationById({
    required int id,
  }) async {
    return ApiError.requestHandler(() async {
      final response = await dio.get('$_stationsBaseUrl/$id');
      return StationDetailedModel.fromJson(response.data);
    });
  }

  Future<Either<ApiError, void>> updateStation({
    required StationUpdateModel station,
  }) async {
    return ApiError.requestHandler(() {
      return dio.put('$_stationsBaseUrl/${station.id}', data: station.toJson());
    });
  }

  Future<Either<ApiError, void>> createStation({
    required StationCreateModel station,
  }) async {
    return ApiError.requestHandler(() {
      return dio.post(_stationsBaseUrl, data: station.toJson());
    });
  }

  Future<Either<ApiError, void>> deleteStation({required int id}) async {
    return ApiError.requestHandler(() {
      return dio.delete('$_stationsBaseUrl/$id');
    });
  }
}
