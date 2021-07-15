import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/db/moor_database.dart';

class AddParkingPage extends StatefulWidget {
  const AddParkingPage({Key? key}) : super(key: key);

  @override
  _AddParkingPageState createState() => _AddParkingPageState();
}

class _AddParkingPageState extends State<AddParkingPage> with AutomaticKeepAliveClientMixin {
  // Data:
  double? latitude;
  double? longitude;
  String name = '';
  String description = '';
  int? ranking;
  bool canAdd() => latitude != null && longitude != null && name.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final database = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Just integers (for now):
                TextField(
                  decoration: InputDecoration(labelText: "Latitude"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (str) {
                    setState(() {
                      latitude = str.length > 0 ? double.parse(str) : null;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Longitude"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (str) {
                    setState(() {
                      longitude = str.length > 0 ? double.parse(str) : null;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Name"),
                  onChanged: (str) { setState(() { name = str; }); },
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  onChanged: (str) { setState(() { description = str; }); },
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Ranking"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (str) {
                    setState(() {
                      ranking  = str.length > 0 ? int.parse(str) : null;
                    });
                  },
                ),
                ElevatedButton(
                  // Null makes the button disable:
                  onPressed: canAdd() ? () => addLocation(context, database) : null,
                  child: Text("Add"),
                ),
              ],
            ),
          )
      ),
    );
  }

  // Adding parking location to database:
  void addLocation(BuildContext context, AppDatabase database) {
    setState(() {
      database.insertLocation(
          Location(
              name: name,
              latitude: latitude!,
              longitude: longitude!,
              description: description,
              ranking: ranking
          )
      );
    });
  }

  // Making sure that state will not be lost after changing page:
  @override
  bool get wantKeepAlive => true;
}
