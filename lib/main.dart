import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'login/login_page.dart';
import 'serivces/auth_service.dart';

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
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF6DB6E3),
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        if (snapshot.data == true) {
          return const MainNavigation();
        }
        return const LoginPage();
      },
    );
  }
}