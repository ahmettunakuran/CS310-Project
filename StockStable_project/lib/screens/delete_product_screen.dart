import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../utils/app_padding.dart';
import '../utils/theme_manager.dart';
import '../services/product_service.dart';

class DeleteProductScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final int currentStock;
  final String? photoUrl;

  const DeleteProductScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.currentStock,
    this.photoUrl,
  });

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

  Future<void> _handleDelete() async {
    try {
      await deleteProduct(
        productId: widget.productId,
        productName: widget.productName,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
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
            const SizedBox(height: 20),
            Text(
              widget.productName,
              style: TextStyle(
                fontSize: 24,
                color: _themeManager.primaryTextColor,
              ),
            ),
            const SizedBox(height: 10),
            if (widget.photoUrl != null)
              Image.network(
                widget.photoUrl!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              SizedBox(
                width: 200,
                height: 200,
                child: Placeholder(
                  color: _themeManager.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[400]!,
                ),
              ),
            Text(
              'ID: ${widget.productId}',
              style: TextStyle(color: _themeManager.primaryTextColor),
            ),
            const SizedBox(height: 20),
            Text(
              'Current Stock: ${widget.currentStock}',
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
              onPressed: _handleDelete,
              label: const Text('Delete', style: AppTextStyles.smallButtonWhiteText),
              icon: const Icon(Icons.delete),
            )
          ],
        ),
      ),
    );
  }
}
