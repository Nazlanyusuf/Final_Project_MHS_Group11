import 'package:flutter/material.dart';
import 'booking/booking.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _ctrl = TextEditingController();
  String _query = '';
  final List<String> _activeFilters = [];

  static const _filters = [
    'Intimate Wedding',
    'Birthday Party',
    'Graduation Celebration',
    'Corporate Event',
    'Concert',
  ];

  static const List<Map<String, dynamic>> _venues = [
    {
      "title": "Le Blanc Wedding",
      "rating": "4.9",
      "review": "97",
      "location": "BSD",
      "price": "Rp 15.000.000",
      "image":
          "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=400&auto=format&fit=crop",
    },
    {
      "title": "Amanjiwo Hotel",
      "rating": "4.4",
      "review": "125",
      "location": "JAWA TENGAH",
      "price": "Rp 15.000.000",
      "image":
          "https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400&auto=format&fit=crop",
    },
    {
      "title": "Party Planner Birthday Organizer",
      "rating": "4.4",
      "review": "125",
      "location": "JabaDeTaBek",
      "price": "Rp 5.000.000",
      "image":
          "https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?q=80&w=400&auto=format&fit=crop",
    },
    {
      "title": "Elegant Wedding Organizer",
      "rating": "4.8",
      "review": "97",
      "location": "BSD",
      "price": "Rp 25.000.000",
      "image":
          "https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=400&auto=format&fit=crop",
    },
    {
      "title": "Groovy Event Organizer",
      "rating": "4.6",
      "review": "80",
      "location": "ICE BSD",
      "price": "Rp 10.000.000",
      "image":
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=400&auto=format&fit=crop",
    },
  ];

  List<Map<String, dynamic>> get _results {
    if (_query.isEmpty) return _venues;
    final q = _query.toLowerCase();
    return _venues.where((v) {
      return (v["title"] as String).toLowerCase().contains(q) ||
          (v["location"] as String).toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

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
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'Venue or Event Organizer',
            hintStyle:
                const TextStyle(fontSize: 14, color: Colors.black38),
            filled: true,
            fillColor: const Color(0xFFF0F0F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 18, vertical: 10),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close,
                        size: 18, color: Colors.black38),
                    onPressed: () {
                      _ctrl.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              itemBuilder: (context, i) {
                final f = _filters[i];
                final sel = _activeFilters.contains(f);
                return GestureDetector(
                  onTap: () => setState(() {
                    sel
                        ? _activeFilters.remove(f)
                        : _activeFilters.add(f);
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel
                          ? const Color(0xFF6DB6E3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: sel
                              ? const Color(0xFF6DB6E3)
                              : Colors.black12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          f,
                          style: TextStyle(
                            fontSize: 12,
                            color: sel
                                ? Colors.white
                                : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (sel) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.close,
                              size: 12, color: Colors.white),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Results
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No results for "$_query"',
                            style: TextStyle(
                                color: Colors.grey.shade400)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    itemCount: _results.length,
                    itemBuilder: (context, i) =>
                        _buildCard(context, _results[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> v) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BookingDetailPage()),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: Image.network(
                v["image"],
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v["title"],
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber, size: 15),
                        const SizedBox(width: 3),
                        Text(v["rating"],
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 8),
                        const Icon(Icons.chat_bubble_outline,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text('${v["review"]} Review',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 13, color: Colors.black38),
                        const SizedBox(width: 3),
                        Text(v["location"],
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Start from',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey)),
                          Text(v["price"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
