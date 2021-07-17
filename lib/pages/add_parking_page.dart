// Minor part of the code used in this file bases on
// https://stackoverflow.com/questions/53652573/fix-google-map-marker-in-center

// TODO: Clear fields after submitting, change pin icon, add "Rating" label

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/db/moor_database.dart';
import 'package:location/location.dart' as gps;

class AddParkingPage extends StatefulWidget {
  const AddParkingPage({Key? key}) : super(key: key);

  @override
  _AddParkingPageState createState() => _AddParkingPageState();
}

class _AddParkingPageState extends State<AddParkingPage> with AutomaticKeepAliveClientMixin {
  // Data:
  double? _latitude;
  double? _longitude;
  String _name = '';
  String _description = '';
  int? _ranking;
  bool canAdd() => _latitude != null && _longitude != null && _name.isNotEmpty;

  // Poland as initial camera position:
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(52.90, 19),
    zoom: 5.75,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final database = Provider.of<AppDatabase>(context);
    double mapHeight = MediaQuery.of(context).size.height / 3;
    double mapWidth = MediaQuery.of(context).size.width;
    double iconSize = 30.0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height
              - kToolbarHeight - kBottomNavigationBarHeight - 25,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: mapHeight,
                    width: mapWidth,
                    child: GoogleMap(
                      initialCameraPosition: _initialPosition,
                      onCameraMove: ((position) => updatePosition(position)),
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                    ),
                  ),
                  Positioned(
                    top: (mapHeight - iconSize) / 2,
                    left: (mapWidth - iconSize) / 2,
                    child: Icon(Icons.push_pin, color: Colors.red.shade800, size: iconSize),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: "Name"),
                        onChanged: (str) { setState(() { _name = str; }); },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Description"),
                        onChanged: (str) { setState(() { _description = str; }); },
                      ),
                      RatingBar.builder(
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          _ranking = rating.toInt();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                // Null makes the button disable:
                onPressed: canAdd() ? () => addLocation(context, database) : null,
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Adding parking location to database:
  void addLocation(BuildContext context, AppDatabase database) {
    setState(() {
      database.insertLocation(
          Location(
              name: _name,
              latitude: _latitude!,
              longitude: _longitude!,
              description: _description,
              ranking: _ranking
          )
      );
    });
  }

  // Updating _latitude and _longitude variables after moving camera:
  void updatePosition(CameraPosition position) {
    _longitude = position.target.longitude;
    _latitude = position.target.latitude;
  }


  // Locate user on map (but only for the first time, after launching the app):
  gps.Location _location = gps.Location();
  bool _locatedOnce = false;
  void _onMapCreated(GoogleMapController controller) {
    _location.onLocationChanged.listen((data) {
      if (_locatedOnce == false && data.latitude != null && data.longitude != null) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(data.latitude!, data.longitude!), zoom: 15)
          ),
        );
        _locatedOnce = true;
      }
    });
  }


  // Making sure that state will not be lost after changing page:
  @override
  bool get wantKeepAlive => true;
}
