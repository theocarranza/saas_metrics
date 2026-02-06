import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/monthly_financial_record.dart';

import 'dart:math';

enum ChartTimeframe { month, year }

class RevenueChart extends StatelessWidget {
  final List<MonthlyFinancialRecord> records;
  final ChartTimeframe timeframe;
  final MonthlyFinancialRecord? focusedRecord;

  const RevenueChart({
    super.key,
    required this.records,
    this.timeframe = ChartTimeframe.month,
    this.focusedRecord,
    this.onRecordSelected,
  });

  final ValueChanged<MonthlyFinancialRecord>? onRecordSelected;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(child: Text('No data to display'));
    }

    // Determine data points based on timeframe
    List<FlSpot> spots;
    double interval;
    Widget Function(double, TitleMeta) getBottomTitles;

    if (timeframe == ChartTimeframe.month) {
      spots = _generateDailySpots();
      interval = 5; // Show label every 5 days
      getBottomTitles = (value, meta) {
        final day = value.toInt();
        if (day > 0 && day <= 30) {
          return SideTitleWidget(
            meta: meta,
            child: Text(
              '$day',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          );
        }
        return const SizedBox();
      };
    } else {
      spots = _generateMonthlySpots();
      interval = 1;
      getBottomTitles = (value, meta) {
        final index = value.toInt();
        if (index >= 0 && index < records.length) {
          final date = records[index].date;
          final monthName = DateFormat('MMM').format(date);
          return SideTitleWidget(
            meta: meta,
            angle: -0.5,
            child: Text(
              monthName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          );
        }
        return const SizedBox();
      };
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1000,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: interval,
              getTitlesWidget: getBottomTitles,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
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
            spots: spots,
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  Theme.of(context).primaryColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.black87,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final currencyFormat = NumberFormat.compactCurrency(
                  locale: 'pt_BR',
                  symbol: 'R\$',
                  decimalDigits: 1,
                );

                if (timeframe == ChartTimeframe.month) {
                  final dateLabel = 'Day ${touchedSpot.x.toInt()}';
                  final value = NumberFormat.currency(
                    locale: 'pt_BR',
                    symbol: 'R\$',
                    decimalDigits: 0,
                  ).format(touchedSpot.y);

                  return LineTooltipItem(
                    '$dateLabel\n',
                    const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.start,
                    children: [
                      const TextSpan(
                        text: 'Est. Revenue: ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Year View - Rich Tooltip
                  final index = touchedSpot.x.toInt();
                  if (index < 0 || index >= records.length) return null;

                  final record = records[index];
                  final dateLabel = DateFormat('MMM yyyy').format(record.date);

                  return LineTooltipItem(
                    '$dateLabel\n',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.start,
                    children: [
                      // Revenue
                      const TextSpan(
                        text: 'Gross Revenue: ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${currencyFormat.format(record.incomeStatement.grossRevenue)}\n',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // MRR
                      const TextSpan(
                        text: 'Total MRR: ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${currencyFormat.format(record.saasMetrics.totalMrr)}\n',
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Net Income
                      const TextSpan(
                        text: 'Net Income: ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${currencyFormat.format(record.incomeStatement.netIncome)}\n',
                        style: TextStyle(
                          color: record.incomeStatement.netIncome >= 0
                              ? Colors.green
                              : Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Cash
                      const TextSpan(
                        text: 'Cash: ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: currencyFormat.format(
                          record.cashFlow.endingBalance,
                        ),
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (event is FlTapUpEvent &&
                response != null &&
                response.lineBarSpots != null &&
                response.lineBarSpots!.isNotEmpty) {
              final spot = response.lineBarSpots!.first;
              if (timeframe == ChartTimeframe.year) {
                final index = spot.x.toInt();
                if (index >= 0 && index < records.length) {
                  onRecordSelected?.call(records[index]);
                }
              }
            }
          },
        ),
      ),
    );
  }

  List<FlSpot> _generateMonthlySpots() {
    return records.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.incomeStatement.grossRevenue);
    }).toList();
  }

  List<FlSpot> _generateDailySpots() {
    if (records.isEmpty) return [];

    final targetRecord = focusedRecord ?? records.last;

    // Find previous record relative to targetRecord
    final targetIndex = records.indexOf(targetRecord);
    final previousRevenue = (targetIndex > 0)
        ? records[targetIndex - 1].incomeStatement.grossRevenue
        : targetRecord.incomeStatement.grossRevenue * 0.8; // Fallback estimate

    final targetRevenue = targetRecord.incomeStatement.grossRevenue;

    final random = Random(42); // Fixed seed for consistent "random" look
    final spots = <FlSpot>[];

    // Simulate 30 days
    for (int i = 1; i <= 30; i++) {
      // Linear progress
      final progress = i / 30.0;
      final baseValue =
          previousRevenue + (targetRevenue - previousRevenue) * progress;

      // Add noise (fluctuation), reduced near the end to match target closer
      final noiseFactor =
          1.0 - (progress * 0.8); // Reduce noise as we get closer to end
      final noise =
          (random.nextDouble() - 0.5) *
          (targetRevenue - previousRevenue) *
          0.2 *
          noiseFactor;

      spots.add(FlSpot(i.toDouble(), baseValue + noise));
    }

    return spots;
  }
}
