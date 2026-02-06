# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- **Financial Modeling**:
  - Implemented Domain Entities: `SaaSMetrics`, `IncomeStatement`, `CashFlow`, `UnitEconomics`, `MonthlyFinancialRecord`, `FinancialScenario`.
  - Implemented Core Logic (Math Engine) in `GenerateFinancialProjections` use case.
  - Added comprehensive Unit Tests (TDD) for all entities and logic engines.
- **Presentation Layer**:
  - Added `DashboardPage`, `KPICard`, and `RevenueChart`.
  - Implemented `FinancialProjectionsNotifier` using Riverpod 2.0 (Generator).
  - Added robust Automated Widget and Provider Tests.
  - **UI Refinements**: Added Floating Action Button and Center Button for simulation control.
  - **M3 Compliance**: Fixed `OnboardingPage` indicators to use `colorScheme` tokens.
- **Documentation**:
  - Added `domain_layer_design.md` to Knowledge Base.
  - Updated `README.md` with project overview and architecture.
- **Project Infrastructure**:
  - Initialized Git repository.
  - Defined Agent Rules for Clean Architecture, Git, and Dart styles (`.agent/rules/`).
  - Defined Agent Workflows for feature development and commits (`.agent/workflows/`).
  - Created Knowledge Base with Domain Layer Design (`knowledge_base/domain_layer_design.md`).
