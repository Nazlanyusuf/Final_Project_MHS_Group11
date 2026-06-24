import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project_mhs/services/notification_service.dart';

class EventRemindersPage extends StatefulWidget {
  const EventRemindersPage({super.key});

  @override
  State<EventRemindersPage> createState() => _EventRemindersPageState();
}

class _EventRemindersPageState extends State<EventRemindersPage> {
  static const _blue = Color(0xFF6DB6E3);
  static const _prefsKey = 'event_reminders';

  List<Map<String, dynamic>> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (mounted) {
      setState(() {
        if (raw != null) {
          _reminders = List<Map<String, dynamic>>.from(
              jsonDecode(raw) as List);
        }
        _isLoading = false;
      });
      // Reschedule upcoming notifications in case app restarted
      for (final r in _reminders) {
        _scheduleNotification(r);
      }
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_reminders));
  }

  void _add(Map<String, dynamic> reminder) {
    setState(() => _reminders.add(reminder));
    _save();
    _scheduleNotification(reminder);
  }

  void _delete(String id) {
    NotificationService.cancelReminder(id);
    setState(() => _reminders.removeWhere((r) => r['id'] == id));
    _save();
  }

  Future<void> _scheduleNotification(Map<String, dynamic> r) async {
    final dateStr = r['date'] as String? ?? '';
    final timeStr = r['time'] as String? ?? '00:00';
    final title = r['title'] as String? ?? 'Event Reminder';
    final id = r['id'] as String? ?? '';
    final note = r['note'] as String? ?? '';

    if (dateStr.isEmpty || id.isEmpty) return;

    final dateParts = dateStr.split('-');
    if (dateParts.length != 3) return;

    final timeParts = timeStr.split(':');
    final hour = int.tryParse(timeParts.isNotEmpty ? timeParts[0] : '0') ?? 0;
    final minute = int.tryParse(timeParts.length > 1 ? timeParts[1] : '0') ?? 0;

    final scheduledTime = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      hour,
      minute,
    );

    await NotificationService.scheduleReminder(
      id: id,
      title: title,
      scheduledTime: scheduledTime,
      body: note.isNotEmpty ? note : null,
    );
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddReminderSheet(onAdd: _add),
    );
  }

  List<Map<String, dynamic>> get _sorted {
    final list = List<Map<String, dynamic>>.from(_reminders);
    list.sort((a, b) {
      final da = DateTime.tryParse(a['date'] ?? '') ?? DateTime(2100);
      final db = DateTime.tryParse(b['date'] ?? '') ?? DateTime(2100);
      return da.compareTo(db);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final sorted = _sorted;

    final upcoming = sorted.where((r) {
      final d = DateTime.tryParse(r['date'] ?? '');
      return d != null && !d.isBefore(todayDate);
    }).toList();

    final past = sorted.where((r) {
      final d = DateTime.tryParse(r['date'] ?? '');
      return d == null || d.isBefore(todayDate);
    }).toList();

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
          'Event Reminders',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: _blue, size: 26),
            onPressed: _showAddSheet,
          ),
        ],
      ),
      floatingActionButton: _reminders.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _showAddSheet,
              backgroundColor: _blue,
              foregroundColor: Colors.white,
              elevation: 2,
              icon: const Icon(Icons.add),
              label: const Text('Tambah',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _blue))
          : _reminders.isEmpty
              ? _buildEmpty()
              : ListView(
                  padding:
                      const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    if (upcoming.isNotEmpty) ...[
                      _sectionLabel('Upcoming'),
                      const SizedBox(height: 10),
                      ...upcoming.map(
                          (r) => _buildCard(r, isPast: false)),
                    ],
                    if (past.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      _sectionLabel('Past'),
                      const SizedBox(height: 10),
                      ...past
                          .map((r) => _buildCard(r, isPast: true)),
                    ],
                  ],
                ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_outlined,
              size: 88, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Belum ada reminder',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black45),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tambahkan reminder untuk eventmu',
            style:
                TextStyle(fontSize: 13, color: Colors.black38),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: _showAddSheet,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Reminder'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black45,
          letterSpacing: 0.5),
    );
  }

  Widget _buildCard(Map<String, dynamic> r, {required bool isPast}) {
    final date = DateTime.tryParse(r['date'] ?? '');
    final today = DateTime.now();
    final isToday = date != null &&
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    final isTomorrow = date != null &&
        date.difference(DateTime(today.year, today.month, today.day))
                .inDays ==
            1;

    return Dismissible(
      key: ValueKey(r['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline,
            color: Colors.white, size: 26),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: const Text('Hapus Reminder?'),
                content:
                    Text('Hapus reminder "${r['title']}"?'),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context, true),
                    child: const Text('Hapus',
                        style:
                            TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => _delete(r['id'] as String),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isPast
              ? Colors.white.withOpacity(0.75)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isToday
              ? Border.all(color: _blue, width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(isPast ? 0.03 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Date block ────────────────────────────
            Container(
              width: 52,
              height: 58,
              decoration: BoxDecoration(
                color: isPast
                    ? Colors.grey.shade100
                    : isToday
                        ? _blue
                        : const Color(0xFFE8F4FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date != null
                        ? date.day.toString()
                        : '--',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isPast
                          ? Colors.grey
                          : isToday
                              ? Colors.white
                              : _blue,
                    ),
                  ),
                  Text(
                    date != null
                        ? _monthShort(date.month)
                        : '--',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isPast
                          ? Colors.grey
                          : isToday
                              ? Colors.white70
                              : const Color(0xFF3A8FC4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // ── Content ───────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          r['title'] as String? ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isPast
                                ? Colors.black38
                                : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isToday)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _blue.withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          child: const Text('Today',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: _blue,
                                  fontWeight:
                                      FontWeight.w700)),
                        )
                      else if (isTomorrow)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange
                                .withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          child: const Text('Tomorrow',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange,
                                  fontWeight:
                                      FontWeight.w700)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 13,
                          color: isPast
                              ? Colors.grey.shade400
                              : Colors.black38),
                      const SizedBox(width: 4),
                      Text(
                        r['time'] as String? ?? '--:--',
                        style: TextStyle(
                          fontSize: 12,
                          color: isPast
                              ? Colors.grey.shade400
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  if ((r['note'] as String?)?.isNotEmpty ==
                      true) ...[
                    const SizedBox(height: 4),
                    Text(
                      r['note'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isPast
                            ? Colors.grey.shade400
                            : Colors.black45,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  String _monthShort(int m) {
    const months = [
      '',
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[m];
  }
}

// ── Add Reminder Bottom Sheet ──────────────────────────────────────────────────

class _AddReminderSheet extends StatefulWidget {
  final void Function(Map<String, dynamic>) onAdd;
  const _AddReminderSheet({required this.onAdd});

  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  static const _blue = Color(0xFF6DB6E3);

  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              const ColorScheme.light(primary: _blue),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              const ColorScheme.light(primary: _blue),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _submit() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Judul reminder harus diisi')),
      );
      return;
    }
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Pilih tanggal terlebih dahulu')),
      );
      return;
    }

    widget.onAdd({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleCtrl.text.trim(),
      'date': _date!.toIso8601String().split('T')[0],
      'time': _time != null
          ? '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}'
          : '00:00',
      'note': _noteCtrl.text.trim(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text('Tambah Reminder',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          // Title
          TextField(
            controller: _titleCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Judul Event *',
              hintText: 'Contoh: Wedding Organizer Meeting',
              prefixIcon:
                  const Icon(Icons.event_note_outlined, size: 20),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: _blue, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),
          // Date + Time
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: _date != null
                              ? _blue
                              : Colors.black26),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 17,
                            color: _date != null
                                ? _blue
                                : Colors.black45),
                        const SizedBox(width: 8),
                        Text(
                          _date != null
                              ? '${_date!.day}/${_date!.month}/${_date!.year}'
                              : 'Tanggal',
                          style: TextStyle(
                            color: _date != null
                                ? Colors.black87
                                : Colors.black38,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: _pickTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: _time != null
                              ? _blue
                              : Colors.black26),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 17,
                            color: _time != null
                                ? _blue
                                : Colors.black45),
                        const SizedBox(width: 8),
                        Text(
                          _time != null
                              ? '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}'
                              : 'Waktu',
                          style: TextStyle(
                            color: _time != null
                                ? Colors.black87
                                : Colors.black38,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Note
          TextField(
            controller: _noteCtrl,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Catatan (opsional)',
              hintText: 'Tambahkan catatan...',
              prefixIcon:
                  const Icon(Icons.notes_outlined, size: 20),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: _blue, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Simpan Reminder',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
