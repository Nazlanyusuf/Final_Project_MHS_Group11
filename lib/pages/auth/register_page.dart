import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:final_project_mhs/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailCtrl    = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _confirmCtrl  = TextEditingController();
  final _ddCtrl       = TextEditingController();
  final _mmCtrl       = TextEditingController();
  final _yyyyCtrl     = TextEditingController();

  bool _isLoading      = false;
  bool _obscurePass    = true;
  bool _obscureConfirm = true;

  static const _blue = Color(0xFF6DB6E3);
  static const _dark = Color(0xFF1A1A2E);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _ddCtrl.dispose();
    _mmCtrl.dispose();
    _yyyyCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_emailCtrl.text.isEmpty ||
        _usernameCtrl.text.isEmpty ||
        _passCtrl.text.isEmpty ||
        _confirmCtrl.text.isEmpty) {
      _showSnack('Semua field wajib diisi');
      return;
    }
    if (_passCtrl.text != _confirmCtrl.text) {
      _showSnack('Password dan Confirm Password tidak cocok');
      return;
    }
    if (_passCtrl.text.length < 8) {
      _showSnack('Password minimal 8 karakter');
      return;
    }
    setState(() => _isLoading = true);
    try {
      final dob =
          '${_yyyyCtrl.text}-${_mmCtrl.text.padLeft(2, '0')}-${_ddCtrl.text.padLeft(2, '0')}';
      final result = await AuthService.register(
        email: _emailCtrl.text.trim(),
        username: _usernameCtrl.text.trim(),
        password: _passCtrl.text,
        dateOfBirth: dob,
      );
      if (!mounted) return;
      if (result['success'] == true) {
        _showSnack('Registrasi berhasil! Silakan login.');
        Navigator.pop(context);
      } else {
        _showSnack(result['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      _showSnack('Terjadi kesalahan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _blue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new,
                      size: 18, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 28),

              // Email
              _field(controller: _emailCtrl, hint: 'Email',
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),

              // Username
              _field(controller: _usernameCtrl, hint: 'Username'),
              const SizedBox(height: 12),

              // Password
              _field(
                controller: _passCtrl,
                hint: 'Password',
                obscure: _obscurePass,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscurePass = !_obscurePass),
                  child: Icon(
                    _obscurePass
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: Colors.black38,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Confirm Password
              _field(
                controller: _confirmCtrl,
                hint: 'Confirm Password',
                obscure: _obscureConfirm,
                suffix: GestureDetector(
                  onTap: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  child: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: Colors.black38,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date Of Birth
              const Text(
                'Date Of Birth',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _dobField(_ddCtrl, 'DD', 2),
                  const SizedBox(width: 10),
                  _dobField(_mmCtrl, 'MM', 2),
                  const SizedBox(width: 10),
                  _dobField(_yyyyCtrl, 'YYYY', 4, flex: 2),
                ],
              ),
              const SizedBox(height: 28),

              // Sign Up button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _dark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffix != null
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: suffix,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black45),
        ),
      ),
    );
  }

  Widget _dobField(
    TextEditingController controller,
    String hint,
    int maxLen, {
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: maxLen,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
          filled: true,
          fillColor: Colors.white,
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black45),
          ),
        ),
      ),
    );
  }
}
