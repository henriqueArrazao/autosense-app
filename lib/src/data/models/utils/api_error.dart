import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ApiError {
  final String? message;
  ApiError({this.message});

  static Future<Either<ApiError, T>> requestHandler<T>(
    Future<T> Function() request,
  ) async {
    try {
      return Right(await request());
    } on DioException catch (e) {
      print(e);
      return Left(ApiError.fromDioException(e));
    } catch (e) {
      print(e);
      return Left(ApiError());
    }
  }

  static ApiError fromDioException(DioException e) {
    final body = e.response?.data;
    if (body is Map<String, dynamic>) {
      return ApiError(message: body['message']);
    } else {
      return ApiError();
    }
  }

  String get messageOrGeneralDefaultMessage =>
      message ?? 'Something went wrong. Please try again later.';
}
