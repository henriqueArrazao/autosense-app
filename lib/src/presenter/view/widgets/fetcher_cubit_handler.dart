import 'package:app/src/presenter/blocs/fetcher/fetcher_cubit.dart';
import 'package:app/src/presenter/blocs/fetcher/fetcher_cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetcherCubitStateHandler<T> extends StatelessWidget {
  final FetcherCubit<T> cubit;
  final Widget Function(T state) onLoaded;
  const FetcherCubitStateHandler({
    required this.cubit,
    required this.onLoaded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetcherCubit<T>, FetcherCubitState>(
      bloc: cubit,
      builder: (context, state) {
        if (cubit.state is FetcherCubitLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (cubit.state is FetcherCubitErrorState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton.outlined(
                    onPressed: cubit.refresh,
                    icon: const Icon(Icons.refresh),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    (cubit.state as FetcherCubitErrorState).message,
                  )
                ],
              ),
            ),
          );
        }

        return onLoaded((cubit.state as FetcherCubitLoadedState).fetchedData);
      },
    );
  }
}
