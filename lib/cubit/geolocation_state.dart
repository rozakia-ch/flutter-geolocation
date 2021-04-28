part of 'geolocation_cubit.dart';

@immutable
abstract class GeolocationState {}

class GeolocationInitial extends GeolocationState {}

class GeolocationLoaded extends GeolocationState {
  final PositionItem position;
  GeolocationLoaded({required this.position});
  List<Object?> get props => [position];
}
