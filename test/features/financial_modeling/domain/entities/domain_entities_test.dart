import 'package:flutter_test/flutter_test.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/cash_flow.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/financial_scenario.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/income_statement.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/monthly_financial_record.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/saas_metrics.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/unit_economics.dart';

void main() {
  group('Domain Entities Tests', () {
    test('SaaSMetrics equality', () {
      final metric1 = SaaSMetrics.empty();
      final metric2 = SaaSMetrics.empty();
      expect(metric1, equals(metric2));
    });

    test('IncomeStatement equality', () {
      final statement1 = IncomeStatement.empty();
      final statement2 = IncomeStatement.empty();
      expect(statement1, equals(statement2));
    });

    test('CashFlow equality', () {
      final cashflow1 = CashFlow.empty();
      final cashflow2 = CashFlow.empty();
      expect(cashflow1, equals(cashflow2));
    });

    test('UnitEconomics equality', () {
      final unit1 = UnitEconomics.empty();
      final unit2 = UnitEconomics.empty();
      expect(unit1, equals(unit2));
    });

    test('MonthlyFinancialRecord equality', () {
      final date = DateTime(2023, 1, 1);
      final record1 = MonthlyFinancialRecord(
        date: date,
        saasMetrics: SaaSMetrics.empty(),
        incomeStatement: IncomeStatement.empty(),
        cashFlow: CashFlow.empty(),
        unitEconomics: UnitEconomics.empty(),
      );
      final record2 = MonthlyFinancialRecord(
        date: date,
        saasMetrics: SaaSMetrics.empty(),
        incomeStatement: IncomeStatement.empty(),
        cashFlow: CashFlow.empty(),
        unitEconomics: UnitEconomics.empty(),
      );
      expect(record1, equals(record2));
    });

    test('FinancialScenario equality', () {
      final date = DateTime(2023, 1, 1);
      final scenario1 = FinancialScenario(
        id: '1',
        name: 'Scenario A',
        startDate: date,
        parameters: const {'growth': 0.1},
      );
      final scenario2 = FinancialScenario(
        id: '1',
        name: 'Scenario A',
        startDate: date,
        parameters: const {'growth': 0.1},
      );
      expect(scenario1, equals(scenario2));
    });
  });
}
