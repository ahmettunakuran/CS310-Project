import 'package:flutter/material.dart';

class DeleteProductScreen extends StatelessWidget {
  final TextEditingController deleteAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delete Product'), titleTextStyle: TextStyle(color: Color(
          0xFF252533),fontStyle: FontStyle.italic,fontSize: 25.0,fontWeight:  FontWeight.bold, letterSpacing: 0.8,shadows: [Shadow(offset: Offset(2, 2),blurRadius: 4.0,color: Color(0xFFc6c6c6))]),backgroundColor: Color(
          0xffcbccff)
      ,centerTitle: true,),
      backgroundColor: Color(0xfff8f8ff),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text('Product Name', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Container(

              width: 200,
              height: 200,
              child: Placeholder(),
            )
            , // Replace with actual image
            Text('ID: 00123'),
            SizedBox(height: 20),
            Text('Current Stock: 100',style: TextStyle(fontSize: 20),),
            TextField(
              controller: deleteAmountController,
              decoration: InputDecoration(labelText: 'Amount to be deleted'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 75,),
            Text('Remaining Stock: 85',style: TextStyle(fontSize: 20),),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // Add validation and show AlertDialog if needed
              },


              label: Text('Delete', style: TextStyle(color: Colors.black)),
              icon: Icon(Icons.delete),
            )
          ],
        ),
      ),
    );
  }
}
