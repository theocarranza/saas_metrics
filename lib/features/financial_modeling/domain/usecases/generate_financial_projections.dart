import '../entities/cash_flow.dart';
import '../entities/financial_scenario.dart';
import '../entities/income_statement.dart';
import '../entities/monthly_financial_record.dart';
import '../entities/saas_metrics.dart';
import '../entities/unit_economics.dart';

/// Use Case for generating financial projections based on a scenario.
class GenerateFinancialProjections {
  Future<List<MonthlyFinancialRecord>> call(FinancialScenario scenario) async {
    final records = <MonthlyFinancialRecord>[];

    // Extract parameters with defaults
    final startingCustomers =
        (scenario.parameters['starting_customers'] as num?)?.toInt() ?? 0;
    final newCustomersMonthly =
        (scenario.parameters['new_customers_monthly'] as num?)?.toInt() ?? 0;
    final arpa = (scenario.parameters['arpa'] as num?)?.toDouble() ?? 0.0;
    final churnRate =
        (scenario.parameters['churn_rate'] as num?)?.toDouble() ?? 0.0;
    // final expansionRate = (scenario.parameters['expansion_rate'] as num?)?.toDouble() ?? 0.0;

    // P&L Parameters
    final costPerUser =
        (scenario.parameters['cost_per_user'] as num?)?.toDouble() ?? 0.0;
    final fixedCogs =
        (scenario.parameters['fixed_cogs'] as num?)?.toDouble() ?? 0.0;
    final fixedOpex =
        (scenario.parameters['fixed_opex'] as num?)?.toDouble() ?? 0.0;
    final taxRate =
        (scenario.parameters['tax_rate'] as num?)?.toDouble() ?? 0.0;

    // Unit Eco & Cash Flow Parameters
    final marketingSpend =
        (scenario.parameters['marketing_spend'] as num?)?.toDouble() ?? 0.0;
    final startingCash =
        (scenario.parameters['starting_cash'] as num?)?.toDouble() ?? 0.0;
    final capex = (scenario.parameters['capex'] as num?)?.toDouble() ?? 0.0;

    int currentActiveCustomers = startingCustomers;
    double currentCashBalance = startingCash;

    for (int i = 0; i < scenario.durationMonths; i++) {
      final date = DateTime(
        scenario.startDate.year,
        scenario.startDate.month + i,
        1,
      );

      // Churn (based on start of month count)
      final churnedCustomers = (currentActiveCustomers * churnRate).round();
      final churnMrr = churnedCustomers * arpa;

      // New Business
      final newCustomers = newCustomersMonthly;
      final newMrr = newCustomers * arpa;

      // Update Active Customers
      currentActiveCustomers =
          currentActiveCustomers + newCustomers - churnedCustomers;

      // Total MRR (Simple calculation: Active * ARPA)
      final totalMrr = currentActiveCustomers * arpa;
      final arr = totalMrr * 12;

      final saasMetrics = SaaSMetrics(
        newMrr: newMrr,
        expansionMrr: 0.0,
        contractionMrr: 0.0,
        churnMrr: churnMrr,
        totalMrr: totalMrr,
        arr: arr,
        activeCustomers: currentActiveCustomers,
        churnRate: churnRate,
        arpa: arpa,
      );

      // Income Statement (P&L) Calculation
      final grossRevenue = totalMrr;
      final taxes = grossRevenue * taxRate;
      final netRevenue = grossRevenue - taxes;

      final cogs = fixedCogs + (currentActiveCustomers * costPerUser);
      final grossProfit = netRevenue - cogs;

      final opEx = fixedOpex + marketingSpend;
      final ebitda = grossProfit - opEx;
      final netIncome = ebitda;

      final incomeStatement = IncomeStatement(
        grossRevenue: grossRevenue,
        taxes: taxes,
        netRevenue: netRevenue,
        cogs: cogs,
        grossProfit: grossProfit,
        opEx: opEx,
        ebitda: ebitda,
        netIncome: netIncome,
      );

      // Cash Flow Logic
      final operatingFlow = netIncome;
      final investingFlow = -capex;
      final financingFlow = 0.0;
      final netCashFlow = operatingFlow + investingFlow + financingFlow;

      currentCashBalance += netCashFlow;

      final cashFlow = CashFlow(
        operatingFlow: operatingFlow,
        investingFlow: investingFlow,
        financingFlow: financingFlow,
        endingBalance: currentCashBalance,
      );

      // Unit Economics Logic
      final cac = newCustomers > 0 ? marketingSpend / newCustomers : 0.0;
      final ltv = churnRate > 0 ? arpa / churnRate : 0.0;
      final ltvCacRatio = cac > 0 ? ltv / cac : 0.0;

      final grossMarginRatio = netRevenue > 0 ? grossProfit / netRevenue : 0.0;
      final paybackPeriod = (arpa * grossMarginRatio) > 0
          ? cac / (arpa * grossMarginRatio)
          : 0.0;
      final magicNumber = 0.0;

      final unitEconomics = UnitEconomics(
        cac: cac,
        ltv: ltv,
        ltvCacRatio: ltvCacRatio,
        magicNumber: magicNumber,
        paybackPeriod: paybackPeriod,
      );

      records.add(
        MonthlyFinancialRecord(
          date: date,
          saasMetrics: saasMetrics,
          incomeStatement: incomeStatement,
          cashFlow: cashFlow,
          unitEconomics: unitEconomics,
        ),
      );
    }

    return records;
  }
}
