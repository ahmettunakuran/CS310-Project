import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_drawer.dart';
import '../utils/theme_manager.dart';
import '../utils/app_colors.dart';
import '../utils/app_padding.dart';
import '../utils/text_styles.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/pie_chart_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ThemeManager _themeManager = ThemeManager();

  Stream<QuerySnapshot> _getUserOutOfStockProducts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('products')
        .where('amount', isEqualTo: 0)
        .limit(2)
        .snapshots();
  }

  Stream<QuerySnapshot> _getUserProducts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('products')
        .limit(2)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _themeManager.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider?>(context);
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text(
          "StockStable",
          style: AppTextStyles.appBarText,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,


            /*
            decoration: InputDecoration(
              filled: true,
              fillColor: _themeManager.isDarkMode ? Color(0xFF353535) : Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: _themeManager.isDarkMode ? Colors.grey[400] : Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: _themeManager.isDarkMode ? Colors.grey[400] : Colors.grey,
              ),
            ),
            ),
            */


      ),
      body: SingleChildScrollView(
        padding: AppPadding.all16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            productProvider == null
                ? const SizedBox(height: 200)
                : PieChartWidget(productsStream: productProvider.products),
            const SizedBox(height: 20),
            _buildSectionHeader(
              title: 'Out Of Stock',
              onViewAllPressed: () => Navigator.pushNamed(context, '/outOfStock'),
            ),
            _buildProductList(_getUserOutOfStockProducts()),
            const SizedBox(height: 20),
            _buildSectionHeader(
              title: 'Stock Information',
              onViewAllPressed: () => Navigator.pushNamed(context, '/stockInfo'),
            ),
            _buildProductList(_getUserProducts()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildPlaceholderChart() {
    return const SizedBox.shrink();
  }

  Widget _buildSectionHeader({required String title, required VoidCallback onViewAllPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.label.copyWith(color: _themeManager.primaryTextColor),
        ),
        TextButton(
          onPressed: onViewAllPressed,
          child: Text(
            'View all',
            style: AppTextStyles.viewAll.copyWith(
              color: _themeManager.isDarkMode ? Colors.lightBlue : Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList(Stream<QuerySnapshot> stream) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Error loading data');
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final products = snapshot.data!.docs;

        return Column(
          children: products.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final status = data['amount'] == 0 ? 'Out of stock' : 'In stock';
            return Card(
              margin: AppPadding.cardMargin,
              elevation: 2,
              color: _themeManager.cardColor,
              child: ListTile(
                title: Text(
                  data['name'],
                  style: TextStyle(color: _themeManager.primaryTextColor),
                ),
                subtitle: Text(
                  'Price: ₺${data['price']} • Amount: ${data['amount']} • Status: $status',
                  style: TextStyle(color: _themeManager.secondaryTextColor),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: _themeManager.backgroundColor,
      padding: AppPadding.vertical12.add(AppPadding.horizontal16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/addItem'),
              style: ElevatedButton.styleFrom(
                padding: AppPadding.vertical12,
                shape: const StadiumBorder(),
                backgroundColor: AppColors.primaryBlue,
              ),
              child: const Text('Add Item', style: AppTextStyles.smallButtonWhiteText),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/barcodeScanner');
              if (result != null && result is String) {
                debugPrint("Taranan QR Kod: $result");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Taranan Kod: $result')),
                );
              }
            },
            backgroundColor: AppColors.buttonYellow,
            child: const Icon(Icons.qr_code, color: Colors.black),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/delete'),
              style: ElevatedButton.styleFrom(
                padding: AppPadding.vertical12,
                shape: const StadiumBorder(),
                backgroundColor: AppColors.deleteRed,
              ),
              child: const Text('Delete Item', style: AppTextStyles.smallButtonWhiteText),
            ),
          ),
        ],
      ),
    );
  }
}
