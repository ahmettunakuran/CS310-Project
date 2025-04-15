import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _faqItems = [
    {
      'question': 'How to add a new product?',
      'answer': 'Go to Home screen and tap on "Add Item" button. Fill in the required details and tap Save.',
    },
    {
      'question': 'How to delete a product?',
      'answer': 'Go to Home screen and tap on "Delete Item", then select the product you want to delete.',
    },
    {
      'question': 'How to scan a product barcode?',
      'answer': 'Tap on the barcode scanner button in the middle of the bottom navigation bar and point your camera at the barcode.',
    },
    {
      'question': 'How to view out of stock items?',
      'answer': 'Go to Home screen and tap on "View all" next to the "Out Of Stock" section.',
    },
    {
      'question': 'How to check inventory?',
      'answer': 'Open the drawer menu from the Home screen and tap on "Inventory".',
    },
    {
      'question': 'How to change app settings?',
      'answer': 'Open the drawer menu from the Home screen and tap on "Settings".',
    },
  ];

  List<Map<String, String>> _filteredFaqItems = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqItems = List.from(_faqItems);
    _searchController.addListener(_filterFaqItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFaqItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredFaqItems = List.from(_faqItems);
      } else {
        _filteredFaqItems = _faqItems
            .where((item) =>
        item['question']!.toLowerCase().contains(query) ||
            item['answer']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // FAQ Section
          Expanded(
            child: _filteredFaqItems.isEmpty
                ? const Center(child: Text('No results found'))
                : ListView.builder(
              itemCount: _filteredFaqItems.length,
              itemBuilder: (context, index) {
                final item = _filteredFaqItems[index];
                final isEven = index % 2 == 0;

                return Container(
                  color: isEven ? Colors.yellow.shade100 : Colors.grey.shade200,
                  child: ExpansionTile(
                    title: Text(
                      item['question']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(item['answer']!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Contact Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            child: const Text(
              'CONTACT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Phone and Email
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade200,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'NUMBER: XXX-XXX-XX-XX',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'MAIL: 0@sabanciuniv.edu',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}