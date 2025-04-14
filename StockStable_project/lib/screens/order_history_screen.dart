import 'package:flutter/material.dart';
class OrderHistoryScreen extends StatefulWidget {
  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June','July','August', 'September','October','November','December'];

  String selectedMonth = 'March';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order History'), titleTextStyle: TextStyle(color: Color(
          0xFF252533),fontSize: 25.0,shadows: [Shadow(offset: Offset(2, 2),blurRadius: 4.0,color: Color(0xFFc6c6c6))]),backgroundColor: Color(
          0xffcbccff)
        ),
      backgroundColor: Color(0xfff8f8ff),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.fromLTRB(0,0,30,0),
              child: DropdownButton<String>(
                value: selectedMonth,
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
            SizedBox(height: 16),
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    color: index % 2 == 0 ? Colors.green[200] : Colors.red[200],
                    child: ListTile(
                      title: Text("Date: 12/03/2025\nProduct: product_name\nAmount: 5"),
                      trailing: Icon(Icons.image),
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
