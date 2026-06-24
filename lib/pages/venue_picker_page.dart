import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/wishlist_service.dart';

class VenuePickerPage extends StatefulWidget {
  const VenuePickerPage({super.key});

  @override
  State<VenuePickerPage> createState() => _VenuePickerPageState();
}

class _VenuePickerPageState extends State<VenuePickerPage> {
  static const _blue = Color(0xFF6DB6E3);

  static const List<Map<String, dynamic>> _allVenues = [
    {"id": 1, "title": "Le Blanc Wedding Organizer", "category": "Wedding", "location": "BSD", "image": "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=400&auto=format&fit=crop"},
    {"id": 2, "title": "Elegant Wedding Organizer", "category": "Wedding", "location": "Jakarta Selatan", "image": "https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=400&auto=format&fit=crop"},
    {"id": 3, "title": "Amanjiwo Exclusive Wedding", "category": "Wedding", "location": "Jawa Tengah", "image": "https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400&auto=format&fit=crop"},
    {"id": 4, "title": "Party Planner Birthday Organizer", "category": "Birthday", "location": "JabaDeTaBek", "image": "https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?q=80&w=400&auto=format&fit=crop"},
    {"id": 5, "title": "Happy Moment Birthday Crew", "category": "Birthday", "location": "Tangerang", "image": "https://images.unsplash.com/photo-1530103862676-de8c9debad1d?q=80&w=400&auto=format&fit=crop"},
    {"id": 6, "title": "Groovy Event Organizer", "category": "Concert", "location": "ICE BSD", "image": "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=400&auto=format&fit=crop"},
    {"id": 7, "title": "Soundwave Concert Production", "category": "Concert", "location": "Jakarta Utara", "image": "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?q=80&w=400&auto=format&fit=crop"},
    {"id": 8, "title": "BizTalk Seminar Organizer", "category": "Seminar", "location": "SCBD Jakarta", "image": "https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=400&auto=format&fit=crop"},
    {"id": 9, "title": "ProConference Planner", "category": "Seminar", "location": "Serpong", "image": "https://images.unsplash.com/photo-1505373877841-8d25f7d46678?q=80&w=400&auto=format&fit=crop"},
    {"id": 10, "title": "SnapShot Studio", "category": "Photoshoot", "location": "Kemang, Jakarta", "image": "https://images.unsplash.com/photo-1452587925148-ce544e77e70d?q=80&w=400&auto=format&fit=crop"},
    {"id": 11, "title": "LensArt Photography", "category": "Photoshoot", "location": "Bintaro", "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=400&auto=format&fit=crop"},
  ];

  Set<int> _wishlistedIds = {};
  bool _isLoading = true;
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua', 'Wedding', 'Birthday', 'Concert', 'Seminar', 'Photoshoot',
  ];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    setState(() => _isLoading = true);
    final data = await WishlistService.getWishlist();
    if (mounted) {
      setState(() {
        _wishlistedIds = data.map((e) => e['id'] as int? ?? 0).toSet();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggle(int venueId) async {
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

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 'Semua') return _allVenues;
    return _allVenues
        .where((v) => v['category'] == _selectedCategory)
        .toList();
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
        title: const Text(
          'Tambah ke Wishlist',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category filter chips
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final cat = _categories[i];
                  final sel = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel ? _blue : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: sel ? _blue : Colors.black12),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          color: sel ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.black12),
          // Venue list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: _blue))
                : _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 56, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('Tidak ada venue',
                                style: TextStyle(
                                    color: Colors.grey.shade400)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        itemCount: _filtered.length,
                        itemBuilder: (ctx, i) =>
                            _buildItem(_filtered[i]),
                      ),
          ),
          // Done button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  '${_wishlistedIds.length} dipilih — Selesai',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> venue) {
    final id = venue['id'] as int;
    final isWishlisted = _wishlistedIds.contains(id);
    final Color catColor;
    switch ((venue['category'] as String).toLowerCase()) {
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              isWishlisted ? _blue.withOpacity(0.5) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            venue['image'] as String,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 56,
              height: 56,
              color: Colors.grey.shade200,
              child: const Icon(Icons.image_not_supported,
                  color: Colors.grey, size: 20),
            ),
          ),
        ),
        title: Text(
          venue['title'] as String,
          style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                venue['category'] as String,
                style: TextStyle(
                    fontSize: 10,
                    color: catColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                venue['location'] as String,
                style: const TextStyle(
                    fontSize: 11, color: Colors.black45),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: GestureDetector(
          onTap: () => _toggle(id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isWishlisted
                  ? Colors.red.shade50
                  : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.redAccent : Colors.grey,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
