import 'package:equatable/equatable.dart';

/// Value Object representing the Income Statement (P&L) for a specific period.
class IncomeStatement extends Equatable {
  final double grossRevenue;
  final double taxes;
  final double netRevenue;
  final double cogs;
  final double grossProfit;
  final double opEx;
  final double ebitda;
  final double netIncome;

  const IncomeStatement({
    required this.grossRevenue,
    required this.taxes,
    required this.netRevenue,
    required this.cogs,
    required this.grossProfit,
    required this.opEx,
    required this.ebitda,
    required this.netIncome,
  });

  factory IncomeStatement.empty() {
    return const IncomeStatement(
      grossRevenue: 0,
      taxes: 0,
      netRevenue: 0,
      cogs: 0,
      grossProfit: 0,
      opEx: 0,
      ebitda: 0,
      netIncome: 0,
    );
  }

  @override
  List<Object> get props => [
    grossRevenue,
    taxes,
    netRevenue,
    cogs,
    grossProfit,
    opEx,
    ebitda,
    netIncome,
  ];

  Map<String, dynamic> toMap() {
    return {
      'grossRevenue': grossRevenue,
      'taxes': taxes,
      'netRevenue': netRevenue,
      'cogs': cogs,
      'grossProfit': grossProfit,
      'opEx': opEx,
      'ebitda': ebitda,
      'netIncome': netIncome,
    };
  }

  factory IncomeStatement.fromMap(Map<String, dynamic> map) {
    return IncomeStatement(
      grossRevenue: map['grossRevenue']?.toDouble() ?? 0.0,
      taxes: map['taxes']?.toDouble() ?? 0.0,
      netRevenue: map['netRevenue']?.toDouble() ?? 0.0,
      cogs: map['cogs']?.toDouble() ?? 0.0,
      grossProfit: map['grossProfit']?.toDouble() ?? 0.0,
      opEx: map['opEx']?.toDouble() ?? 0.0,
      ebitda: map['ebitda']?.toDouble() ?? 0.0,
      netIncome: map['netIncome']?.toDouble() ?? 0.0,
    );
  }
}
