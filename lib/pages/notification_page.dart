import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/activity_log_service.dart';
import 'chat/chat_list_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const _blue = Color(0xFF6DB6E3);

  List<Map<String, dynamic>> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ActivityLogService.getActivities();
    await ActivityLogService.markSeen();
    if (mounted) setState(() { _activities = data; _isLoading = false; });
  }

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1)  return 'Baru saja';
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
      if (diff.inHours < 24)   return '${diff.inHours} jam lalu';
      if (diff.inDays == 1)    return 'Kemarin';
      if (diff.inDays < 7)     return '${diff.inDays} hari lalu';
      const months = ['','Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
      return '${dt.day} ${months[dt.month]}';
    } catch (_) {
      return '';
    }
  }

  _ActivityMeta _meta(String type) {
    switch (type) {
      case 'booking_created':
        return const _ActivityMeta(Icons.calendar_today_outlined, Colors.green, Color(0xFFE8F5E9));
      case 'payment_confirmed':
        return const _ActivityMeta(Icons.payment_outlined, _blue, Color(0xFFE3F2FD));
      case 'review_added':
        return const _ActivityMeta(Icons.star_rounded, Colors.amber, Color(0xFFFFFDE7));
      case 'wishlist_add':
        return const _ActivityMeta(Icons.favorite_rounded, Colors.pink, Color(0xFFFCE4EC));
      case 'wishlist_remove':
        return const _ActivityMeta(Icons.favorite_border, Colors.grey, Color(0xFFF5F5F5));
      case 'chat_started':
        return const _ActivityMeta(Icons.chat_bubble_outline, _blue, Color(0xFFE3F2FD));
      default:
        return const _ActivityMeta(Icons.notifications_none_outlined, Colors.grey, Color(0xFFF5F5F5));
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
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black87),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatListPage()),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _blue))
          : _activities.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  color: _blue,
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _activities.length,
                    itemBuilder: (_, i) => _buildCard(_activities[i]),
                  ),
                ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Belum ada notifikasi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black45),
          ),
          const SizedBox(height: 6),
          const Text(
            'Aktivitas kamu akan muncul di sini',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> a) {
    final type     = a['type'] as String? ?? '';
    final title    = a['title'] as String? ?? '';
    final subtitle = a['subtitle'] as String? ?? '';
    final imageUrl = a['image_url'] as String? ?? '';
    final time     = _formatTime(a['time'] as String?);
    final meta     = _meta(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon or image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: meta.bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        meta.icon,
                        size: 24,
                        color: meta.color,
                      ),
                    ),
                  )
                : Icon(meta.icon, size: 24, color: meta.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: const TextStyle(fontSize: 11, color: Colors.black38),
          ),
        ],
      ),
    );
  }
}

class _ActivityMeta {
  final IconData icon;
  final Color color;
  final Color bgColor;
  const _ActivityMeta(this.icon, this.color, this.bgColor);
}
