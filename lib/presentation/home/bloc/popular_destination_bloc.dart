import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_e1/core/errors/failures.dart';
import 'package:flutter_architecture_e1/data/models/destination_model.dart';
import 'package:flutter_architecture_e1/data/repositories/destination_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_destination_event.dart';
part 'popular_destination_state.dart';

class PopularDestinationBloc
    extends Bloc<PopularDestinationEvent, PopularDestinationState> {
  final DestinationRepository _repository;

  PopularDestinationBloc({required DestinationRepository destinationRepository})
    : _repository = destinationRepository,
      super(const PopularDestinationInitial()) {
    on<FetchPopularDestinationsEvent>(_fetchPopularDestination);
    on<RefreshPopularDestinationsEvent>(_refreshPopularDestination);
  }

  Future<void> _fetchPopularDestination(
    FetchPopularDestinationsEvent event,
    Emitter<PopularDestinationState> emit,
  ) async {
    /// avoid re-fetch if already loaded
    if (state is PopularDestinationLoaded) {
      return;
    }

    emit(const PopularDestinationLoading());

    final result = await _repository.fetchPopular();
    result.fold(
      (failure) {
        emit(PopularDestinationFailed(failure: failure));
      },
      (destinations) {
        emit(PopularDestinationLoaded(destinations: destinations));
      },
    );
  }

  Future<void> _refreshPopularDestination(
    RefreshPopularDestinationsEvent event,
    Emitter<PopularDestinationState> emit,
  ) async {
    emit(const PopularDestinationLoading());

    final result = await _repository.fetchPopular();
    result.fold(
      (failure) {
        emit(PopularDestinationFailed(failure: failure));
      },
      (destinations) {
        emit(PopularDestinationLoaded(destinations: destinations));
      },
    );
  }
}
