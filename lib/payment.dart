import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String packageName;
  final String eventName;
  final String eventDate;
  final int guestCount;
  final double packagePrice;
  final double dpAmount;

  const PaymentPage({
    super.key,
    this.packageName = 'Platinum',
    this.eventName = 'Elegant Wedding Organizer',
    this.eventDate = '12 June 2026',
    this.guestCount = 500,
    this.packagePrice = 25000000,
    this.dpAmount = 7500000,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = 'visa';

  final double _platformFee = 15000;
  final double _promoDiscount = 300000;
  final String _promoCode = 'WEDDING20';

  double get _total => widget.packagePrice + _platformFee - _promoDiscount;

  String _formatRupiah(double amount) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Step indicator
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event card
                  _buildEventCard(),
                  const SizedBox(height: 20),
                  // Payment method section
                  const Text(
                    'PAYMENT METHOD',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildPaymentOption(
                    id: 'visa',
                    logo: _visaLogo(),
                    title: 'Visa...4821',
                    subtitle: 'Expires 08/27',
                  ),
                  const SizedBox(height: 8),
                  _buildPaymentOption(
                    id: 'gopay',
                    logo: _gopayLogo(),
                    title: 'GoPay',
                    subtitle: 'Balance: Rp 842.000',
                  ),
                  const SizedBox(height: 8),
                  _buildPaymentOption(
                    id: 'ovo',
                    logo: _ovoLogo(),
                    title: 'OVO',
                    subtitle: 'Balance: Rp 250.000',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Checkout summary + Pay Now button
          _buildCheckoutPanel(),
        ],
      ),
    );
  }

  // ─── Step Indicator ───────────────────────────────────────────────────────

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          _stepCircle(1, 'Package', filled: true),
          _stepLine(filled: true),
          _stepCircle(2, 'Details', filled: true),
          _stepLine(filled: true),
          _stepCircle(3, 'Payment', filled: true),
          _stepLine(filled: false),
          _stepCircle(4, 'Confirm', filled: false, current: false),
        ],
      ),
    );
  }

  Widget _stepCircle(int number, String label,
      {required bool filled, bool current = false}) {
    final isActive = filled;
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF69B7F4) : Colors.transparent,
            border: Border.all(
              color: isActive ? const Color(0xFF69B7F4) : Colors.grey.shade400,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive ? const Color(0xFF69B7F4) : Colors.grey.shade500,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _stepLine({required bool filled}) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.only(bottom: 16),
        color: filled ? const Color(0xFF69B7F4) : Colors.grey.shade300,
      ),
    );
  }

  // ─── Event Card ───────────────────────────────────────────────────────────

  Widget _buildEventCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1519741497674-611481863552?w=200',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.eventName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 12, color: Color(0xFF69B7F4)),
                    const SizedBox(width: 4),
                    Text(
                      widget.eventDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF69B7F4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '1 Days',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Payment Option ───────────────────────────────────────────────────────

  Widget _buildPaymentOption({
    required String id,
    required Widget logo,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedPayment == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF69B7F4)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            logo,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: _selectedPayment,
              onChanged: (v) => setState(() => _selectedPayment = v!),
              activeColor: const Color(0xFF69B7F4),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Logo Widgets ─────────────────────────────────────────────────────────

  Widget _visaLogo() {
    return Container(
      width: 48,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F71),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: Text(
          'VISA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
            fontStyle: FontStyle.italic,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _gopayLogo() {
    return Container(
      width: 48,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFF00AED6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: Text(
          'Go\nPay',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 9,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _ovoLogo() {
    return Container(
      width: 48,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFF4C3494),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: Text(
          'OVO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  // ─── Checkout Panel ───────────────────────────────────────────────────────

  Widget _buildCheckoutPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 4),
            child: Text(
              'Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _checkoutRow(
                  '1 Days × ${_formatRupiah(widget.packagePrice)}',
                  _formatRupiah(widget.packagePrice),
                ),
                const SizedBox(height: 4),
                _checkoutRow('Platform fee', _formatRupiah(_platformFee)),
                const SizedBox(height: 4),
                _checkoutRow(
                  'Promo $_promoCode',
                  '-${_formatRupiah(_promoDiscount)}',
                  isPromo: true,
                ),
                const Divider(height: 20, thickness: 0.8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      _formatRupiah(_total),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onPayNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF69B7F4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'PAY NOW',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkoutRow(String label, String value, {bool isPromo = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isPromo ? Colors.red.shade400 : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: isPromo ? Colors.red.shade400 : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _onPayNow() {
    // Navigate to confirm page or show success dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Payment Confirmed'),
        content: Text(
          'Pembayaran ${_formatRupiah(_total)} berhasil diproses.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
