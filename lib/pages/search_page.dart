import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/venue_service.dart';
import 'package:final_project_mhs/services/wishlist_service.dart';
import 'package:final_project_mhs/services/auth_service.dart';
import 'package:final_project_mhs/utils/auth_guard.dart';
import 'package:final_project_mhs/widgets/venue_card.dart';
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

  List<Map<String, dynamic>> _allVenues = [];
  Set<int> _wishlistedIds = {};
  bool _isLoading = true;

  static const _blue = Color(0xFF6DB6E3);

  static const _filters = [
    'Wedding', 'Birthday', 'Concert', 'Seminar', 'Photoshoot',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final venues = await VenueService.getVenues();
    final loggedIn = await AuthService.isLoggedIn();
    Set<int> wishlisted = {};
    if (loggedIn) {
      final wData = await WishlistService.getWishlist();
      wishlisted = wData.map((e) => e['id'] as int? ?? 0).toSet();
    }
    if (mounted) {
      setState(() {
        _allVenues = venues;
        _wishlistedIds = wishlisted;
        _isLoading = false;
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
    var list = _allVenues;

    // Text search
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list
          .where((v) =>
              (v['title'] as String? ?? '').toLowerCase().contains(q) ||
              (v['location'] as String? ?? '').toLowerCase().contains(q))
          .toList();
    }

    // Category chip filter
    if (_activeFilters.isNotEmpty) {
      list = list
          .where((v) =>
              _activeFilters.contains(v['category'] as String? ?? ''))
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _blue))
          : Column(
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
                    itemBuilder: (_, i) {
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
                              Text(f,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: sel
                                          ? Colors.white
                                          : Colors.black54,
                                      fontWeight: FontWeight.w500)),
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
                // Result count
                if (_activeFilters.isNotEmpty || _query.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                    child: Text(
                      '${_results.length} hasil ditemukan',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black45),
                    ),
                  ),
                // Results
                Expanded(
                  child: _results.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off,
                                  size: 64,
                                  color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text(
                                _query.isNotEmpty
                                    ? 'Tidak ada hasil untuk "$_query"'
                                    : 'Tidak ada venue untuk kategori ini',
                                style: TextStyle(
                                    color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          itemCount: _results.length,
                          itemBuilder: (_, i) {
                            final venue = _results[i];
                            final venueId =
                                venue['id'] as int? ?? 0;
                            return VenueCard(
                              venue: venue,
                              isWishlisted:
                                  _wishlistedIds.contains(venueId),
                              showCategoryBadge: true,
                              onTap: () async {
                                final ok =
                                    await AuthGuard.check(context);
                                if (!ok) return;
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BookingDetailPage(
                                          venueId: venueId),
                                    ),
                                  );
                                }
                              },
                              onWishlistTap: () =>
                                  _toggleWishlist(venueId),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
