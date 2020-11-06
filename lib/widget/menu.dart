import 'package:flutter/material.dart';

import 'grid.dart';

class MenuWidget extends StatefulWidget {
  MenuWidget({Key key}) : super(key: key);

  @override
  _menuState createState() => _menuState();
}

class _menuState extends State<MenuWidget> {
int _selectedIndex = 0;
static const TextStyle optionStyle =TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  get bottomNavigationBar => null;
  static List<Widget> _widgetOptions = <Widget>[
    GridWidget(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child:BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text("Calendario"),
            icon: Icon(Icons.calendar_today),
          ),
          BottomNavigationBarItem(
            title: Text("Notas"),
            icon: Icon(Icons.note),
          ),
          BottomNavigationBarItem(
            title: Text("Escuela"),
            icon: Icon(Icons.school),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        onTap: _onItemTapped,
      ),
    );
  }
}