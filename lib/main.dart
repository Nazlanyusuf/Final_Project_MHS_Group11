import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'pages/auth/login_page.dart';
import 'services/auth_service.dart';
import 'utils/smooth_transitions.dart';

void main() {
  runApp(const PlanIt());
}

class PlanIt extends StatelessWidget {
  const PlanIt({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlanIt',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        pageTransitionsTheme: smoothPageTransitionsTheme,
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