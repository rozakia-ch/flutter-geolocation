import 'package:flutter/material.dart';
import 'package:flutter_geolocation/views/pages/geolocator_example.dart';
import 'package:flutter_geolocation/views/pages/home_page.dart';

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          _createHeader(),
          _createDrawerItem(
            icon: Icons.contacts,
            text: 'Geolocator',
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GeolocatorWidget()),
            ),
          ),
          _createDrawerItem(
            icon: Icons.event,
            text: 'Geolocator Flutter Bloc',
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.amber,
        // image: DecorationImage(
        //   fit: BoxFit.fill,
        //   image: AssetImage('path/to/header_background.png'),
        // ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text(
              "Flutter Step-by-Step",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
