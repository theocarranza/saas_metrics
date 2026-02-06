# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- **Navigation**: 
  - Migrated entire application to `go_router` for declarative navigation.
  - Implemented `RouterListenable` to synchronize router with `authProvider` state, ensuring stable routing on authentication changes.
  - Refactored routes: Login is now the root path (`/`), and Onboarding is available at `/onboarding`.
- **Dashboard**:
  - Implemented manual adaptive layout with `NavigationRail` for desktop/tablet views.
  - Polished the Sign Out button in the `NavigationRail` with expanded text support and refined alignment.

### Fixed
- **Navigation**: Fixed Sign Out routing to consistently redirect to the Login screen instead of Onboarding.
- **Onboarding**: Fixed "Skip" button to correctly route to the Login page.

### Removed
- **Dashboard**: Removed non-functional "Settings" and "Simulation" buttons to focus on core metrics.
- **Financial Modeling**:
  - Implemented Domain Entities: `SaaSMetrics`, `IncomeStatement`, `CashFlow`, `UnitEconomics`, `MonthlyFinancialRecord`, `FinancialScenario`.
  - Implemented Core Logic (Math Engine) in `GenerateFinancialProjections` use case.
  - Added comprehensive Unit Tests (TDD) for all entities and logic engines.
- **Presentation Layer**:
  - Added `DashboardPage`, `KPICard`, and `RevenueChart`.
  - Implemented `FinancialProjectionsNotifier` using Riverpod 2.0 (Generator).
  - Added robust Automated Widget and Provider Tests.
  - **UI Refinements**: Added Floating Action Button and Center Button for simulation control.
- **Documentation**:
  - Added `domain_layer_design.md` to Knowledge Base.
  - Updated `README.md` with project overview and architecture.
- **Project Infrastructure**:
  - Initialized Git repository.
  - Defined Agent Rules for Clean Architecture, Git, and Dart styles (`.agent/rules/`).
  - Defined Agent Workflows for feature development and commits (`.agent/workflows/`).
  - Created Knowledge Base with Domain Layer Design (`knowledge_base/domain_layer_design.md`).
