import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../pages/auth/login_page.dart';

class AuthGuard {
  static const _blue = Color(0xFF6DB6E3);

  /// Returns true if logged in; shows a dialog and returns false if not.
  static Future<bool> check(BuildContext context) async {
    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) return true;
    if (!context.mounted) return false;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Login Diperlukan'),
        content: const Text(
            'Anda harus login terlebih dahulu untuk menggunakan fitur ini.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Nanti'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
    return false;
  }
}
