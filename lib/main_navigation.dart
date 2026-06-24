import 'package:flutter/material.dart';
import 'package:final_project_mhs/utils/refreshable.dart';

import 'pages/dashboard/dashboard.dart';
import 'pages/wishlist.dart';
import 'pages/activity.dart';
import 'pages/profile/profile_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<GlobalKey<RefreshablePageState>> _pageKeys = [
    GlobalKey<RefreshablePageState>(),
    GlobalKey<RefreshablePageState>(),
    GlobalKey<RefreshablePageState>(),
  ];

  // ─── Daftar halaman ──────────────────────────────────────────────
  late final List<Widget> _pages = [
    DashboardPage(key: _pageKeys[0]),
    WishlistPage(key: _pageKeys[1]),
    ActivityPage(key: _pageKeys[2]),
    ProfilePage(onTabChange: (i) => setState(() => _selectedIndex = i)),
  ];

  static const _navItems = [
    _NavItem(icon: Icons.home_rounded,     activeIcon: Icons.home_rounded,       label: 'Home'),
    _NavItem(icon: Icons.favorite_border,  activeIcon: Icons.favorite,           label: 'Wishlist'),
    _NavItem(icon: Icons.access_time,      activeIcon: Icons.access_time_filled, label: 'Activity'),
    _NavItem(icon: Icons.person_outline,   activeIcon: Icons.person,             label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
        children: List.generate(_pages.length, (i) {
          return AnimatedOpacity(
            opacity: i == _selectedIndex ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: IgnorePointer(
              ignoring: i != _selectedIndex,
              child: _pages[i],
            ),
          );
        }),
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_navItems.length, (index) {
          final item = _navItems[index];
          final isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () {
              if (index < _pageKeys.length) {
                _pageKeys[index].currentState?.refresh();
              }
              setState(() => _selectedIndex = index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? item.activeIcon : item.icon,
                    color: isSelected ? Colors.blue : Colors.grey,
                    size: 26,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
