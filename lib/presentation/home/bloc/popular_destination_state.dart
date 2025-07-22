part of 'popular_destination_bloc.dart';

sealed class PopularDestinationState extends Equatable {
  const PopularDestinationState();

  @override
  List<Object> get props => [];
}

final class PopularDestinationInitial extends PopularDestinationState {
  const PopularDestinationInitial();
}

final class PopularDestinationLoading extends PopularDestinationState {
  const PopularDestinationLoading();
}

final class PopularDestinationLoaded extends PopularDestinationState {
  final List<DestinationModel> destinations;

  const PopularDestinationLoaded({required this.destinations});

  @override
  List<Object> get props => [destinations];
}

final class PopularDestinationFailed extends PopularDestinationState {
  final Failure failure;

  const PopularDestinationFailed({required this.failure});

  @override
  List<Object> get props => [failure];
}
