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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 20,
      ),

      child: Container(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height *
                  0.85,
        ),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(28),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              /// CLOSE BUTTON
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ),

              /// STEP INDICATOR
              Row(
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
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

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

                    Expanded(
                      child: Column(
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
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
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
                    ),

                    Text(
                      widget.price,
                      style:
                          const TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Event Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _inputField(
                "Event Name",
                "Wedding of Bowo & Joko",
                eventName,
              ),

              const SizedBox(height: 12),

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
                      "Guests",
                      "300 People",
                      guestController,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _inputField(
                "Location",
                "Ex: Binus Alam Sutera",
                locationController,
              ),

              const SizedBox(height: 12),

              _inputField(
                "Additional Notes",
                "Special request...",
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
                        color:
                            Colors.blue.shade700,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {

                    Navigator.pop(context);

                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Booking Success 🎉",
                        ),
                      ),
                    );
                  },

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF69B7F4,
                    ),

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 16,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),

                  child: const Text(
                    "Book",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
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

            color: active
                ? Colors.blue
                : Colors.white,

            border: Border.all(
              color: active
                  ? Colors.blue
                  : Colors.grey,
            ),
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
            fontWeight:
                FontWeight.w600,
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

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                10,
              ),
              borderSide:
                  BorderSide.none,
            ),

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}