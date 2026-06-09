import 'package:flutter/material.dart';
import 'login/login_page.dart';
import 'serivces/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _blue = Color(0xFF6DB6E3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header card
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 48,
                          backgroundColor: _blue,
                          child: Text(
                            'U',
                            style: TextStyle(
                                fontSize: 38,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: _blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.edit,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'User',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'user@email.com',
                      style: TextStyle(fontSize: 13, color: Colors.black45),
                    ),
                    const SizedBox(height: 16),
                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStat('3', 'Bookings'),
                        Container(
                            width: 1,
                            height: 32,
                            color: Colors.black12,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 24)),
                        _buildStat('5', 'Wishlist'),
                        Container(
                            width: 1,
                            height: 32,
                            color: Colors.black12,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 24)),
                        _buildStat('2', 'Reviews'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Account section
              _section('Account', [
                _item(Icons.person_outline, 'Edit Profile', onTap: () {}),
                _item(Icons.lock_outline, 'Change Password', onTap: () {}),
                _item(Icons.notifications_none, 'Notifications',
                    onTap: () {}),
              ]),

              const SizedBox(height: 12),

              // Activity section
              _section('Activity', [
                _item(Icons.event_note_outlined, 'My Bookings',
                    onTap: () {}),
                _item(Icons.favorite_border, 'Wishlist', onTap: () {}),
              ]),

              const SizedBox(height: 12),

              // Support section
              _section('Support', [
                _item(Icons.help_outline, 'Help & Support', onTap: () {}),
                _item(Icons.info_outline, 'About App', onTap: () {}),
              ]),

              const SizedBox(height: 12),

              // Logout
              _section('', [
                _item(Icons.logout, 'Logout',
                    color: Colors.red,
                    onTap: () async {
                      await AuthService.logout();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginPage()),
                          (_) => false,
                        );
                      }
                    }),
              ]),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: Colors.black45)),
      ],
    );
  }

  Widget _section(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45),
              ),
            ),
          ],
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: List.generate(items.length, (i) {
                return Column(
                  children: [
                    items[i],
                    if (i < items.length - 1)
                      const Divider(
                          height: 1, indent: 56, endIndent: 16),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title,
      {Color? color, required VoidCallback onTap}) {
    final c = color ?? _blue;
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: c.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 19, color: c),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color ?? Colors.black87),
      ),
      trailing: color == null
          ? const Icon(Icons.chevron_right,
              color: Colors.black26, size: 20)
          : null,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      minLeadingWidth: 0,
    );
  }
}
