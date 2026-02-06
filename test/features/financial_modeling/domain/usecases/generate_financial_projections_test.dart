import 'package:flutter_test/flutter_test.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/financial_scenario.dart';
import 'package:saas_metrics/features/financial_modeling/domain/usecases/generate_financial_projections.dart';

void main() {
  late GenerateFinancialProjections useCase;

  setUp(() {
    useCase = GenerateFinancialProjections();
  });

  group('GenerateFinancialProjections - SaaS Metrics', () {
    test('Simple Growth Model: Linear customer growth with 0 churn', () async {
      // Arrange
      final startDate = DateTime(2024, 1, 1);
      final scenario = FinancialScenario(
        id: '1',
        name: 'Simple Growth',
        startDate: startDate,
        durationMonths: 3,
        parameters: const {
          'starting_customers': 10,
          'new_customers_monthly': 2,
          'arpa': 100.0,
          'churn_rate': 0.0,
          'expansion_rate': 0.0,
        },
      );

      // Act
      final result = await useCase(scenario);

      // Assert
      expect(result.length, 3);

      // Month 1
      // Start: 10. New: 2. End: 12.
      // New MRR: 2 * 100 = 200.
      // Total MRR: 12 * 100 = 1200.
      expect(result[0].saasMetrics.activeCustomers, 12);
      expect(result[0].saasMetrics.newMrr, 200.0);
      expect(result[0].saasMetrics.totalMrr, 1200.0);
      expect(result[0].saasMetrics.churnMrr, 0.0);

      // Month 2
      // Start: 12. New: 2. End: 14.
      // New MRR: 2 * 100 = 200.
      // Total MRR: 14 * 100 = 1400.
      expect(result[1].saasMetrics.activeCustomers, 14);
      expect(result[1].saasMetrics.totalMrr, 1400.0);

      // Month 3
      // Start: 14. New: 2. End: 16.
      expect(result[2].saasMetrics.activeCustomers, 16);
      expect(result[2].saasMetrics.totalMrr, 1600.0);
    });

    test(
      'P&L Calculation: Verifies Revenue, COGS, OpEx, and Net Income',
      () async {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final scenario = FinancialScenario(
          id: '2',
          name: 'P&L Test',
          startDate: startDate,
          durationMonths: 1,
          parameters: const {
            'starting_customers': 10,
            'new_customers_monthly': 0,
            'arpa': 100.0,
            'churn_rate': 0.0,
            'cost_per_user': 10.0,
            'fixed_cogs': 50.0,
            'fixed_opex': 200.0,
            'tax_rate': 0.10, // 10% sales tax
          },
        );

        // Act
        final result = await useCase(scenario);

        // Assert
        final income = result[0].incomeStatement;

        // Revenue: 10 * 100 = 1000
        expect(income.grossRevenue, 1000.0);

        // Taxes (Sales): 1000 * 0.1 = 100
        expect(income.taxes, 100.0);

        // Net Revenue: 1000 - 100 = 900
        expect(income.netRevenue, 900.0);

        // COGS: (10 * 10) + 50 = 150
        expect(income.cogs, 150.0);

        // Gross Profit: 900 - 150 = 750
        expect(income.grossProfit, 750.0);

        // OpEx: 200
        expect(income.opEx, 200.0);

        // EBITDA: 750 - 200 = 550
        expect(income.ebitda, 550.0);

        // Net Income: Assuming no further deductions for this test
        expect(income.netIncome, 550.0);
      },
    );

    test(
      'Unit Economics & Cash Flow: Verifies CAC, LTV, Payback and Cash Balance',
      () async {
        // Arrange
        final startDate = DateTime(2024, 1, 1);
        final scenario = FinancialScenario(
          id: '3',
          name: 'Unit Eco Test',
          startDate: startDate,
          durationMonths: 1,
          parameters: const {
            'starting_customers': 10,
            'new_customers_monthly': 2,
            'marketing_spend': 200.0,
            'arpa': 100.0,
            'churn_rate': 0.10, // 10%
            'cost_per_user': 20.0,
            'starting_cash': 1000.0,
            'capex': 50.0,
          },
        );

        // Act
        final result = await useCase(scenario);

        // Month 1
        final unitEco = result[0].unitEconomics;
        final cashFlow = result[0].cashFlow;

        // CAC: 200 / 2 = 100.0
        expect(unitEco.cac, 100.0);

        // LTV: 100 / 0.10 = 1000.0
        expect(unitEco.ltv, 1000.0);

        // LTV/CAC: 1000 / 100 = 10.0
        expect(unitEco.ltvCacRatio, 10.0);

        // Payback: CAC / (ARPA * GM)
        // Active: 10 + 2 - 1 = 11. Revenue: 1100. COGS: 220. GP: 880. GM%: 0.8.
        // Payback: 100 / (100 * 0.8) = 1.25
        expect(unitEco.paybackPeriod, 1.25);

        // Cash Flow
        // EBITDA: 880 - 200 = 680.
        // Operating: 680. Investing: -50.
        // Net: 630. Balance: 1000 + 630 = 1630.
        expect(cashFlow.endingBalance, 1630.0);
      },
    );
  });
}
