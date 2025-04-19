import 'package:flutter/material.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import '../utils/theme_manager.dart';
import '../utils/app_padding.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final ThemeManager _themeManager = ThemeManager();
  String selectedMonth = 'March';

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order History',
          style: TextStyle(
            color: Color(0xFF252533),
            fontSize: 25.0,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
      ),
      backgroundColor: _themeManager.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: AppPadding.all8,
              child: TextField(
                style: TextStyle(color: _themeManager.primaryTextColor),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: _themeManager.isDarkMode ? Colors.grey[400] : null,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: _themeManager.isDarkMode
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                  fillColor:
                      _themeManager.isDarkMode ? Color(0xFF353535) : null,
                  filled: _themeManager.isDarkMode,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _themeManager.isDarkMode
                          ? Colors.grey[700]!
                          : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 30),
              child: DropdownButton<String>(
                value: selectedMonth,
                dropdownColor:
                    _themeManager.isDarkMode ? Color(0xFF353535) : null,
                style: TextStyle(color: _themeManager.primaryTextColor),
                icon: Icon(Icons.arrow_drop_down,
                    color: _themeManager.primaryTextColor),
                items: months.map((String value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  Color cardColor;
                  if (_themeManager.isDarkMode) {
                    cardColor =
                        index % 2 == 0 ? Color(0xFF1F4F1F) : Color(0xFF4F1F1F);
                  } else {
                    cardColor =
                        index % 2 == 0 ? Colors.green[200]! : Colors.red[200]!;
                  }

                  return Card(
                    color: cardColor,
                    child: Padding(
                      padding: AppPadding.all16,
                      child: ListTile(
                        title: Text(
                          "Date: 12/03/2025\nProduct: product_name\nAmount: 5",
                          style: TextStyle(
                            color: _themeManager.primaryTextColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.image,
                          color: _themeManager.primaryTextColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
