import 'package:flutter/material.dart';
import '../utils/theme_manager.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ThemeManager _themeManager = ThemeManager();

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
    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
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
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: const Text("FAQ"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: _themeManager.backgroundColor,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                fillColor: _themeManager.isDarkMode ? Colors.grey[800] : Colors.grey.shade200,
                filled: true,
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: _themeManager.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: _themeManager.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                color: _themeManager.primaryTextColor,
              ),
            ),
          ),

          // FAQ Section
          Expanded(
            child: _filteredFaqItems.isEmpty
                ? Center(
              child: Text(
                'No results found',
                style: TextStyle(color: _themeManager.primaryTextColor),
              ),
            )
                : ListView.builder(
              itemCount: _filteredFaqItems.length,
              itemBuilder: (context, index) {
                final item = _filteredFaqItems[index];
                final isEven = index % 2 == 0;

                return Container(
                  color: isEven ? _themeManager.faqOddColor : _themeManager.faqEvenColor,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      unselectedWidgetColor: _themeManager.primaryTextColor,
                      colorScheme: ColorScheme.light(
                        primary: _themeManager.primaryTextColor,
                      ),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        item['question']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _themeManager.primaryTextColor,
                        ),
                      ),
                      iconColor: _themeManager.primaryTextColor,
                      collapsedIconColor: _themeManager.primaryTextColor,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            item['answer']!,
                            style: TextStyle(
                              color: _themeManager.primaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
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
            color: _themeManager.isDarkMode ? Color(0xFF2A2A2A) : Colors.grey.shade200,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _themeManager.isDarkMode ? Color(0xFF353535) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'NUMBER: XXX-XXX-XX-XX',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _themeManager.primaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _themeManager.isDarkMode ? Color(0xFF353535) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'MAIL: 0@sabanciuniv.edu',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _themeManager.primaryTextColor,
                    ),
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