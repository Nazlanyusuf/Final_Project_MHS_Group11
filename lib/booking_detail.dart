import 'package:flutter/material.dart';

class BookingFormPage extends StatefulWidget {

  final String packageName;
  final String price;

  const BookingFormPage({
    super.key,
    required this.packageName,
    required this.price,
  });

  @override
  State<BookingFormPage> createState() =>
      _BookingFormPageState();
}

class _BookingFormPageState
    extends State<BookingFormPage> {

  final TextEditingController eventName =
      TextEditingController();

  final TextEditingController dateController =
      TextEditingController();

  final TextEditingController guestController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  final TextEditingController notesController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),

      body: Stack(
        children: [

          /// BACKGROUND IMAGE
          SizedBox(
            height: 260,
            width: double.infinity,
            child: Image.network(
              "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=1200&auto=format&fit=crop",
              fit: BoxFit.cover,
            ),
          ),

          /// FORM CARD
          Positioned.fill(
            top: 70,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(24),
              ),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    /// STEP INDICATOR
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [

                        _stepItem(
                          number: "1",
                          title: "Package",
                          active: true,
                        ),

                        Expanded(
                          child: Divider(
                            color: Colors.blue.shade200,
                            thickness: 2,
                          ),
                        ),

                        _stepItem(
                          number: "2",
                          title: "Details",
                          active: true,
                        ),

                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 2,
                          ),
                        ),

                        _stepItem(
                          number: "3",
                          title: "Payment",
                        ),

                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 2,
                          ),
                        ),

                        _stepItem(
                          number: "4",
                          title: "Confirm",
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Choosed Package",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding:
                          const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFD8DCF7),
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [

                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [

                              Text(
                                widget.packageName,
                                style:
                                    const TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const Text(
                                "Dekorasi + MC + Foto + Katering",
                                style: TextStyle(
                                  color:
                                      Colors.black54,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            widget.price,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Event Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _inputField(
                      "Event name",
                      "Wedding of bowo and joko",
                      eventName,
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [

                        Expanded(
                          child: _inputField(
                            "Date",
                            "12 June 2026",
                            dateController,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _inputField(
                            "Estimate guest",
                            "300 peoples",
                            guestController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    _inputField(
                      "Event location",
                      "Ex: Binus Alam sutera...",
                      locationController,
                    ),

                    const SizedBox(height: 10),

                    _inputField(
                      "Additional notes",
                      "Ex: Special request to EO...",
                      notesController,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFD8DCF7),
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [

                          const Text(
                            "DP (30%)",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),

                          Text(
                            "Rp 7.500.000",
                            style: TextStyle(
                              color: Colors.blue
                                  .shade700,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 34),

                    Center(
                      child: GestureDetector(
                        onTap: () {

                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                            const SnackBar(
                              behavior:
                                  SnackBarBehavior
                                      .floating,
                              content: Text(
                                "Booking Success 🎉",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(
                              0xFF69B7F4,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(16),
                          ),
                          child: const Text(
                            "Book",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: active
                ? Colors.blue
                : Colors.white,
            border: Border.all(
              color: active
                  ? Colors.blue
                  : Colors.grey,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: active
                    ? Colors.white
                    : Colors.black,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _inputField(
    String title,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        TextField(
          controller: controller,
          maxLines: maxLines,

          decoration: InputDecoration(
            hintText: hint,

            filled: true,
            fillColor:
                const Color(0xFFBEE0FF),

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}