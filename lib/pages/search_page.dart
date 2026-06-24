import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/wishlist_service.dart';
import 'package:final_project_mhs/services/auth_service.dart';
import 'package:final_project_mhs/utils/auth_guard.dart';
import 'booking/booking.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _ctrl = TextEditingController();
  String _query = '';
  final List<String> _activeFilters = [];
  Set<int> _wishlistedIds = {};

  static const _blue = Color(0xFF6DB6E3);

  static const _filters = [
    'Wedding',
    'Birthday',
    'Concert',
    'Seminar',
    'Photoshoot',
  ];

  static const List<Map<String, dynamic>> _venues = [
    {
      "id": 1,
      "title": "Le Blanc Wedding",
      "category": "Wedding",
      "rating": "4.9",
      "review": "97",
      "location": "BSD",
      "price": "Rp 15.000.000",
      "image":
          "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=400&auto=format&fit=crop",
    },
    {
      "id": 2,
      "title": "Elegant Wedding Organizer",
      "category": "Wedding",
      "rating": "4.8",
      "review": "97",
      "location": "BSD",
      "price": "Rp 25.000.000",
      "image":
          "https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=400&auto=format&fit=crop",
    },
    {
      "id": 3,
      "title": "Amanjiwo Hotel",
      "category": "Wedding",
      "rating": "4.4",
      "review": "125",
      "location": "JAWA TENGAH",
      "price": "Rp 15.000.000",
      "image":
          "https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400&auto=format&fit=crop",
    },
    {
      "id": 4,
      "title": "Party Planner Birthday Organizer",
      "category": "Birthday",
      "rating": "4.4",
      "review": "125",
      "location": "JabaDeTaBek",
      "price": "Rp 5.000.000",
      "image":
          "https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?q=80&w=400&auto=format&fit=crop",
    },
    {
      "id": 5,
      "title": "Happy Moment Birthday Crew",
      "category": "Birthday",
      "rating": "4.3",
      "review": "88",
      "location": "Tangerang",
      "price": "Rp 3.500.000",
      "image":
          "https://images.unsplash.com/photo-1530103862676-de8c9debad1d?q=80&w=400&auto=format&fit=crop",
    },
    {
      "id": 6,
      "title": "Groovy Event Organizer",
      "category": "Concert",
      "rating": "4.6",
      "review": "80",
      "location": "ICE BSD",
      "price": "Rp 10.000.000",
      "image":
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=400&auto=format&fit=crop",
    },
    {
      "id": 7,
      "title": "Soundwave Concert Production",
      "category": "Concert",
      "rating": "4.7",
      "review": "63",
      "location": "Jakarta Utara",
      "price": "Rp 15.000.000",
      "image":
          "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?q=80&w=400&auto=format&fit=crop",
    },
    {
      "id": 8,
      "title": "BizTalk Seminar Organizer",
      "category": "Seminar",
      "rating": "4.5",
      "review": "55",
      "location": "SCBD Jakarta",
      "price": "Rp 6.000.000",
      "image":
          "https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=400&auto=format&fit=crop",
    },
    {
      "id": 9,
      "title": "ProConference Planner",
      "category": "Seminar",
      "rating": "4.4",
      "review": "37",
      "location": "Serpong",
      "price": "Rp 4.500.000",
      "image":
          "https://images.unsplash.com/photo-1505373877841-8d25f7d46678?q=80&w=400&auto=format&fit=crop",
    },
    {
      "id": 10,
      "title": "SnapShot Studio",
      "category": "Photoshoot",
      "rating": "4.8",
      "review": "112",
      "location": "Kemang, Jakarta",
      "price": "Rp 2.000.000",
      "image":
          "https://images.unsplash.com/photo-1452587925148-ce544e77e70d?q=80&w=400&auto=format&fit=crop",
    },
    {
      "id": 11,
      "title": "LensArt Photography",
      "category": "Photoshoot",
      "rating": "4.6",
      "review": "74",
      "location": "Bintaro",
      "price": "Rp 1.500.000",
      "image":
          "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=400&auto=format&fit=crop",
    },
  ];

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

  List<Map<String, dynamic>> get _results {
    var list = _venues;

    // Text search
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list
          .where((v) =>
              (v["title"] as String).toLowerCase().contains(q) ||
              (v["location"] as String).toLowerCase().contains(q))
          .toList();
    }

    // Category chip filter — chips map directly to category names
    if (_activeFilters.isNotEmpty) {
      list = list
          .where((v) =>
              _activeFilters.contains(v["category"] as String))
          .toList();
    }

    return list;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Venue or Event Organizer',
            hintStyle:
                const TextStyle(fontSize: 14, color: Colors.black38),
            filled: true,
            fillColor: const Color(0xFFF0F0F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 18, vertical: 10),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close,
                        size: 18, color: Colors.black38),
                    onPressed: () {
                      _ctrl.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              itemBuilder: (context, i) {
                final f = _filters[i];
                final sel = _activeFilters.contains(f);
                return GestureDetector(
                  onTap: () => setState(() {
                    sel
                        ? _activeFilters.remove(f)
                        : _activeFilters.add(f);
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel ? _blue : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: sel ? _blue : Colors.black12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          f,
                          style: TextStyle(
                            fontSize: 12,
                            color: sel ? Colors.white : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (sel) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.close,
                              size: 12, color: Colors.white),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Results count
          if (_activeFilters.isNotEmpty || _query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Text(
                '${_results.length} hasil ditemukan',
                style: const TextStyle(
                    fontSize: 12, color: Colors.black45),
              ),
            ),
          // Results list
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          _query.isNotEmpty
                              ? 'Tidak ada hasil untuk "$_query"'
                              : 'Tidak ada venue untuk kategori ini',
                          style:
                              TextStyle(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    itemCount: _results.length,
                    itemBuilder: (context, i) =>
                        _buildCard(context, _results[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> v) {
    final venueId = v['id'] as int? ?? 1;
    final isWishlisted = _wishlistedIds.contains(venueId);
    final Color catColor;
    switch ((v["category"] as String).toLowerCase()) {
      case 'wedding':
        catColor = Colors.pink;
        break;
      case 'birthday':
        catColor = Colors.orange;
        break;
      case 'concert':
        catColor = Colors.purple;
        break;
      case 'seminar':
        catColor = Colors.blue;
        break;
      case 'photoshoot':
        catColor = Colors.teal;
        break;
      default:
        catColor = _blue;
    }

    return GestureDetector(
      onTap: () async {
        final ok = await AuthGuard.check(context);
        if (!ok) return;
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  BookingDetailPage(venueId: venueId),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: Image.network(
                v["image"],
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110,
                  height: 110,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + wishlist button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(v["title"],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
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
                    const SizedBox(height: 4),
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: catColor.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        v["category"] as String,
                        style: TextStyle(
                            fontSize: 10,
                            color: catColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber, size: 15),
                        const SizedBox(width: 3),
                        Text(v["rating"],
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 8),
                        const Icon(Icons.chat_bubble_outline,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text('${v["review"]} Review',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 13, color: Colors.black38),
                        const SizedBox(width: 3),
                        Text(v["location"],
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Start from',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey)),
                          Text(v["price"],
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
    );
  }
}
