import 'package:flutter/material.dart';

/// Reusable horizontal venue card — used in Dashboard, Search, and VenuePicker.
class VenueCard extends StatelessWidget {
  final Map<String, dynamic> venue;
  final bool isWishlisted;
  final bool showCategoryBadge;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;

  const VenueCard({
    super.key,
    required this.venue,
    this.isWishlisted = false,
    this.showCategoryBadge = false,
    this.onTap,
    this.onWishlistTap,
  });

  // ── Field helpers ──────────────────────────────────────────────
  String get _title => venue['title'] as String? ?? '-';
  String get _category => venue['category'] as String? ?? '';

  /// Support both common API keys.
  String get _imageUrl =>
      (venue['image_url'] ?? venue['imageUrl'] ?? venue['image']) as String? ?? '';

  String get _location => venue['location'] as String? ?? '-';
  String get _price => venue['price'] as String? ?? '-';
  String get _rating => (venue['rating'] ?? '0').toString();
  String get _reviewCount =>
      (venue['review'] ?? venue['review_count'])?.toString() ?? '0';

  Color get _categoryColor {
    switch (_category.toLowerCase()) {
      case 'wedding':
        return Colors.pink;
      case 'birthday':
        return Colors.orange;
      case 'concert':
        return Colors.purple;
      case 'seminar':
        return Colors.blue;
      case 'photoshoot':
        return Colors.teal;
      default:
        return const Color(0xFF6DB6E3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            // Venue image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: _imageUrl.isEmpty
                  ? Container(
                      width: 110,
                      height: 110,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    )
                  : Image.network(
                      _imageUrl,
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
            // Info
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
                            _title,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (onWishlistTap != null)
                          GestureDetector(
                            onTap: onWishlistTap,
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

                    // Category badge (optional)
                    if (showCategoryBadge) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _categoryColor.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _category,
                          style: TextStyle(
                              fontSize: 10,
                              color: _categoryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],

                    // Rating + reviews
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber, size: 15),
                        const SizedBox(width: 3),
                        Text(_rating, style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 8),
                        const Icon(Icons.chat_bubble_outline,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text('$_reviewCount Review',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 13, color: Colors.black54),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            _location,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Price
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Start from',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey)),
                          Text(_price,
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
    );
  }
}

