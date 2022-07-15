// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:sipakar_water_melon/user/diagnosa/form_diagnosa.dart';

import 'package:sipakar_water_melon/user/home.dart';

import '../user/riwayat/riwayat.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  BottomNavState createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;
  final widgetOptions = [
    const MyHome(),
    const Riwayat(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FormDiagnosa()));
            },
            child: const Icon(Icons.document_scanner_outlined)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Center(
          child: widgetOptions.elementAt(selectedIndex),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.white,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          ),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'Riwayat'),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: Colors.green,
            onTap: onItemTapped,
          ),
        ),
      ),
      behavior: HitTestBehavior.translucent,
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
