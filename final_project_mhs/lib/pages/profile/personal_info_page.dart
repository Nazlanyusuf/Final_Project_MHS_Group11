import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/auth_service.dart';
import 'change_password_page.dart';

class PersonalInfoPage extends StatefulWidget {
  final Map<String, dynamic>? user;
  const PersonalInfoPage({super.key, this.user});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _nameCtrl     = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _dobCtrl      = TextEditingController();

  bool _isLoading = false;

  static const _blue  = Color(0xFF6DB6E3);
  static const _coral = Color(0xFFCC3333);

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  void _prefill() {
    final u = widget.user;
    if (u == null) return;
    _nameCtrl.text     = u['name']     ?? '';
    _usernameCtrl.text = u['username'] ?? '';
    _emailCtrl.text    = u['email']    ?? '';

    // date_of_birth dari API: "YYYY-MM-DD" atau null
    final dob = u['date_of_birth'] as String?;
    if (dob != null && dob.isNotEmpty) {
      try {
        // API kadang kirim "YYYY-MM-DD" atau "YYYY-MM-DDTHH:mm:ss...Z"
        final datePart = dob.split('T').first;
        final parts = datePart.split('-');
        if (parts.length == 3) {
          _dobCtrl.text = '${parts[2]}/${parts[1]}/${parts[0]}';
          return;
        }
      } catch (_) {}
      // fallback: tampilkan apa adanya
      _dobCtrl.text = dob;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    DateTime initial = DateTime(2000);
    if (_dobCtrl.text.isNotEmpty) {
      try {
        final parts = _dobCtrl.text.split('/');
        initial = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } catch (_) {}
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _blue),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dobCtrl.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _usernameCtrl.text.trim().isEmpty) {
      _snack('Nama dan username wajib diisi', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // Konversi DD/MM/YYYY → YYYY-MM-DD untuk API
    String? dobForApi;
    if (_dobCtrl.text.isNotEmpty) {
      try {
        final parts = _dobCtrl.text.split('/');
        dobForApi = '${parts[2]}-${parts[1]}-${parts[0]}';
      } catch (_) {}
    }

    final result = await AuthService.updateProfile(
      name: _nameCtrl.text.trim(),
      username: _usernameCtrl.text.trim(),
      dateOfBirth: dobForApi,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      _snack('Profil berhasil diperbarui');
      Navigator.pop(context);
    } else {
      _snack(result['message'] ?? 'Gagal menyimpan', isError: true);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
      content: Text(msg),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Personal Info',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            // ── Header card ──────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: _blue,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white.withOpacity(0.28),
                        child: const Icon(Icons.person,
                            size: 50, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade600,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.edit,
                              size: 13, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _nameCtrl.text.isEmpty ? 'User' : _nameCtrl.text,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${_usernameCtrl.text.isEmpty ? 'username' : _usernameCtrl.text}',
                    style: const TextStyle(
                        fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ── Form fields ──────────────────────────────────────
            _field('Full Name', _nameCtrl, icon: Icons.person_outline),
            _field('Username', _usernameCtrl, icon: Icons.alternate_email),
            _field('Email', _emailCtrl,
                icon: Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
                readOnly: true),

            // Date of Birth
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date of Birth',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: _pickDob,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: _dobCtrl,
                      decoration: _decoration(
                        icon: Icons.cake_outlined,
                        suffixIcon: const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),

            // ── Security ─────────────────────────────────────────
            const Divider(height: 1, color: Colors.black12),
            const SizedBox(height: 12),
            const Text(
              'Security',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ChangePasswordPage()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.lock_outline,
                          size: 20, color: Colors.black54),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Change Password',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Update your account password',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black38)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: Colors.black38, size: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Save button ──────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _coral,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save Changes',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    IconData icon = Icons.person_outline,
    TextInputType keyboard = TextInputType.text,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54)),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          readOnly: readOnly,
          style: TextStyle(
              color: readOnly ? Colors.black38 : Colors.black87),
          decoration: _decoration(icon: icon),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  InputDecoration _decoration({
    IconData icon = Icons.person_outline,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 18, color: Colors.black38),
      suffixIcon: suffixIcon,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            BorderSide(color: Colors.black.withOpacity(0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _blue, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
