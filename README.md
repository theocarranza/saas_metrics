# SaaS Metrics

A Flutter application for modeling and visualizing SaaS financial metrics, strictly adhering to Clean Architecture principles.

## Features

### 1. Financial Modeling (`lib/features/financial_modeling`)
A core engine to generate 12-month financial projections based on customizable scenarios.
- **SaaS Metrics**: MRR, Churn, Active Customers, LTV, CAC.
- **P&L**: Revenue, COGS, OpEx, EBITDA.
- **Cash Flow**: Operating, Investing, Financing.
- **Unit Economics**: Payback Period, Magic Number.

## Architecture
This project follows a strict **Clean Architecture** pattern with **Feature-First** organization.

```text
lib/
└── features/
    └── <feature_name>/
        ├── domain/       # Pure business logic (Entities, UseCases, Repository Contracts)
        ├── data/         # Data implementations (Models, Datasources, Repository Impl)
        └── presentation/ # UI and State Management (Widgets, Pages, Providers)
```

## Rules & Standards
- **Architecture**: Enforced by `.agent/rules/clean-architecture.md`
- **Git**: Enforced by `.agent/rules/git-style-guide.md`
- **Dart**: Enforced by `.agent/rules/dart-style-guide.md`

## Getting Started

1.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Run tests**:
    ```bash
    flutter test
    ```
