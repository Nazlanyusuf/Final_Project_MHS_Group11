import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project_mhs/services/wishlist_service.dart';
import 'package:final_project_mhs/services/auth_service.dart';
import 'package:final_project_mhs/widgets/guest_view.dart';
import 'package:final_project_mhs/pages/venue_picker_page.dart';
import 'booking/booking.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  static const _blue = Color(0xFF6DB6E3);
  static const _prefsKey = 'wishlist_collections';

  List<Map<String, dynamic>> _wishlists = [];
  List<String> _collections = [];
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() => _isLoading = true);
    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;
    if (!loggedIn) {
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
      return;
    }
    setState(() => _isLoggedIn = true);
    await _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCollections = prefs.getStringList(_prefsKey) ?? [];
    final data = await WishlistService.getWishlist();
    if (mounted) {
      setState(() {
        _wishlists = data;
        _collections = savedCollections;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCollections() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _collections);
  }

  Future<void> _remove(int venueId, int index) async {
    final removed = _wishlists[index];
    setState(() => _wishlists.removeAt(index));
    final ok = await WishlistService.removeWishlist(venueId);
    if (!ok && mounted) {
      setState(() => _wishlists.insert(index, removed));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus dari wishlist')),
      );
    }
  }

  Future<void> _openVenuePicker() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const VenuePickerPage()),
    );
    if (result == true && mounted) {
      _loadData();
    }
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    try {
      final datePart = raw.split('T').first.split(' ').first;
      final parts = datePart.split('-');
      if (parts.length == 3) {
        final day = int.parse(parts[2]);
        final month = int.parse(parts[1]);
        final year = parts[0];
        return '$day ${months[month]} $year';
      }
    } catch (_) {}
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Wishlist',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black45),
              onPressed: _loadData,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _blue))
          : !_isLoggedIn
              ? _buildGuestView()
              : RefreshIndicator(
                  color: _blue,
                  onRefresh: _loadData,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Collection',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _openVenuePicker,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text(
                                      'Create new Collection'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _blue,
                                    side:
                                        const BorderSide(color: _blue),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                              if (_collections.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 34,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _collections.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 8),
                                    itemBuilder: (ctx, i) => Chip(
                                      label: Text(_collections[i],
                                          style: const TextStyle(
                                              fontSize: 12)),
                                      backgroundColor:
                                          _blue.withOpacity(0.12),
                                      labelStyle: const TextStyle(
                                          color: Color(0xFF3A8FC4)),
                                      deleteIcon: const Icon(Icons.close,
                                          size: 14,
                                          color: Color(0xFF3A8FC4)),
                                      onDeleted: () async {
                                        setState(() =>
                                            _collections.removeAt(i));
                                        await _saveCollections();
                                      },
                                      side: BorderSide.none,
                                      visualDensity:
                                          VisualDensity.compact,
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      if (_wishlists.isEmpty)
                        SliverFillRemaining(child: _buildEmpty())
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, i) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: _buildCard(
                                  ctx, _wishlists[i], i),
                            ),
                            childCount: _wishlists.length,
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildGuestView() {
    return const GuestView(
      icon: Icons.favorite_border,
      message: 'Login untuk menyimpan venue favoritmu ke dalam wishlist.',
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Belum ada wishlist',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black45),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tambahkan venue favoritmu\ndari halaman utama',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, Map<String, dynamic> item, int index) {
    final venueId = item['id'] as int? ?? 0;
    final title = item['title'] as String? ?? '-';
    final category = item['category'] as String? ?? '';
    final imageUrl = item['image_url'] as String? ?? '';
    final location = item['location'] as String? ?? '-';
    final savedDate = _formatDate(item['created_at'] as String?);

    final Color categoryColor;
    switch (category.toLowerCase()) {
      case 'wedding':
        categoryColor = Colors.pink;
        break;
      case 'birthday':
        categoryColor = Colors.orange;
        break;
      case 'concert':
        categoryColor = Colors.purple;
        break;
      case 'seminar':
        categoryColor = Colors.blue;
        break;
      case 'photoshoot':
        categoryColor = Colors.teal;
        break;
      default:
        categoryColor = _blue;
    }

    return Dismissible(
      key: ValueKey(venueId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline,
            color: Colors.white, size: 28),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: const Text('Hapus dari Wishlist?'),
                content: Text('Hapus "$title" dari wishlist?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Hapus',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => _remove(venueId, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.07)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 88,
                    height: 88,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                            fontSize: 11,
                            color: categoryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (savedDate.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 12, color: Colors.black38),
                          const SizedBox(width: 4),
                          Text(savedDate,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 12, color: Colors.black38),
                            const SizedBox(width: 4),
                            Text(
                              location,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingDetailPage(
                                    venueId: venueId),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8)),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                            ),
                            child: const Text('Book',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
