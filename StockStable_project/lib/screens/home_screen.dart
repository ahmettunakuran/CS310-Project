import 'package:flutter/material.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import '../widgets/custom_drawer.dart';
import '../utils/theme_manager.dart';
import '../utils/app_padding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeManager _themeManager = ThemeManager();

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
      backgroundColor: _themeManager.backgroundColor,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: TextField(
            style: TextStyle(
              fontSize: 14.0,
              color: _themeManager.primaryTextColor,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  _themeManager.isDarkMode ? Color(0xFF353535) : Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              hintText: 'Search...',
              hintStyle: TextStyle(
                color:
                    _themeManager.isDarkMode ? Colors.grey[400] : Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              prefixIcon: Icon(
                Icons.search,
                color:
                    _themeManager.isDarkMode ? Colors.grey[400] : Colors.grey,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppPadding.all16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart Placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.placeholderGrey,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Text(
                  'Pie Chart Placeholder',
                  style: TextStyle(
                      color: Color.fromARGB(255, 68, 61, 61), fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Out of Stock Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Out Of Stock',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _themeManager.primaryTextColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/outOfStock');
                  },
                  child: Text(
                    'View all',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: _themeManager.isDarkMode
                          ? Colors.lightBlue
                          : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              margin: AppPadding.cardMargin,
              elevation: 2,
              color: _themeManager.cardColor,
              child: ListTile(
                title: Text(
                  'Product Name',
                  style: TextStyle(color: _themeManager.primaryTextColor),
                ),
                subtitle: Text(
                  'ProductNo • Price',
                  style: TextStyle(color: _themeManager.secondaryTextColor),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stock Information Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stock Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _themeManager.primaryTextColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/stockInfo');
                  },
                  child: Text(
                    'View all',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: _themeManager.isDarkMode
                          ? Colors.lightBlue
                          : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              margin: AppPadding.cardMargin,
              elevation: 2,
              color: _themeManager.cardColor,
              child: ListTile(
                title: Text(
                  'Product Name',
                  style: TextStyle(color: _themeManager.primaryTextColor),
                ),
                subtitle: Text(
                  'ProductNo • Stock Status',
                  style: TextStyle(color: _themeManager.secondaryTextColor),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: _themeManager.backgroundColor,
        padding: AppPadding.vertical12.add(AppPadding.horizontal16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Add Item button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addItem');
                },
                style: ElevatedButton.styleFrom(
                    padding: AppPadding.vertical12,
                    shape: const StadiumBorder(),
                    backgroundColor: AppColors.primaryBlue),
                child: const Text('Add Item',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 8),
            // Barcode Scanner button
            FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/barcodeScanner');
              },
              backgroundColor: AppColors.buttonYellow,
              child: const Icon(Icons.qr_code, color: Colors.black),
            ),
            const SizedBox(width: 8),
            // Delete Item button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/deleteProduct');
                },
                style: ElevatedButton.styleFrom(
                  padding: AppPadding.vertical12,
                  shape: const StadiumBorder(),
                  backgroundColor: AppColors.deleteRed,
                ),
                child: const Text(
                  'Delete Item',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
