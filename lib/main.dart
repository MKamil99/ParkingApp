import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/db/moor_database.dart';
import 'package:parking_app/pages/add_parking_page.dart';
import 'package:parking_app/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AppDatabase(),
      child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(),
            '/add': (context) => AddParkingPage(),
          },
          theme: ThemeData(
            primarySwatch: Colors.green,
          )
      ),
    );
  }
}
