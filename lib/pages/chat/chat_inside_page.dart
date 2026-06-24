import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project_mhs/services/chat_service.dart';

class ChatInsidePage extends StatefulWidget {
  final String venueName;
  const ChatInsidePage({super.key, required this.venueName});

  @override
  State<ChatInsidePage> createState() => _ChatInsidePageState();
}

class _ChatInsidePageState extends State<ChatInsidePage> {
  static const _blue = Color(0xFF6DB6E3);

  final TextEditingController _controller = TextEditingController();
  final ScrollController      _scrollCtrl = ScrollController();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;

  String get _prefsKey =>
      'chat_msgs_${widget.venueName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase()}';

  static const List<Map<String, dynamic>> _defaultMessages = [
    {'text': 'Hello! Thank you for your interest. How can we help you?', 'isMe': false, 'time': '10:00'},
    {'text': "Hi! I'd like to discuss the package details.", 'isMe': true, 'time': '10:02'},
    {'text': 'Of course! We offer Platinum and Gold packages. Which one are you interested in?', 'isMe': false, 'time': '10:03'},
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (mounted) {
      setState(() {
        _messages = raw != null
            ? List<Map<String, dynamic>>.from(jsonDecode(raw) as List)
            : List<Map<String, dynamic>>.from(_defaultMessages);
        _isLoading = false;
      });
    }
    Future.delayed(const Duration(milliseconds: 150), _scrollToBottom);
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_messages));
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _nowTime() {
    final t = TimeOfDay.now();
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isMe': true, 'time': _nowTime()});
    });
    _controller.clear();
    _saveMessages();
    ChatService.updateLastMessage(widget.venueName, text);
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _blue,
              child: Text(
                widget.venueName.isNotEmpty ? widget.venueName[0].toUpperCase() : '?',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.venueName,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(fontSize: 11, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _blue))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _buildBubble(_messages[i]),
                  ),
                ),
                _buildInputBar(),
              ],
            ),
    );
  }

  Widget _buildBubble(Map<String, dynamic> msg) {
    final isMe = msg['isMe'] as bool?   ?? false;
    final text = msg['text'] as String? ?? '';
    final time = msg['time'] as String? ?? '';

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
      bottomRight: isMe ? Radius.zero : const Radius.circular(16),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          color: isMe ? _blue : Colors.white,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 13,
                    color: isMe ? Colors.white : Colors.black87,
                    height: 1.4),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white70 : Colors.black38),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
                filled: true,
                fillColor: const Color(0xFFF0F0F0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 10),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
