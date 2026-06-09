import 'package:flutter/material.dart';
import 'booking.dart';
import 'notification_page.dart';
import 'chat/chat_list_page.dart';
import 'search_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> categories = [
    {"title": "Wedding",    "icon": Icons.favorite,    "color": Colors.pink},
    {"title": "Concert",    "icon": Icons.music_note,  "color": Colors.purple},
    {"title": "Birthday",   "icon": Icons.cake,        "color": Colors.orange},
    {"title": "Seminar",    "icon": Icons.groups,      "color": Colors.blue},
    {"title": "Photoshoot", "icon": Icons.camera_alt,  "color": Colors.teal},
    {"title": "All\nProducts", "icon": Icons.apps,     "color": Colors.grey},
  ];

  final List<Map<String, dynamic>> venues = [
    {
      "title": "Le Blanc Wedding Organizer",
      "rating": "4.9",
      "review": "97",
      "location": "BSD",
      "price": "Rp 8.000.000",
      "image": "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1000&auto=format&fit=crop",
    },
    {
      "title": "Party Planner Birthday Organizer",
      "rating": "4.4",
      "review": "125",
      "location": "JabaDeTaBek",
      "price": "Rp 5.000.000",
      "image": "https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?q=80&w=1000&auto=format&fit=crop",
    },
  ];

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
              ListView.builder(
                itemCount: venues.length,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final venue = venues[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BookingDetailPage(),
                          ),
                        );
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
                                    Text(
                                      venue["title"],
                                      style: const TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.w700),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 16),
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
                                          child: Text(venue["location"],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12),
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
                },
              ),
              const SizedBox(height: 30),
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
              const Text("VenueKitaAja",
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
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("${item["title"].toString().replaceAll('\n', ' ')} clicked"),
                      ),
                    );
                  },
                  child: Container(
                    width: 64,
                    margin: EdgeInsets.only(right: isLast ? 0 : 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                            color: (item["color"] as Color).withOpacity(0.15),
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
                          style: const TextStyle(
                              fontSize: 9.5, fontWeight: FontWeight.w600),
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
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text("Explore Deals For You",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
