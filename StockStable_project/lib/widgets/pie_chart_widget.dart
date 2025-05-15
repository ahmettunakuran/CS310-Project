import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/product.dart';

class PieChartWidget extends StatelessWidget {
  final Stream<List<Product>> productsStream;
  const PieChartWidget({super.key, required this.productsStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: productsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final products = snapshot.data!;
        if (products.isEmpty) {
          return const Center(child: Text('No products in stock.'));
        }
        // Kategorilere göre toplam miktarları hesapla
        final Map<String, int> categoryTotals = {};
        for (var product in products) {
          categoryTotals[product.category] =
              (categoryTotals[product.category] ?? 0) + product.amount;
        }
        final total = categoryTotals.values.fold(0, (a, b) => a + b);
        final List<PieChartSectionData> sections = [];
        final colors = [
          Colors.blue,
          Colors.red,
          Colors.green,
          Colors.orange,
          Colors.purple,
          Colors.teal,
          Colors.brown,
          Colors.pink,
        ];
        int colorIndex = 0;
        categoryTotals.forEach((category, amount) {
          final percent = total == 0 ? 0.0 : amount / total;
          sections.add(PieChartSectionData(
            color: colors[colorIndex % colors.length],
            value: percent * 100,
            title: '${(percent * 100).toStringAsFixed(1)}%',
            radius: 60,
            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ));
          colorIndex++;
        });
        return Column(
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: categoryTotals.keys.map((category) {
                final idx = categoryTotals.keys.toList().indexOf(category);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 12, height: 12, color: colors[idx % colors.length]),
                    const SizedBox(width: 4),
                    Text(category, style: const TextStyle(fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
} 