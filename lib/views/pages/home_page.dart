import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geolocation/cubit/geolocation_cubit.dart';
import 'package:flutter_geolocation/models/position_item.dart';
import 'package:flutter_geolocation/views/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<PositionItem> positionItems = <PositionItem>[];
    return BlocListener<GeolocationCubit, GeolocationState>(
      listener: (context, state) {
        if (state is GeolocationLoaded) {
          print(state.position.toString());
          positionItems.add(PositionItem(
              PositionItemType.position, state.position.toString()));
        }
      },
      child: Scaffold(
        drawer: DrawerApp(),
        appBar: AppBar(
          title: Text("Geolocator BLOC"),
        ),
        body: ListView.builder(
          itemCount: positionItems.length,
          itemBuilder: (context, index) {
            final positionItem = positionItems[index];
            print(positionItem);
            return Card(
              child: ListTile(
                title: Text(
                  positionItem.displayValue,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
