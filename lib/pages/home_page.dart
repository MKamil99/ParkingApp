import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/db/moor_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final database = Provider.of<AppDatabase>(context);

    return Scaffold(
      body: Column(
        children: [Container(
          height: 400,
          width: double.infinity,
          child: StreamBuilder(
                stream: database.watchAllLocations(),
                builder: (context, AsyncSnapshot<List<Location>> snapshot) {
                  final locations = snapshot.data ?? List.empty();
                  return ListView.builder(
                    itemBuilder: (_, index) {
                        return Card(
                            child: ListTile(
                              title: Text(locations[index].name),
                              subtitle: Text("(" + locations[index].longitude.toString()
                                  + ", " + locations[index].latitude.toString() + ")"),
                            )
                        );
                      },
                    itemCount: locations.length,
                  );
                }
            ),
        )],
      ),
    );
  }

  // Making sure that state will not be lost after changing page:
  @override
  bool get wantKeepAlive => true;
}
