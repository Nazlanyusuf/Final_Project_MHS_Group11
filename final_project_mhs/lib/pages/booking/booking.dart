import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/venue_service.dart';
import 'package:final_project_mhs/services/review_service.dart';
import 'package:final_project_mhs/services/chat_service.dart';
import 'package:final_project_mhs/services/activity_log_service.dart';
import '../chat/chat_inside_page.dart';
import 'booking_detail.dart';

class BookingDetailPage extends StatefulWidget {
  final int venueId;
  const BookingDetailPage({super.key, this.venueId = 1});

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  static const _blue = Color(0xFF6DB6E3);

  Map<String, dynamic>? _venue;
  bool _isLoading = true;
  int _localReviewCount = 0;

  @override
  void initState() {
    super.initState();
    _loadVenue();
  }

  Future<void> _loadVenue() async {
    final venueF   = VenueService.getVenue(widget.venueId);
    final reviewsF = ReviewService.getMyReviews();
    final data    = await venueF;
    final reviews = await reviewsF;
    final localCount = reviews
        .where((r) => r['venue_id'] == widget.venueId)
        .length;
    if (mounted) {
      setState(() {
        _venue = data;
        _localReviewCount = localCount;
        _isLoading = false;
      });
    }
  }

  Future<void> _openChat() async {
    await ChatService.addOrMoveToTop(_title, imageUrl: _imageUrl);
    await ActivityLogService.log(
      type: 'chat_started',
      title: 'Mulai Chat',
      subtitle: _title,
      imageUrl: _imageUrl,
    );
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatInsidePage(venueName: _title)),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────
  String get _title =>
      _venue?['title'] as String? ?? 'Event Organizer';
  String get _category =>
      _venue?['category'] as String? ?? 'Wedding';
  String get _imageUrl =>
      (_venue?['image_url'] ?? _venue?['image']) as String? ??
      'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1200&auto=format&fit=crop';
  String get _rating =>
      (_venue?['rating'] ?? '4.9').toString();
  int get _totalReviewCount {
    final api = int.tryParse(
        (_venue?['review'] ?? _venue?['review_count'] ?? '0').toString()) ?? 0;
    return api + _localReviewCount;
  }
  String get _price =>
      _venue?['price'] as String? ?? 'Rp 8.000.000';

  Color get _categoryColor {
    switch (_category.toLowerCase()) {
      case 'wedding':    return Colors.pink;
      case 'birthday':   return Colors.orange;
      case 'concert':    return Colors.purple;
      case 'seminar':    return Colors.blue;
      case 'photoshoot': return Colors.teal;
      default:           return _blue;
    }
  }

  // ── Build ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
            child: CircularProgressIndicator(color: _blue)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Header image ─────────────────────────────────────
            Stack(
              children: [
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(_imageUrl),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                // Gradient overlay
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  top: 50,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                    ),
                  ),
                ),
                // Chat button (top-right)
                Positioned(
                  top: 50,
                  right: 20,
                  child: GestureDetector(
                    onTap: _openChat,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chat_bubble_outline,
                          color: Colors.white),
                    ),
                  ),
                ),
                // Venue info overlay
                Positioned(
                  bottom: 24,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _categoryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  _rating,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ── Review card ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 6),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _rating,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              const TextSpan(
                                text: ' / 5',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Based on $_totalReviewCount reviews',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 14),
                    _buildRatingBar(5, 0.75),
                    _buildRatingBar(4, 0.15),
                    _buildRatingBar(3, 0.10),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ── Packages ──────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Packages For You',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 14),

            _buildPackageCard(
              context,
              title: 'Platinum',
              subtitle: 'Best for intimate events',
              price: _price,
              headerColor: const Color(0xFFC8D0F0),
              features: [
                'Luxurious full-set decoration',
                'MC + band + entertainment',
                'Photography + cinematic video',
                'Catering for 500 guests',
                'D-Day Coordinator',
              ],
            ),

            _buildPackageCard(
              context,
              title: 'Gold',
              subtitle: 'Popular package',
              price: _price,
              headerColor: const Color(0xFFC6B93D),
              features: [
                'Premium decoration',
                'MC + live entertainment',
                'Photographer + Videographer',
                'Catering for 200 guests',
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int star, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$star ⭐',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor:
                    const AlwaysStoppedAnimation(Colors.blue),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('${(value * 100).toInt()}%'),
        ],
      ),
    );
  }

  Widget _buildPackageCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String price,
    required Color headerColor,
    required List<String> features,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Package header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold)),
                      Text(subtitle,
                          style: const TextStyle(
                              color: Colors.black54)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Start from',
                          style: TextStyle(color: Colors.black54)),
                      Text(price,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            // Package body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...features.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.teal, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(f,
                                  style:
                                      const TextStyle(fontSize: 15))),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('DP starts from',
                              style:
                                  TextStyle(color: Colors.black54)),
                          Text(
                            'Rp ${_dpAmount(price)}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          barrierColor: Colors.black54,
                          builder: (_) => BookingFormPage(
                            packageName: title,
                            price: price,
                            venueId: widget.venueId,
                            imageUrl: _imageUrl,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 14),
                          decoration: BoxDecoration(
                            color: _blue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Choose',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
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
    );
  }

  // Parse price string and calculate 30% DP
  String _dpAmount(String priceStr) {
    final digits = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = int.tryParse(digits) ?? 0;
    final dp = (amount * 0.3).toInt();
    // Format with dots
    final formatted = dp.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return formatted;
  }
}
