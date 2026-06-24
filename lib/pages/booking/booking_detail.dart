import 'package:final_project_mhs/pages/payment/payment.dart';
import 'package:final_project_mhs/services/booking_service.dart';
import 'package:flutter/material.dart';

class BookingFormPage extends StatefulWidget {
  final String packageName;
  final String price;
  final int venueId;

  const BookingFormPage({
    super.key,
    required this.packageName,
    required this.price,
    this.venueId = 1,
  });

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final TextEditingController eventName          = TextEditingController();
  final TextEditingController dateController     = TextEditingController();
  final TextEditingController guestController    = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController    = TextEditingController();

  bool _guestAlertShown = false;
  bool _isSubmitting = false;

  void _onGuestChanged(String value) {
    if (_guestAlertShown) return;
    if (value.isEmpty) return;
    if (RegExp(r'[^0-9]').hasMatch(value)) {
      // Remove non-digit characters silently
      final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
      guestController.value = TextEditingValue(
        text: cleaned,
        selection: TextSelection.collapsed(offset: cleaned.length),
      );
      // Show alert once
      _guestAlertShown = true;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.numbers_outlined, color: Color(0xFF6DB6E3), size: 24),
              SizedBox(width: 8),
              Text('Hanya Angka', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: const Text(
            'Jumlah tamu hanya boleh diisi dengan angka.\nContoh: 150',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF69B7F4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      ).then((_) => _guestAlertShown = false);
    }
  }

  double _parsePrice(String priceStr) {
    final cleaned = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleaned) ?? 25000000;
  }

  String get _dpFormatted {
    final dp = _parsePrice(widget.price) * 0.3;
    final formatted = dp.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF69B7F4),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dateController.text =
          '${picked.day} ${_monthName(picked.month)} ${picked.year}';
    }
  }

  String _monthName(int m) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[m];
  }

  void _showRequiredAlert(String fieldName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
            SizedBox(width: 8),
            Text('Field Wajib Diisi', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Text(
          '$fieldName harus diisi sebelum melanjutkan.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF69B7F4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _toApiDate(String displayDate) {
    const months = {
      'January': '01', 'February': '02', 'March': '03', 'April': '04',
      'May': '05', 'June': '06', 'July': '07', 'August': '08',
      'September': '09', 'October': '10', 'November': '11', 'December': '12',
    };
    final parts = displayDate.split(' ');
    if (parts.length < 3) return displayDate;
    final day = parts[0].padLeft(2, '0');
    final month = months[parts[1]] ?? '01';
    final year = parts[2];
    return '$year-$month-$day';
  }

  Future<void> _submit() async {
    if (eventName.text.trim().isEmpty) {
      _showRequiredAlert('Event Name');
      return;
    }
    if (dateController.text.trim().isEmpty) {
      _showRequiredAlert('Date');
      return;
    }
    if (guestController.text.trim().isEmpty) {
      _showRequiredAlert('Jumlah Tamu (Guests)');
      return;
    }
    if (locationController.text.trim().isEmpty) {
      _showRequiredAlert('Location');
      return;
    }

    final guestCount = int.tryParse(
          guestController.text.trim().replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        1;

    setState(() => _isSubmitting = true);

    final result = await BookingService.createBooking(
      venueId: widget.venueId,
      eventDate: _toApiDate(dateController.text.trim()),
      eventName: eventName.text.trim(),
      guestCount: guestCount,
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result['success'] != true) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text('Booking Gagal', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Text(result['message'] ?? 'Terjadi kesalahan'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF69B7F4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final bookingId = (result['data'] as Map<String, dynamic>?)?['id'] as int?;

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          packageName: widget.packageName,
          eventName: eventName.text.trim(),
          eventDate: dateController.text.trim(),
          guestCount: guestCount,
          packagePrice: _parsePrice(widget.price),
          dpAmount: _parsePrice(widget.price) * 0.3,
          bookingId: bookingId,
        ),
      ),
    );
  }

  @override
  void dispose() {
    eventName.dispose();
    dateController.dispose();
    guestController.dispose();
    locationController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ),

              // Step indicator
              Row(
                children: [
                  _stepItem(number: "1", title: "Package", active: true),
                  Expanded(child: Divider(color: Colors.blue.shade200, thickness: 2)),
                  _stepItem(number: "2", title: "Details", active: true),
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 2)),
                  _stepItem(number: "3", title: "Payment"),
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 2)),
                  _stepItem(number: "4", title: "Confirm"),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                "Chosen Package",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8DCF7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.packageName,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Dekorasi + MC + Foto + Katering",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.price,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Event Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              _inputField(
                "Event Name *",
                "e.g. Wedding of Bowo & Joko",
                eventName,
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _dateField(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _inputField(
                      "Guests *",
                      "e.g. 300",
                      guestController,
                      keyboardType: TextInputType.text,
                      onChanged: _onGuestChanged,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _inputField(
                "Location *",
                "e.g. Binus Alam Sutera",
                locationController,
              ),

              const SizedBox(height: 12),

              _inputField(
                "Additional Notes",
                "Special request... (opsional)",
                notesController,
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              // DP row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8DCF7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "DP (30%)",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _dpFormatted,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF69B7F4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                    "Book",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date *",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _selectDate,
          child: AbsorbPointer(
            child: TextField(
              controller: dateController,
              decoration: InputDecoration(
                hintText: "Pick a date",
                suffixIcon: const Icon(Icons.calendar_today, size: 18,
                    color: Colors.black45),
                filled: true,
                fillColor: const Color(0xFFBEE0FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepItem({
    required String number,
    required String title,
    bool active = false,
  }) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Colors.blue : Colors.white,
            border: Border.all(
              color: active ? Colors.blue : Colors.grey,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: active ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _inputField(
    String title,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFBEE0FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}
