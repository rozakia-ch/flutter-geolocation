import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_geolocation/models/position_item.dart';
import 'package:flutter_geolocation/repository/geolocation_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'geolocation_state.dart';

class GeolocationCubit extends Cubit<GeolocationState> {
  // final List<PositionItem> positionItems = <PositionItem>[];

  // ignore: cancel_subscriptions
  StreamSubscription? positionStreamSubscription;
  GeolocationCubit() : super(GeolocationInitial()) {
    positionStream();
  }

  StreamSubscription<Position> positionStream() {
    return positionStreamSubscription =
        Geolocator.getPositionStream(intervalDuration: Duration(seconds: 5))
            .listen((Position position) {
      // positionItems
      //     .add(PositionItem(PositionItemType.position, position.toString()));
      // sendLocation(position);
    });
  }

  void sendLocation(position) async {
    await GeolocationRepository().createLogLocation(position);
    emit(GeolocationLoaded(position: position));
  }

  @override
  Future<void> close() {
    if (positionStreamSubscription != null) {
      positionStreamSubscription!.cancel();
      positionStreamSubscription = null;
    }

    return super.close();
  }
}
