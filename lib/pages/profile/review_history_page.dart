import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/review_service.dart';

class ReviewHistoryPage extends StatefulWidget {
  const ReviewHistoryPage({super.key});

  @override
  State<ReviewHistoryPage> createState() => _ReviewHistoryPageState();
}

class _ReviewHistoryPageState extends State<ReviewHistoryPage> {
  static const _blue = Color(0xFF6DB6E3);

  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ReviewService.getMyReviews();
    // Newest first
    data.sort((a, b) {
      final da = DateTime.tryParse(a['created_at'] as String? ?? '') ?? DateTime(2000);
      final db = DateTime.tryParse(b['created_at'] as String? ?? '') ?? DateTime(2000);
      return db.compareTo(da);
    });
    if (mounted) setState(() { _reviews = data; _isLoading = false; });
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day} ${months[dt.month]} ${dt.year}';
    } catch (_) {
      return '';
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Review Saya',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _blue))
          : _reviews.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  color: _blue,
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _reviews.length,
                    itemBuilder: (_, i) => _buildCard(_reviews[i]),
                  ),
                ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Belum ada review',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black45),
          ),
          const SizedBox(height: 6),
          const Text(
            'Review akan muncul setelah\nbooking kamu selesai',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> r) {
    final venueName = r['venue_name'] as String? ?? '-';
    final rating    = r['rating'] as int? ?? 0;
    final comment   = r['comment'] as String? ?? '';
    final date      = _formatDate(r['created_at'] as String?);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Venue name + date ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  venueName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (date.isNotEmpty)
                Text(
                  date,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.black38),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Star rating ────────────────────────────────────
          Row(
            children: [
              ...List.generate(5, (i) => Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Icon(
                  i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 20,
                  color: i < rating ? Colors.amber : Colors.black26,
                ),
              )),
              const SizedBox(width: 6),
              Text(
                _ratingLabel(rating),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: rating > 0 ? Colors.amber.shade700 : Colors.black38,
                ),
              ),
            ],
          ),

          // ── Comment ────────────────────────────────────────
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                comment,
                style: const TextStyle(
                    fontSize: 13, color: Colors.black54, height: 1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _ratingLabel(int r) {
    switch (r) {
      case 1: return 'Sangat Buruk';
      case 2: return 'Buruk';
      case 3: return 'Cukup';
      case 4: return 'Bagus';
      case 5: return 'Sangat Bagus!';
      default: return '';
    }
  }
}
