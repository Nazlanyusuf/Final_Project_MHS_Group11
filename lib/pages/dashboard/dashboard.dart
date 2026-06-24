import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/venue_service.dart';
import 'package:final_project_mhs/services/wishlist_service.dart';
import 'package:final_project_mhs/services/auth_service.dart';
import 'package:final_project_mhs/utils/auth_guard.dart';
import 'package:final_project_mhs/widgets/venue_card.dart';
import '../booking/booking.dart';
import '../notification_page.dart';
import '../chat/chat_list_page.dart';
import '../search_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedCategory = 'All\nProducts';
  List<Map<String, dynamic>> _venues = [];
  Set<int> _wishlistedIds = {};
  bool _isVenueLoading = true;

  final List<Map<String, dynamic>> categories = [
    {"title": "Wedding",       "icon": Icons.favorite,   "color": Colors.pink},
    {"title": "Concert",       "icon": Icons.music_note, "color": Colors.purple},
    {"title": "Birthday",      "icon": Icons.cake,       "color": Colors.orange},
    {"title": "Seminar",       "icon": Icons.groups,     "color": Colors.blue},
    {"title": "Photoshoot",    "icon": Icons.camera_alt, "color": Colors.teal},
    {"title": "All\nProducts", "icon": Icons.apps,       "color": Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    _loadVenues();
    _loadWishlistIds();
  }

  Future<void> _loadVenues() async {
    setState(() => _isVenueLoading = true);
    final cat = _selectedCategory == 'All\nProducts' ? null : _selectedCategory;
    final data = await VenueService.getVenues(category: cat);
    if (mounted) {
      setState(() {
        _venues = data;
        _isVenueLoading = false;
      });
    }
  }

  Future<void> _loadWishlistIds() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (!loggedIn) return;
    final data = await WishlistService.getWishlist();
    if (mounted) {
      setState(() {
        _wishlistedIds = data.map((e) => e['id'] as int? ?? 0).toSet();
      });
    }
  }

  Future<void> _toggleWishlist(int venueId) async {
    final ok = await AuthGuard.check(context);
    if (!ok) return;
    final wasWishlisted = _wishlistedIds.contains(venueId);
    setState(() {
      if (wasWishlisted) {
        _wishlistedIds.remove(venueId);
      } else {
        _wishlistedIds.add(venueId);
      }
    });
    await WishlistService.toggleWishlist(venueId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF6DB6E3),
          onRefresh: () async {
            await _loadVenues();
            await _loadWishlistIds();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 18),
                _buildPromoBanner(),
                const SizedBox(height: 14),
                _buildSdgBanner(),
                const SizedBox(height: 14),
                _buildSectionTitle(),
                const SizedBox(height: 14),
                _buildVenueList(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Venue list ──────────────────────────────────────────────────
  Widget _buildVenueList() {
    if (_isVenueLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
            child: CircularProgressIndicator(color: Color(0xFF6DB6E3))),
      );
    }
    if (_venues.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'Belum ada EO untuk kategori ini',
                style: TextStyle(
                    color: Colors.grey.shade400, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      ),
      child: ListView.builder(
        key: ValueKey(_selectedCategory),
        itemCount: _venues.length,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final venue = _venues[index];
          final venueId = venue['id'] as int? ?? 0;
          return VenueCard(
            venue: venue,
            isWishlisted: _wishlistedIds.contains(venueId),
            onTap: () async {
              final ok = await AuthGuard.check(context);
              if (!ok) return;
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingDetailPage(venueId: venueId),
                  ),
                );
              }
            },
            onWishlistTap: () => _toggleWishlist(venueId),
          );
        },
      ),
    );
  }

  // ── Header (blue section) ────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF6DB6E3),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationPage())),
                child: const Icon(Icons.notifications_none_outlined,
                    size: 28, color: Colors.white),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const ChatListPage())),
                child: const Icon(Icons.chat_bubble_outline,
                    size: 28, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SearchPage())),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Venue or Event Organizer',
                    hintStyle:
                        TextStyle(color: Colors.black38, fontSize: 14),
                    prefixIcon:
                        Icon(Icons.search, color: Colors.black45, size: 22),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Book venues and event organizers easily and securely in one platform',
            style: TextStyle(
                fontSize: 13, color: Colors.white, height: 1.4),
          ),
          const SizedBox(height: 16),
          // Category chips card
          Container(
            padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: List.generate(
                    5,
                    (i) => Expanded(
                        child: _buildCategoryChip(categories[i])),
                  ),
                ),
                const SizedBox(height: 10),
                _buildCategoryChip(categories[5]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(Map<String, dynamic> item) {
    final isSelected = _selectedCategory == item['title'];
    final color = item['color'] as Color;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCategory = item['title'] as String);
        _loadVenues();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(isSelected ? 0.22 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item['icon'] as IconData,
                  color: color, size: 18),
            ),
            const SizedBox(height: 5),
            Text(
              (item['title'] as String).replaceAll('\n', ' '),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Promo banner ─────────────────────────────────────────────────
  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF74C6F7), Color(0xFFB97AFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.25),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: -15,
              top: 10,
              child: Icon(Icons.card_giftcard,
                  size: 90, color: Colors.white.withOpacity(0.3)),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('PROMO Event',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 6),
                  Text('Package\nUp to 100% OFF',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── SDG Banner ───────────────────────────────────────────────────
  Widget _buildSdgBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('SDG\n 8',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        height: 1.2)),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Decent Work & Economic Growth',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E7D32)),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'PlanIt mendukung EO lokal tumbuh secara digital dan menciptakan lapangan kerja.',
                    style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF388E3C),
                        height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section title ────────────────────────────────────────────────
  Widget _buildSectionTitle() {
    final label = _selectedCategory == 'All\nProducts'
        ? 'Explore Deals For You'
        : _selectedCategory.replaceAll('\n', ' ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                  parent: animation, curve: Curves.easeOut)),
              child: child,
            ),
          ),
          child: Text(
            label,
            key: ValueKey(label),
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
