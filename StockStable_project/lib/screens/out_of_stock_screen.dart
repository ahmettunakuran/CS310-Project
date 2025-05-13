import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import 'package:navigate_screens/utils/text_styles.dart';
import '../utils/app_padding.dart';
import '../utils/theme_manager.dart';

class OutOfStockScreen extends StatefulWidget {
  const OutOfStockScreen({super.key});

  @override
  State<OutOfStockScreen> createState() => _OutOfStockScreenState();
}

class _OutOfStockScreenState extends State<OutOfStockScreen> {
  final ThemeManager _themeManager = ThemeManager();

  Stream<QuerySnapshot> _getUserOutOfStockProducts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to view products');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('products')
        .where('amount', isEqualTo: 0)
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.isDarkMode
          ? _themeManager.backgroundColor
          : AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          "Out of Stock Items",
          style: AppTextStyles.appBarText,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getUserOutOfStockProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching data"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final outOfStock = snapshot.data!.docs;

          if (outOfStock.isEmpty) {
            return const Center(child: Text("No out of stock products."));
          }

          return ListView.builder(
            padding: AppPadding.all8,
            itemCount: outOfStock.length,
            itemBuilder: (context, index) {
              final data = outOfStock[index].data() as Map<String, dynamic>;

              return Card(
                margin: AppPadding.cardMargin,
                color: _themeManager.isDarkMode
                    ? _themeManager.cardColor
                    : Colors.white,
                child: ListTile(
                  title: Text(
                    data['name'] ?? 'Unknown',
                    style: TextStyle(color: _themeManager.primaryTextColor),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Number: ${data['id'] ?? 'N/A'}",
                        style:
                            TextStyle(color: _themeManager.secondaryTextColor),
                      ),
                      Text(
                        "Price: ₺${data['price']?.toStringAsFixed(2) ?? 'N/A'}",
                        style:
                            TextStyle(color: _themeManager.secondaryTextColor),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        color: _themeManager.isDarkMode
            ? _themeManager.backgroundColor
            : AppColors.backgroundWhite,
        padding: AppPadding.bottomButton,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/addItem");
          },
          style: ElevatedButton.styleFrom(
            padding: AppPadding.vertical16,
            shape: const StadiumBorder(),
            backgroundColor: AppColors.primaryBlue,
          ),
          child: const Text(
            "Add Item",
            style: AppTextStyles.smallButtonWhiteText,
          ),
        ),
      ),
    );
  }
}
