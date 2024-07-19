import 'package:app/src/data/services/station_requests.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

abstract class DependencyInjection {
  static Future<void> init() async {
    getIt.registerSingleton<Dio>(
      Dio(
        BaseOptions(
            baseUrl: kDebugMode
                ? 'http://localhost:3000'
                : 'https://autosense.henriquearrazao.com',
            headers: {'x-api-key': 'hardcoded-api-key'}),
      ),
    );
    getIt.registerFactory(
      () => StationRequests(dio: getIt()),
    );
  }
}
