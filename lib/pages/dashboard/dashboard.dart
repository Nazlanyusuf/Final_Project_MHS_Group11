import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/wishlist_service.dart';
import 'package:final_project_mhs/services/auth_service.dart';
import 'package:final_project_mhs/utils/auth_guard.dart';
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
  Set<int> _wishlistedIds = {};

  @override
  void initState() {
    super.initState();
    _loadWishlistIds();
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

  final List<Map<String, dynamic>> categories = [
    {"title": "Wedding",    "icon": Icons.favorite,    "color": Colors.pink},
    {"title": "Concert",    "icon": Icons.music_note,  "color": Colors.purple},
    {"title": "Birthday",   "icon": Icons.cake,        "color": Colors.orange},
    {"title": "Seminar",    "icon": Icons.groups,      "color": Colors.blue},
    {"title": "Photoshoot", "icon": Icons.camera_alt,  "color": Colors.teal},
    {"title": "All\nProducts", "icon": Icons.apps,     "color": Colors.grey},
  ];

  static const List<Map<String, dynamic>> _allVenues = [
    {
      "id": 1,
      "title": "Le Blanc Wedding Organizer",
      "category": "Wedding",
      "rating": "4.9",
      "review": "97",
      "location": "BSD",
      "price": "Rp 8.000.000",
      "image": "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000&auto=format&fit=crop",
    },
    {
      "id": 2,
      "title": "Elegant Wedding Organizer",
      "category": "Wedding",
      "rating": "4.8",
      "review": "84",
      "location": "Jakarta Selatan",
      "price": "Rp 12.000.000",
      "image": "https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=1000&auto=format&fit=crop",
    },
    {
      "id": 3,
      "title": "Amanjiwo Exclusive Wedding",
      "category": "Wedding",
      "rating": "5.0",
      "review": "42",
      "location": "Jawa Tengah",
      "price": "Rp 30.000.000",
      "image": "https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=1000&auto=format&fit=crop",
    },
    {
      "id": 4,
      "title": "Party Planner Birthday Organizer",
      "category": "Birthday",
      "rating": "4.4",
      "review": "125",
      "location": "JabaDeTaBek",
      "price": "Rp 5.000.000",
      "image": "https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?q=80&w=1000&auto=format&fit=crop",
    },
    {
      "id": 5,
      "title": "Happy Moment Birthday Crew",
      "category": "Birthday",
      "rating": "4.3",
      "review": "88",
      "location": "Tangerang",
      "price": "Rp 3.500.000",
      "image": "https://images.unsplash.com/photo-1530103862676-de8c9debad1d?q=80&w=1000&auto=format&fit=crop",
    },
    {
      "id": 6,
      "title": "Groovy Event Organizer",
      "category": "Concert",
      "rating": "4.6",
      "review": "80",
      "location": "ICE BSD",
      "price": "Rp 10.000.000",
      "image": "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=1000&auto=format&fit=crop",
    },
    {
      "id": 7,
      "title": "Soundwave Concert Production",
      "category": "Concert",
      "rating": "4.7",
      "review": "63",
      "location": "Jakarta Utara",
      "price": "Rp 15.000.000",
      "image": "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?q=80&w=1000&auto=format&fit=crop",
    },
    {
      "id": 8,
      "title": "BizTalk Seminar Organizer",
      "category": "Seminar",
      "rating": "4.5",
      "review": "55",
      "location": "SCBD Jakarta",
      "price": "Rp 6.000.000",
      "image": "https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=1000&auto=format&fit=crop",
    },
    {
      "id": 9,
      "title": "ProConference Planner",
      "category": "Seminar",
      "rating": "4.4",
      "review": "37",
      "location": "Serpong",
      "price": "Rp 4.500.000",
      "image": "https://images.unsplash.com/photo-1505373877841-8d25f7d46678?q=80&w=1000&auto=format&fit=crop",
    },
    {
      "id": 10,
      "title": "SnapShot Studio",
      "category": "Photoshoot",
      "rating": "4.8",
      "review": "112",
      "location": "Kemang, Jakarta",
      "price": "Rp 2.000.000",
      "image": "https://images.unsplash.com/photo-1452587925148-ce544e77e70d?q=80&w=1000&auto=format&fit=crop",
    },
    {
      "id": 11,
      "title": "LensArt Photography",
      "category": "Photoshoot",
      "rating": "4.6",
      "review": "74",
      "location": "Bintaro",
      "price": "Rp 1.500.000",
      "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=1000&auto=format&fit=crop",
    },
  ];

  List<Map<String, dynamic>> get _filteredVenues {
    if (_selectedCategory == 'All\nProducts') return _allVenues;
    return _allVenues.where((v) => v['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              _buildPromoBanner(),
              const SizedBox(height: 22),
              _buildSectionTitle(),
              const SizedBox(height: 14),
              _buildVenueList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVenueList() {
    final venues = _filteredVenues;
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
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      ),
      child: venues.isEmpty
          ? Padding(
              key: const ValueKey('__empty__'),
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada EO untuk kategori ini',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              key: ValueKey(_selectedCategory),
              itemCount: venues.length,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _buildVenueCard(venues[index]),
            ),
    );
  }

  Widget _buildVenueCard(Map<String, dynamic> venue) {
    final venueId = venue['id'] as int? ?? 1;
    final isWishlisted = _wishlistedIds.contains(venueId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Hero(
                tag: venue["title"],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    venue["image"],
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + wishlist heart
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              venue["title"],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _toggleWishlist(venueId),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Icon(
                                isWishlisted
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isWishlisted
                                    ? Colors.redAccent
                                    : Colors.black38,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 3),
                          Text(venue["rating"],
                              style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 8),
                          const Icon(Icons.chat_bubble_outline,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 3),
                          Text("${venue["review"]} Review",
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.black54),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              venue["location"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Start from",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey)),
                            Text(venue["price"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
          // ── Top icons ───────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const NotificationPage())),
                child: const Icon(Icons.notifications_none_outlined,
                    size: 28, color: Colors.white),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ChatListPage())),
                child: const Icon(Icons.chat_bubble_outline,
                    size: 28, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // ── Search bar ──────────────────────────────
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
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
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
          // ── Subtitle ────────────────────────────────
          const Text(
            'Book venues and event organizers easily and securely in one platform',
            style: TextStyle(fontSize: 13, color: Colors.white, height: 1.4),
          ),
          const SizedBox(height: 16),
          // ── Category chips card ─────────────────────
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
                    (i) => Expanded(child: _buildCategoryChip(categories[i])),
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
      onTap: () =>
          setState(() => _selectedCategory = item['title'] as String),
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

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 140,
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
                  Text("PROMO Event",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 8),
                  Text("Package\nUp to 100% OFF",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: child,
            ),
          ),
          child: Text(
            label,
            key: ValueKey(label),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

}
