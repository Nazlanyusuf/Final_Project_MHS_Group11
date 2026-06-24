import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/venue_service.dart';
import 'package:final_project_mhs/services/wishlist_service.dart';

class VenuePickerPage extends StatefulWidget {
  const VenuePickerPage({super.key});

  @override
  State<VenuePickerPage> createState() => _VenuePickerPageState();
}

class _VenuePickerPageState extends State<VenuePickerPage> {
  static const _blue = Color(0xFF6DB6E3);

  List<Map<String, dynamic>> _allVenues = [];
  Set<int> _wishlistedIds = {};
  bool _isLoading = true;
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua', 'Wedding', 'Birthday', 'Concert', 'Seminar', 'Photoshoot',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final venues = await VenueService.getVenues();
    final wishlistData = await WishlistService.getWishlist();
    if (mounted) {
      setState(() {
        _allVenues = venues;
        _wishlistedIds =
            wishlistData.map((e) => e['id'] as int? ?? 0).toSet();
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

  Color _catColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'wedding':    return Colors.pink;
      case 'birthday':   return Colors.orange;
      case 'concert':    return Colors.purple;
      case 'seminar':    return Colors.blue;
      case 'photoshoot': return Colors.teal;
      default:           return _blue;
    }
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
          onPressed: () => Navigator.pop(context, true),
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
                itemBuilder: (_, i) {
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
                        itemBuilder: (_, i) =>
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
    final id = venue['id'] as int? ?? 0;
    final category = venue['category'] as String? ?? '';
    final isWishlisted = _wishlistedIds.contains(id);
    final catColor = _catColor(category);
    final imageUrl =
        (venue['image_url'] ?? venue['image']) as String? ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isWishlisted
              ? _blue.withOpacity(0.5)
              : Colors.transparent,
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
            imageUrl,
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
          venue['title'] as String? ?? '-',
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(
                  horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                category,
                style: TextStyle(
                    fontSize: 10,
                    color: catColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                venue['location'] as String? ?? '-',
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
