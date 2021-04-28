import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_geolocation/repository/geolocation_repository.dart';
import 'package:flutter_geolocation/views/widgets/drawer.dart';
import 'package:geolocator/geolocator.dart';

/// Example [Widget] showing the functionalities of the geolocator plugin
class GeolocatorWidget extends StatefulWidget {
  /// Utility method to create a page with the Baseflow templating.

  @override
  _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget>
    with WidgetsBindingObserver {
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerApp(),
      appBar: AppBar(
        title: Text("Geolocator"),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView.builder(
        itemCount: _positionItems.length,
        itemBuilder: (context, index) {
          final positionItem = _positionItems[index];
          if (positionItem.type == _PositionItemType.permission) {
            return ListTile(
              title: Text(positionItem.displayValue,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            );
          } else {
            return Card(
              child: ListTile(
                title: Text(
                  positionItem.displayValue,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              heroTag: "clear",
              onPressed: () => setState(_positionItems.clear),
              label: Text("clear"),
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              heroTag: "last",
              onPressed: () async {
                await Geolocator.getLastKnownPosition().then((value) => {
                      _positionItems.add(_PositionItem(
                          _PositionItemType.position, value.toString()))
                    });

                setState(
                  () {},
                );
              },
              label: Text("Last Position"),
            ),
          ),
          Positioned(
            bottom: 150.0,
            right: 10.0,
            child: FloatingActionButton.extended(
                onPressed: () async {
                  await Geolocator.getCurrentPosition().then((value) => {
                        _positionItems.add(_PositionItem(
                            _PositionItemType.position, value.toString()))
                      });

                  setState(
                    () {},
                  );
                },
                heroTag: "current",
                label: Text("Current Position")),
          ),
          Positioned(
            bottom: 220.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              heroTag: "stream",
              onPressed: _toggleListening,
              label: Text(() {
                if (_positionStreamSubscription == null) {
                  return "Start stream";
                } else {
                  final buttonText = _positionStreamSubscription!.isPaused
                      ? "Resume"
                      : "Pause";

                  return "$buttonText stream";
                }
              }()),
              backgroundColor: _determineButtonColor(),
            ),
          ),
          Positioned(
            bottom: 290.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              heroTag: "check",
              onPressed: () async {
                await Geolocator.checkPermission().then((value) => {
                      _positionItems.add(_PositionItem(
                          _PositionItemType.permission, value.toString()))
                    });
                setState(() {});
              },
              label: Text("Check Permission"),
            ),
          ),
          Positioned(
            bottom: 360.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              heroTag: "request",
              onPressed: () async {
                await Geolocator.requestPermission().then((value) => {
                      _positionItems.add(_PositionItem(
                          _PositionItemType.permission, value.toString()))
                    });
                setState(() {});
              },
              label: Text("Request Permission"),
            ),
          ),
        ],
      ),
    );
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = Geolocator.getPositionStream();

      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => setState(() {
            _positionItems.add(
                _PositionItem(_PositionItemType.position, position.toString()));
            print("stream: $position");
            GeolocationRepository().createLogLocation(position);
          }));
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
      } else {
        _positionStreamSubscription!.pause();
      }
    });
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}

enum _PositionItemType {
  permission,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
