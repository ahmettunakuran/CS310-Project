import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
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

  String selectedMonth = DateTime.now().month.toString();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  Color _getCardColor(Order order) {
    switch (order.operationType) {
      case 'add':
        return Colors.blue.shade200;
      case 'delete':
        return Colors.grey.shade400; // Deleted items shown in grey
      case 'stock_increase':
        return Colors.green.shade200;
      case 'stock_decrease':
        return Colors.red.shade200;
      default:
        return Colors.white;
    }
  }

  String _getOrderDescription(Order order) {
    final dateStr = "${order.date.day}/${order.date.month}/${order.date.year}";

    switch (order.operationType) {
      case 'add':
        return "Date: $dateStr\nProduct: ${order.productName}\nInitial Stock: ${order.amount}";
      case 'delete':
        return "Date: $dateStr\nProduct: ${order.productName}\nDeleted";
      case 'stock_increase':
        return "Date: $dateStr\nProduct: ${order.productName}\nStock Increased by: ${order.stockChange}\nTotal Stock: ${order.amount}";
      case 'stock_decrease':
        return "Date: $dateStr\nProduct: ${order.productName}\nStock Decreased by: ${order.stockChange?.abs()}\nTotal Stock: ${order.amount}";
      default:
        return "Date: $dateStr\nProduct: ${order.productName}\nAmount: ${order.amount}";
    }
  }

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

          final orders = (snap.data ?? [])
              .where((o) =>
          o.date.month.toString() == selectedMonth &&
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
                  itemBuilder: (_, i) => _orderCard(orders[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _searchField() => Padding(
    padding: AppPadding.all8,
    child: TextField(
      onChanged: (v) => setState(() => searchQuery = v),
      style: TextStyle(color: _themeManager.primaryTextColor),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: _themeManager.secondaryTextColor),
        hintText: 'Search by product name',
        hintStyle: TextStyle(color: _themeManager.secondaryTextColor),
        filled: _themeManager.isDarkMode,
        fillColor: _themeManager.isDarkMode ? const Color(0xFF353535) : null,
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
      items: List.generate(12, (i) => (i + 1).toString())
          .map((m) => DropdownMenuItem(
        value: m,
        child: Text(months[int.parse(m) - 1]),
      ))
          .toList(),
      onChanged: (v) => setState(() => selectedMonth = v!),
    ),
  );

  Widget _orderCard(Order order) {
    final cardColor = _getCardColor(order);
    final description = _getOrderDescription(order);

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: AppPadding.all16,
        child: ListTile(
          title: Text(
            description,
            style: TextStyle(
              color: _themeManager.primaryTextColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
