abstract class FetcherCubitState<T> {}

class FetcherCubitLoadingState<T> implements FetcherCubitState<T> {}

class FetcherCubitErrorState<T> implements FetcherCubitState<T> {
  final String message;
  FetcherCubitErrorState({required this.message});
}

class FetcherCubitLoadedState<T> implements FetcherCubitState<T> {
  final T fetchedData;
  FetcherCubitLoadedState({required this.fetchedData});
}
