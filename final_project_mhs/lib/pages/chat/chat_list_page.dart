import 'package:flutter/material.dart';
import 'package:final_project_mhs/services/chat_service.dart';
import 'chat_inside_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  static const _blue = Color(0xFF6DB6E3);
  List<Map<String, dynamic>> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ChatService.getContacts();
    if (mounted) setState(() { _contacts = data; _isLoading = false; });
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
          'Chat',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _blue))
          : _contacts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text('Belum ada chat', style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: _blue,
                  onRefresh: _load,
                  child: Container(
                    color: Colors.white,
                    child: ListView.separated(
                      itemCount: _contacts.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 76, endIndent: 16),
                      itemBuilder: (context, index) {
                        final c = _contacts[index];
                        final name    = c['name']   as String? ?? '';
                        final last    = c['last']   as String? ?? '';
                        final time    = c['time']   as String? ?? '';
                        final unread  = c['unread'] as int?    ?? 0;
                        final imgUrl  = c['image_url'] as String? ?? '';
                        return ListTile(
                          onTap: () async {
                            await ChatService.markRead(name);
                            if (!context.mounted) return;
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatInsidePage(venueName: name),
                              ),
                            );
                            _load();
                          },
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: _blue,
                            backgroundImage: imgUrl.isNotEmpty ? NetworkImage(imgUrl) : null,
                            child: imgUrl.isEmpty
                                ? Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )
                                : null,
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: Text(
                            last,
                            style: const TextStyle(fontSize: 12, color: Colors.black38),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                time,
                                style: const TextStyle(fontSize: 11, color: Colors.black38),
                              ),
                              if (unread > 0) ...[
                                const SizedBox(height: 4),
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: _blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$unread',
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
