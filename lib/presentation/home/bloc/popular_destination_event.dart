part of 'popular_destination_bloc.dart';

sealed class PopularDestinationEvent extends Equatable {
  const PopularDestinationEvent();

  @override
  List<Object> get props => [];
}

final class FetchPopularDestinationsEvent extends PopularDestinationEvent {
  const FetchPopularDestinationsEvent();
}

final class RefreshPopularDestinationsEvent extends PopularDestinationEvent {
  const RefreshPopularDestinationsEvent();
}
