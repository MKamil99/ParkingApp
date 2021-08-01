import 'package:parking_app/pages/add_parking/add_parking_page_data.dart';
import 'package:parking_app/widgets/custom_map_in_add.dart';
import 'package:parking_app/widgets/custom_rating_bar.dart';
import 'package:parking_app/widgets/custom_text_field.dart';
import 'package:parking_app/db/moor_database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AddParkingPage extends StatefulWidget {
  @override
  _AddParkingPageState createState() => _AddParkingPageState();
}

class _AddParkingPageState extends State<AddParkingPage> {
  final AddParkingPageData data = AddParkingPageData();

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking App'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - kToolbarHeight - 50,
          width: double.maxFinite,
          child: Column(
            children: [
              CustomMapInAdd(setCoordinates: data.setCoordinates),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomTextField(label: 'Name', maxChars: 20, updateValue: data.setName),
                      CustomTextField(label: 'Description', maxChars: 50, updateValue: data.setDescription),
                      CustomRatingBar(setRating: data.setRating),
                    ]
                  ),
                ),
              ),
              ElevatedButton(
                // Null makes the button disabled:
                onPressed: data.canAdd() ? () => addLocation(context, database) : null,
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Adding parking location to database:
  void addLocation(BuildContext context, AppDatabase database) {
    // Update database:
    database.insertLocation(
        Location(
            name: data.name,
            latitude: data.latitude!,
            longitude: data.longitude!,
            description: data.description,
            rating: data.rating,
        )
    );

    // Go back to Home Page:
    Navigator.of(context).pop();
  }
}
