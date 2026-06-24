import 'package:flutter/material.dart';
import '../auth/login_page.dart';
import '../reminders/event_reminders_page.dart';
import 'package:final_project_mhs/widgets/guest_view.dart';
import 'package:final_project_mhs/services/auth_service.dart';
import 'personal_info_page.dart';

class ProfilePage extends StatefulWidget {
  final void Function(int)? onTabChange;
  const ProfilePage({super.key, this.onTabChange});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _coral = Color(0xFFCC3333);
  static const _blue  = Color(0xFF6DB6E3);

  Map<String, dynamic>? _user;
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;
    if (!loggedIn) {
      setState(() { _isLoggedIn = false; _isLoading = false; });
      return;
    }
    final user = await AuthService.getUser();
    if (mounted) {
      setState(() { _user = user; _isLoggedIn = true; _isLoading = false; });
    }
  }

  Future<void> _loadUser() async {
    final user = await AuthService.getUser();
    if (mounted) setState(() => _user = user);
  }

  String get _displayName => _user?['name'] ?? _user?['username'] ?? 'User';
  String get _username    => '@${_user?['username'] ?? 'username'}';
  String get _email       => _user?['email'] ?? '-';

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: _blue)),
      );
    }
    if (!_isLoggedIn) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: _buildGuestView()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ── Profile card ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6FA),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black.withOpacity(0.06)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: _blue.withOpacity(0.2),
                        child: const Icon(Icons.person, size: 44, color: _blue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _displayName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _username,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black45),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _blue.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.email_outlined,
                                      size: 13, color: Color(0xFF3A8FC4)),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      _email,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF3A8FC4)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Stats row ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat(Icons.calendar_today_outlined, '0', 'Booking'),
                    Container(width: 1, height: 34, color: Colors.black12),
                    _stat(Icons.favorite_border, '0', 'Wishlist'),
                    Container(width: 1, height: 34, color: Colors.black12),
                    _stat(Icons.star_border_outlined, '0', 'Reviews'),
                  ],
                ),
              ),

              const Divider(height: 1, color: Colors.black12),
              const SizedBox(height: 18),

              // ── Account section ───────────────────────────────────
              _sectionHeader('Account'),
              _menuItem(
                context,
                Icons.person_outline,
                'Personal Info',
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PersonalInfoPage(user: _user),
                    ),
                  );
                  _loadUser();
                },
              ),
              _menuItem(
                context,
                Icons.access_time_rounded,
                'My Activity',
                onTap: () => widget.onTabChange?.call(2),
              ),
              _menuItem(
                context,
                Icons.favorite_border,
                'My Wishlist',
                onTap: () => widget.onTabChange?.call(1),
              ),
              _menuItem(
                context,
                Icons.notifications_none_outlined,
                'Event Reminders',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const EventRemindersPage()),
                ),
              ),

              const SizedBox(height: 28),

              // ── Log Out ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService.logout();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginPage()),
                          (_) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _coral.withOpacity(0.12),
                      foregroundColor: _coral,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestView() {
    return const GuestView(
      icon: Icons.person_outline,
      message:
          'Login untuk mengakses profil, riwayat booking, dan fitur lainnya.',
    );
  }

  Widget _stat(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black45),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Colors.black45)),
          ],
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      child: Text(title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      leading: Icon(icon, size: 22, color: Colors.black54),
      title: Text(title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right,
          color: Colors.black38, size: 20),
      minLeadingWidth: 24,
      dense: true,
    );
  }
}
