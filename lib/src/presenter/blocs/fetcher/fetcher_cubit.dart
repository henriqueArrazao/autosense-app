import 'package:app/src/data/models/utils/api_error.dart';
import 'package:app/src/presenter/blocs/fetcher/fetcher_cubit_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

abstract class FetcherCubit<T> extends Cubit<FetcherCubitState<T>> {
  final Future<Either<ApiError, T>> Function() _request;
  FetcherCubit({
    required Future<Either<ApiError, T>> Function() request,
  })  : _request = request,
        super(FetcherCubitLoadingState()) {
    load();
  }

  void load() {
    emit(FetcherCubitLoadingState());
    _request().then(
      (response) => response.fold(
        (error) => emit(FetcherCubitErrorState(
          message: error.messageOrGeneralDefaultMessage,
        )),
        (data) => emit(FetcherCubitLoadedState(fetchedData: data)),
      ),
    );
  }

  void refresh() => load();
}
