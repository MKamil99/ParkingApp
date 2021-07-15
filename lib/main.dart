// Code used in Bottom Navigation Bar bases on YouTube
// tutorials: https://www.youtube.com/watch?v=elLkVWt7gRM
// and https://www.youtube.com/watch?v=YJEMMhA9udQ

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/db/moor_database.dart';
import 'package:parking_app/pages/add_parking_page.dart';
import 'package:parking_app/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AppDatabase(),
      child: MaterialApp(
          home: MainPage(),
          theme: ThemeData(
            primarySwatch: Colors.green,
          )
      ),
    );
  }
}


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController _pageController = PageController();
  List<Widget> _pages = [HomePage(), AddParkingPage()];

  int _currentIndex = 0;
  final _fontSize = 13.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Parking App'),
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location),
            label: 'Add Parking',
          ),
        ],
        // Changing selection and page by tapping:
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() { _currentIndex = index; });
        },
        // The same font size for all fonts in NavBar:
        selectedFontSize: _fontSize,
        unselectedFontSize: _fontSize,
      ),
    );
  }
}
