import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/pages/dashboard_page.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/widgets/kpi_card.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/widgets/revenue_chart.dart';

void main() {
  testWidgets('DashboardPage renders initial state and button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DashboardPage())),
    );

    expect(find.text('SaaS Financial Dashboard'), findsOneWidget);
    expect(
      find.byIcon(Icons.play_arrow),
      findsNWidgets(2),
    ); // FAB and Center Button
    expect(find.text('No projections generated yet.'), findsOneWidget);
  });

  testWidgets('DashboardPage renders data when simulation is run', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DashboardPage())),
    );

    // Tap play button (FAB)
    await tester.tap(
      find.widgetWithIcon(FloatingActionButton, Icons.play_arrow),
    );
    await tester.pump();

    // Wait for async operation
    await tester.pumpAndSettle();

    expect(find.text('Key Metrics (Month 12)'), findsOneWidget);
    expect(
      find.byType(KPICard),
      findsNWidgets(4),
    ); // MRR, Users, Gross Profit, Cash Balance
    expect(find.byType(RevenueChart), findsOneWidget);
  });
}
