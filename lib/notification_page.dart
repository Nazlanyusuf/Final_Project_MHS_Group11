import 'package:flutter/material.dart';
import 'chat/chat_list_page.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static const List<Map<String, String>> _notifs = [
    {
      "title": "Booking Success",
      "venue": "Elegant Wedding Organizer",
      "time": "Today 7PM",
      "image":
          "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=200&auto=format&fit=crop",
    },
    {
      "title": "Booking Success",
      "venue": "Elegant Wedding Organizer",
      "time": "Today 7PM",
      "image":
          "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=200&auto=format&fit=crop",
    },
    {
      "title": "Booking Confirmed",
      "venue": "Le Blanc Wedding Organizer",
      "time": "Today 5PM",
      "image":
          "https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=200&auto=format&fit=crop",
    },
    {
      "title": "Payment Received",
      "venue": "Elegant Wedding Organizer",
      "time": "Today 4PM",
      "image":
          "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=200&auto=format&fit=crop",
    },
  ];

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
          'Notification',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline,
                color: Colors.black87),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatListPage()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Booking Status',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'See All >',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6DB6E3),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ..._notifs.map((n) => _buildCard(n)),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, String> n) {
    final iconColor = n["title"] == "Booking Success" || n["title"] == "Booking Confirmed"
        ? Colors.green
        : const Color(0xFF6DB6E3);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  n["image"]!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n["title"]!,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  n["venue"]!,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            n["time"]!,
            style: const TextStyle(fontSize: 11, color: Colors.black38),
          ),
        ],
      ),
    );
  }
}
