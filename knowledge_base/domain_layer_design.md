# Domain Layer Design: Financial Modeling

This document outlines the proposed Domain Layer structure for the `financial_modeling` feature in the `saas_metrics` project. It is based on the analysis of `python_saas_metrics` and adheres to the project's Clean Architecture rules.

## Core Logical Units
The domain logic is derived from a "Month-by-Month" simulation that calculates four distinct categories of data:
1.  **SaaS Metrics** (MRR, Churn, Active Users)
2.  **Income Statement / P&L** (Revenue, COGS, OpEx, Margins)
3.  **Cash Flow** (Operational, Investing, Financing)
4.  **Unit Economics** (CAC, LTV, Payback)

## 1. Entities (`domain/entities/`)
We will transform the flat data structures from the Python prototype into strongly-typed Data Classes (Entities/Value Objects).

### `MonthlyFinancialRecord` (Aggregate Root)
Represents the complete financial snapshot of the business for a single specific month.
- **Fields**:
  - `date`: `DateTime`
  - `saasMetrics`: `SaaSMetrics`
  - `incomeStatement`: `IncomeStatement`
  - `cashFlow`: `CashFlow`
  - `unitEconomics`: `UnitEconomics`

### `SaaSMetrics` (Value Object)
Corresponds to the "Métricas SaaS" sheet.
- **Fields**:
  - `newMrr`: `double`
  - `expansionMrr`: `double`
  - `churnMrr`: `double`
  - `totalMrr`: `double`
  - `arr`: `double`
  - `activeCustomers`: `int`
  - `churnRate`: `double`
  - `arpa`: `double` (Average Revenue Per Account)

### `IncomeStatement` (Value Object)
Corresponds to the "DRE" (P&L) logic.
- **Fields**:
  - `grossRevenue`: `double` (Sum of all plans)
  - `taxes`: `double`
  - `netRevenue`: `double`
  - `cogs`: `double` (Cost of Goods Sold)
  - `grossProfit`: `double`
  - `opEx`: `double` (Operating Expenses: S&M, R&D, G&A)
  - `ebitda`: `double`
  - `netIncome`: `double`

### `CashFlow` (Value Object)
Corresponds to the "Fluxo de Caixa" sheet.
- **Fields**:
  - `operatingFlow`: `double`
  - `investingFlow`: `double`
  - `financingFlow`: `double`
  - `endingBalance`: `double`

### `UnitEconomics` (Value Object)
Corresponds to the "Unit Economics" sheet.
- **Fields**:
  - `cac`: `double`
  - `ltv`: `double`
  - `ltvCacRatio`: `double`
  - `magicNumber`: `double`
  - `paybackPeriod`: `double` (Months)

### `FinancialScenario` (Entity)
Represents the input configuration for a simulation.
- **Fields**:
  - `id`: `String`
  - `name`: `String`
  - `startDate`: `DateTime`
  - `durationMonths`: `int` (Default: 12)
  - `parameters`: `Map<String, dynamic>` (Growth rates, churn assumptions, costs)

## 2. Repositories (`domain/repositories/`)
Defines the contract for data persistence.

### `FinancialRepository`
- **Methods**:
  - `Future<FinancialScenario> getScenario(String id)`
  - `Future<void> saveScenario(FinancialScenario scenario)`

## 3. Use Cases (`domain/usecases/`)
Encapsulates the business rules for generating projections.

### `GenerateFinancialProjections`
- **Goal**: Implement the mathematical engines from the Python script to project the future state.
- **Input**: `FinancialScenario` (Assumptions & Inputs).
- **Output**: `List<MonthlyFinancialRecord>` (The 12-month projection).
- **Logic**:
  1.  Initialize the timeline.
  2.  Iterate month-by-month.
  3.  Apply SaaS Logic (New MRR = Active Users * ARPA, etc.).
  4.  Apply P&L Logic (Revenue - Costs).
  5.  Calculate Unit Economics based on rolling averages/totals.

## 4. Directory Structure
```text
lib/features/financial_modeling/domain/
├── entities/
│   ├── cash_flow.dart
│   ├── financial_scenario.dart
│   ├── income_statement.dart
│   ├── monthly_financial_record.dart
│   ├── saas_metrics.dart
│   └── unit_economics.dart
├── repositories/
│   └── financial_repository.dart
└── usecases/
    └── generate_financial_projections.dart
```
