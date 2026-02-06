import 'package:equatable/equatable.dart';

import 'cash_flow.dart';
import 'income_statement.dart';
import 'saas_metrics.dart';
import 'unit_economics.dart';

/// Aggregate Root representing the complete financial snapshot of the business
/// for a single specific month.
class MonthlyFinancialRecord extends Equatable {
  final DateTime date;
  final SaaSMetrics saasMetrics;
  final IncomeStatement incomeStatement;
  final CashFlow cashFlow;
  final UnitEconomics unitEconomics;

  const MonthlyFinancialRecord({
    required this.date,
    required this.saasMetrics,
    required this.incomeStatement,
    required this.cashFlow,
    required this.unitEconomics,
  });

  @override
  List<Object> get props => [
    date,
    saasMetrics,
    incomeStatement,
    cashFlow,
    unitEconomics,
  ];
}
