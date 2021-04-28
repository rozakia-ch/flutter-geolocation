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
    List<PositionItem> positionItems = <PositionItem>[];
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      drawer: DrawerApp(),
      appBar: AppBar(
        title: Text("Geolocator BLOC"),
      ),
      body: BlocBuilder<GeolocationCubit, GeolocationState>(
        builder: (context, state) {
          if (state is GeolocationLoaded) {
            positionItems.add(PositionItem(
                PositionItemType.position, state.position.toString()));
          }
          return ListView.builder(
            itemCount: positionItems.length,
            itemBuilder: (context, index) {
              final positionItem = positionItems[index];
              return Card(
                child: ListTile(
                  title: Text(
                    positionItem.displayValue,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
