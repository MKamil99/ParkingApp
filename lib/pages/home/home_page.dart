import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/pages/home/marker_provider.dart';
import 'package:parking_app/pages/home/database_state.dart';
import 'package:parking_app/pages/home/search_dialog.dart';
import 'package:parking_app/pages/home/custom_map_in_home.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends DatabaseState {
  // Data:
  late GoogleMapController gmController;
  late CameraPosition currentCameraPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: showSearchDialog,
          ),
        ],
      ),
      body: MarkerProvider(
        child: CustomMapInHome(
          setCurrentCameraPosition: setCurrentCameraPosition,
          setGoogleMapController: setGoogleMapController,
          changeCameraPosition: changeCameraPosition,
        ),
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_location),
        onPressed: () {
          Navigator.pushNamed(context, '/add', arguments: {
            'cameraPosition': currentCameraPosition,
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // Move Google Maps camera to certain position (with animation):
  void changeCameraPosition(double latitude, double longitude) {
    gmController.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 15)),
    );
  }

  // Setters:
  void setCurrentCameraPosition(CameraPosition position) => currentCameraPosition = position;
  void setGoogleMapController(GoogleMapController controller) => gmController = controller;

  // Show dialog with list of all locations and search bar:
  void showSearchDialog() {
    showDialog(context: context, builder: (_) {
      return StatefulBuilder(
          builder: (context, setState) => SearchDialog(
              locations: locations,
              changeCameraPosition: changeCameraPosition
          )
      );
    });
  }
}
