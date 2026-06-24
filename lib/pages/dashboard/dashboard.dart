import 'package:flutter/material.dart';
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingDetailPage(venueId: venue['id'] as int? ?? 1),
          ),
        ),
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
                      Text(
                        venue["title"],
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 3),
                          Text(venue["rating"], style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 8),
                          const Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey),
                          const SizedBox(width: 3),
                          Text("${venue["review"]} Review",
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.black54),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(venue["location"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                                overflow: TextOverflow.ellipsis),
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
                                style: TextStyle(fontSize: 10, color: Colors.grey)),
                            Text(venue["price"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
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
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
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
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleButton(Icons.notifications_none, onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const NotificationPage()));
              }),
              const Text("PlanIt",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              _circleButton(Icons.chat_bubble_outline, onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ChatListPage()));
              }),
            ],
          ),
          const SizedBox(height: 10),
          // Subtitle
          const SizedBox(height: 16),
          // Search bar — tap navigates to SearchPage
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Venue or Event Organizer",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Categories (horizontal scroll)
          SizedBox(
            height: 95,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final item = categories[index];
                final isLast = index == categories.length - 1;
                final isSelected = _selectedCategory == item["title"];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = item["title"] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: 64,
                    margin: EdgeInsets.only(right: isLast ? 0 : 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (item["color"] as Color).withOpacity(0.18)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: item["color"] as Color, width: 1.5)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (item["color"] as Color).withOpacity(isSelected ? 0.3 : 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item["icon"] as IconData,
                              color: item["color"] as Color, size: 20),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item["title"] as String,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: isSelected ? (item["color"] as Color) : Colors.black87),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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

  Widget _circleButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }
}
