import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/monthly_financial_record.dart';

class RevenueChart extends StatelessWidget {
  final List<MonthlyFinancialRecord> records;

  const RevenueChart({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(child: Text('No data to display'));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < records.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'M${index + 1}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: records.asMap().entries.map((e) {
              return FlSpot(
                e.key.toDouble(),
                e.value.incomeStatement.grossRevenue,
              );
            }).toList(),
            isCurved: true,
            color: Colors.blueAccent,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blueAccent.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
