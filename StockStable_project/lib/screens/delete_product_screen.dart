import 'package:flutter/material.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import 'package:navigate_screens/utils/text_styles.dart';
import '../utils/app_padding.dart';
import '../utils/theme_manager.dart';

class DeleteProductScreen extends StatefulWidget {
  @override
  State<DeleteProductScreen> createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  final TextEditingController deleteAmountController = TextEditingController();
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
      appBar: AppBar(
        title: Text(
          'Delete Product',
          style: AppTextStyles.appBarText,
        ),
        backgroundColor: AppColors.primaryBlue,
      ),
      backgroundColor: _themeManager.isDarkMode
          ? _themeManager.backgroundColor
          : AppColors.backgroundWhite,
      body: Padding(
        padding: AppPadding.all16,
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Product Name',
              style: TextStyle(
                fontSize: 24,
                color: _themeManager.primaryTextColor,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 200,
              height: 200,
              child: Placeholder(
                color: _themeManager.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[400]!,
              ),
            ),
            Text(
              'ID: 00123',
              style: TextStyle(color: _themeManager.primaryTextColor),
            ),
            SizedBox(height: 20),
            Text(
              'Current Stock: 100',
              style: TextStyle(
                fontSize: 20,
                color: _themeManager.primaryTextColor,
              ),
            ),
            TextField(
              controller: deleteAmountController,
              decoration: InputDecoration(
                labelText: 'Amount to be deleted',
                labelStyle: TextStyle(
                  color: _themeManager.isDarkMode
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: _themeManager.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[400]!,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              style: TextStyle(color: _themeManager.primaryTextColor),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 75),
            Text(
              'Remaining Stock: 85',
              style: TextStyle(
                fontSize: 20,
                color: _themeManager.primaryTextColor,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deleteRed,
              ),
              onPressed: () {},
              label: Text('Delete', style: AppTextStyles.smallButtonWhiteText),
              icon: Icon(Icons.delete),
            )
          ],
        ),
      ),
    );
  }
}
