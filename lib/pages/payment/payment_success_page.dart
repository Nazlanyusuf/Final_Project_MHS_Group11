import 'dart:math';
import 'package:flutter/material.dart';
import '../../main_navigation.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String packageName;
  final String eventName;
  final double total;

  const PaymentSuccessPage({
    super.key,
    required this.packageName,
    required this.eventName,
    required this.total,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with TickerProviderStateMixin {
  // Circle scales in with elastic bounce
  late AnimationController _circleCtrl;
  late Animation<double> _circleScale;

  // Burst particles spread outward then fade
  late AnimationController _burstCtrl;

  // Checkmark pops in after circle
  late AnimationController _checkCtrl;
  late Animation<double> _checkScale;

  // Content (text + card + button) fades + slides up
  late AnimationController _contentCtrl;
  late Animation<double> _contentOpacity;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    _circleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _circleScale = CurvedAnimation(
      parent: _circleCtrl,
      curve: Curves.elasticOut,
    );

    _burstCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _checkScale = CurvedAnimation(
      parent: _checkCtrl,
      curve: Curves.bounceOut,
    );

    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _contentOpacity =
        Tween<double>(begin: 0, end: 1).animate(_contentCtrl);
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut));

    // Sequence: circle + burst → checkmark → content
    _circleCtrl.forward();
    _burstCtrl.forward();
    Future.delayed(const Duration(milliseconds: 420), () {
      if (mounted) _checkCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) _contentCtrl.forward();
    });
  }

  @override
  void dispose() {
    _circleCtrl.dispose();
    _burstCtrl.dispose();
    _checkCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  String _fmt(double v) {
    return 'Rp ${v.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 64),

                // ── Animated circle area ──────────────────────────
                Center(
                  child: SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Burst particles
                        AnimatedBuilder(
                          animation: _burstCtrl,
                          builder: (_, __) => CustomPaint(
                            size: const Size(260, 260),
                            painter: _BurstPainter(
                                progress: _burstCtrl.value),
                          ),
                        ),

                        // Outer glow ring
                        ScaleTransition(
                          scale: _circleScale,
                          child: Container(
                            width: 168,
                            height: 168,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6DB6E3)
                                  .withOpacity(0.16),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Inner solid circle
                        ScaleTransition(
                          scale: _circleScale,
                          child: Container(
                            width: 116,
                            height: 116,
                            decoration: const BoxDecoration(
                              color: Color(0xFF6DB6E3),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x446DB6E3),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: ScaleTransition(
                              scale: _checkScale,
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 62,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Animated content ─────────────────────────────
                FadeTransition(
                  opacity: _contentOpacity,
                  child: SlideTransition(
                    position: _contentSlide,
                    child: Column(
                      children: [
                        const Text(
                          'Payment Confirmed!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your booking has been successfully confirmed',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, color: Colors.black45),
                        ),

                        const SizedBox(height: 28),

                        // Detail card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F7FF),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFF6DB6E3)
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              _row('Package', widget.packageName),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10),
                                child: Divider(
                                    height: 1, color: Colors.black12),
                              ),
                              _row('Event', widget.eventName),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10),
                                child: Divider(
                                    height: 1, color: Colors.black12),
                              ),
                              _row(
                                'Total Paid',
                                _fmt(widget.total),
                                valueStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF3A8FC4),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MainNavigation()),
                              (_) => false,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6DB6E3),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Back to Home',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: Colors.black45)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: valueStyle ??
                const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

// ── Burst Particle Painter ────────────────────────────────────────────────────

class _BurstPainter extends CustomPainter {
  final double progress;

  const _BurstPainter({required this.progress});

  static const _colors = [
    Color(0xFF6DB6E3),
    Color(0xFFFF9F43),
    Color(0xFF4CAF50),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFFEB3B),
    Color(0xFFFF5722),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final center = Offset(size.width / 2, size.height / 2);
    const maxR = 118.0;
    final r = maxR * Curves.easeOut.transform(progress);
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final dotSize = 7.0 * (1 - progress * 0.45);

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45.0) * (pi / 180.0);
      canvas.drawCircle(
        Offset(center.dx + r * cos(angle), center.dy + r * sin(angle)),
        dotSize,
        Paint()
          ..color = _colors[i].withOpacity(opacity)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.progress != progress;
}
