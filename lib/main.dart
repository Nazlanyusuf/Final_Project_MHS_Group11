import 'package:flutter/material.dart';
import 'main_navigation.dart';
void main() {
  runApp(const VenueKitaAja());
}

class VenueKitaAja extends StatelessWidget {
  const VenueKitaAja({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VenueKitaAja',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      ),
      home: const MainNavigation(),
    );
  }
}