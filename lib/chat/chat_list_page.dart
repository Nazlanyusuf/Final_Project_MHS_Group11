import 'package:flutter/material.dart';
import 'chat_inside_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  static const _convos = [
    {
      "name": "Elegant Wedding Organizer",
      "last": "Message...",
      "time": "10:00",
      "unread": 0,
    },
    {
      "name": "Amanjiwo Hotel",
      "last": "Message...",
      "time": "09:30",
      "unread": 2,
    },
    {
      "name": "Le Blanc",
      "last": "Message...",
      "time": "Yesterday",
      "unread": 0,
    },
    {
      "name": "Pullman Hotel",
      "last": "Message...",
      "time": "Yesterday",
      "unread": 1,
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
          'Chat',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: _convos.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, indent: 76, endIndent: 16),
          itemBuilder: (context, index) {
            final c = _convos[index];
            return ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ChatInsidePage(venueName: c["name"] as String),
                ),
              ),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFF6DB6E3),
                child: Text(
                  (c["name"] as String)[0],
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              title: Text(
                c["name"] as String,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: Text(
                c["last"] as String,
                style: const TextStyle(fontSize: 12, color: Colors.black38),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    c["time"] as String,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black38),
                  ),
                  if ((c["unread"] as int) > 0) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6DB6E3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${c["unread"]}',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            );
          },
        ),
      ),
    );
  }
}
