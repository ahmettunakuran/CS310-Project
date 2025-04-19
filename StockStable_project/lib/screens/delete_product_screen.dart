import 'package:flutter/material.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import '../utils/app_padding.dart';

class DeleteProductScreen extends StatelessWidget {
  final TextEditingController deleteAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Product'),
        titleTextStyle: TextStyle(
          color: AppColors.backgroundWhite,
          fontStyle: FontStyle.italic,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
      ),
      backgroundColor: AppColors.backgroundWhite,
      body: Padding(
        padding: AppPadding.all16,
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Product Name', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Container(
              width: 200,
              height: 200,
              child: Placeholder(),
            ),
            Text('ID: 00123'),
            SizedBox(height: 20),
            Text('Current Stock: 100', style: TextStyle(fontSize: 20)),
            TextField(
              controller: deleteAmountController,
              decoration: InputDecoration(labelText: 'Amount to be deleted'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 75),
            Text('Remaining Stock: 85', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deleteRed),
              onPressed: () {},
              label: Text('Delete', style: TextStyle(color: Colors.black)),
              icon: Icon(Icons.delete),
            )
          ],
        ),
      ),
    );
  }
}
