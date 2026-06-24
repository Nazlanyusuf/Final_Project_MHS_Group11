import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/booking_service.dart';
import 'package:final_project_mhs/pages/payment/payment.dart';
import 'chat/chat_inside_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _blue = Color(0xFF6DB6E3);

  List<Map<String, dynamic>> _ongoing   = [];
  List<Map<String, dynamic>> _completed = [];
  List<Map<String, dynamic>> _cancelled = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      BookingService.getBookings(status: 'ongoing'),
      BookingService.getBookings(status: 'completed'),
      BookingService.getBookings(status: 'cancelled'),
    ]);
    if (mounted) {
      setState(() {
        _ongoing   = results[0];
        _completed = results[1];
        _cancelled = results[2];
        _isLoading = false;
      });
    }
  }

  String _formatDate(String apiDate) {
    // "YYYY-MM-DD" → "15 January 2026"
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    try {
      final parts = apiDate.split('-');
      if (parts.length == 3) {
        final day   = int.parse(parts[2]);
        final month = int.parse(parts[1]);
        final year  = parts[0];
        return '$day ${months[month]} $year';
      }
    } catch (_) {}
    return apiDate;
  }

  double _parsePrice(String priceStr) {
    final cleaned = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  Future<void> _cancel(int bookingId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Batalkan Booking?'),
        content: const Text('Apakah kamu yakin ingin membatalkan booking ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Batalkan',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final ok = await BookingService.cancelBooking(bookingId);
    if (mounted) {
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking berhasil dibatalkan'),
            backgroundColor: Colors.green,
          ),
        );
        _load();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membatalkan booking')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Activity',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black45),
            onPressed: _load,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: _blue,
          unselectedLabelColor: Colors.black38,
          indicatorColor: _blue,
          indicatorWeight: 2.5,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w400),
          tabs: [
            Tab(text: 'Ongoing (${_ongoing.length})'),
            Tab(text: 'Completed (${_completed.length})'),
            const Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: _blue))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(_ongoing,
                    status: 'Ongoing',
                    statusColor: const Color(0xFFF5A623),
                    showActions: true),
                _buildList(_completed,
                    status: 'Completed',
                    statusColor: Colors.green),
                _buildList(_cancelled,
                    status: 'Cancelled',
                    statusColor: Colors.red),
              ],
            ),
    );
  }

  Widget _buildList(
    List<Map<String, dynamic>> items, {
    required String status,
    required Color statusColor,
    bool showActions = false,
  }) {
    if (items.isEmpty) {
      return RefreshIndicator(
        color: _blue,
        onRefresh: _load,
        child: ListView(
          children: [
            SizedBox(
              height: 400,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy,
                        size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      status == 'Ongoing'
                          ? 'Belum ada booking aktif'
                          : status == 'Completed'
                              ? 'Belum ada booking selesai'
                              : 'Tidak ada booking dibatalkan',
                      style: TextStyle(
                          color: Colors.grey.shade400, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: _blue,
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: items.length,
        itemBuilder: (ctx, i) => _buildCard(
          ctx,
          items[i],
          status: status,
          statusColor: statusColor,
          showActions: showActions,
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    Map<String, dynamic> booking, {
    required String status,
    required Color statusColor,
    bool showActions = false,
  }) {
    final venue       = booking['venue'] as Map<String, dynamic>? ?? {};
    final venueName   = venue['title']     as String? ?? '-';
    final category    = venue['category']  as String? ?? '-';
    final imageUrl    = venue['image_url'] as String? ?? '';
    final location    = venue['location']  as String? ?? '-';
    final venuePrice  = venue['price']     as String? ?? '';
    final eventDateRaw = booking['event_date'] as String? ?? '-';
    final eventDate   = _formatDate(eventDateRaw);
    final eventName   = booking['event_name'] as String? ?? '';
    final guestCount  = booking['guest_count'] as int? ?? 1;
    final bookingId   = booking['id'] as int? ?? 0;
    final packagePrice = _parsePrice(venuePrice);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80, height: 80,
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
                    venueName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (eventName.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(eventName,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black45)),
                  ],
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _blue.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF3A8FC4),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 12, color: Colors.black38),
                      const SizedBox(width: 4),
                      Text(eventDate,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 12, color: Colors.black38),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(location,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black54),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Status chip + secondary actions row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6, height: 6,
                              decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 4),
                            Text(status,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: statusColor,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      if (showActions)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 28,
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatInsidePage(
                                        venueName: venueName),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                                child: const Text('Chat',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            SizedBox(
                              height: 28,
                              child: OutlinedButton(
                                onPressed: () => _cancel(bookingId),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(
                                      color: Colors.red, width: 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                ),
                                child: const Text('Batal',
                                    style: TextStyle(fontSize: 11)),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  // Bayar button — full width, only for ongoing
                  if (showActions) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentPage(
                              packageName: venueName,
                              eventName: eventName,
                              eventDate: eventDate,
                              guestCount: guestCount,
                              packagePrice: packagePrice,
                              dpAmount: packagePrice * 0.3,
                              bookingId: bookingId,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text(
                          'Lanjutkan Pembayaran',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
