import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import 'package:navigate_screens/utils/text_styles.dart';
import '../utils/theme_manager.dart';
import '../utils/app_padding.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final ThemeManager _themeManager = ThemeManager();
  final List<String> months = const [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  String selectedMonth = 'March';
  String searchQuery   = '';

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  /* ─────────────────────  UI  ───────────────────── */

  @override
  Widget build(BuildContext context) {
    final OrderProvider? prov = context.watch<OrderProvider?>();

    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: const Text('Order History', style: AppTextStyles.appBarText),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: prov == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Order>>(
        stream: prov.orders,
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          /* filtre */
          final orders = (snap.data ?? [])
              .where((o) =>
          months[o.date.month - 1] == selectedMonth &&
              o.productName
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();

          return Column(
            children: [
              _searchField(),
              _monthDropdown(),
              Expanded(
                child: orders.isEmpty
                    ? const Center(child: Text('No orders found'))
                    : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (_, i) =>
                      _orderCard(orders[i], i),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /* ─────────────────────  Alt Widget’lar  ───────────────────── */

  Widget _searchField() => Padding(
    padding: AppPadding.all8,
    child: TextField(
      onChanged: (v) => setState(() => searchQuery = v),
      style: TextStyle(color: _themeManager.primaryTextColor),
      decoration: InputDecoration(
        prefixIcon:
        Icon(Icons.search, color: _themeManager.secondaryTextColor),
        hintText: 'Search',
        hintStyle: TextStyle(color: _themeManager.secondaryTextColor),
        filled: _themeManager.isDarkMode,
        fillColor:
        _themeManager.isDarkMode ? const Color(0xFF353535) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  Widget _monthDropdown() => Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 30),
    child: DropdownButton<String>(
      value: selectedMonth,
      dropdownColor:
      _themeManager.isDarkMode ? const Color(0xFF353535) : null,
      style: TextStyle(color: _themeManager.primaryTextColor),
      icon: Icon(Icons.arrow_drop_down,
          color: _themeManager.primaryTextColor),
      items: months
          .map((m) => DropdownMenuItem(value: m, child: Text(m)))
          .toList(),
      onChanged: (v) => setState(() => selectedMonth = v!),
    ),
  );

  Widget _orderCard(Order o, int index) {
    final bool even = index.isEven;
    final cardColor = _themeManager.isDarkMode
        ? (even ? const Color(0xFF1F4F1F) : const Color(0xFF4F1F1F))
        : (even ? Colors.green[200]! : Colors.red[200]!);

    return Card(
      color: cardColor,
      child: Padding(
        padding: AppPadding.all16,
        child: ListTile(
          title: Text(
            "Date: ${o.date.day}/${o.date.month}/${o.date.year}\n"
                "Product: ${o.productName}\n"
                "Amount: ${o.amount}",
            style: TextStyle(color: _themeManager.primaryTextColor),
          ),
          trailing:
          Icon(Icons.image, color: _themeManager.primaryTextColor),
        ),
      ),
    );
  }
}
