part of 'geolocation_cubit.dart';

@immutable
abstract class GeolocationState {}

class GeolocationInitial extends GeolocationState {}

class GeolocationLoaded extends GeolocationState {
  final Position position;
  GeolocationLoaded({required this.position});
  List<Position?> get props => [position];
}
