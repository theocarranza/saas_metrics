import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/pages/dashboard_page_widget.dart';

void main() {
  testWidgets('DashboardPageWidget has AdaptiveScaffold', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPageWidget()));
    expect(find.byType(AdaptiveScaffold), findsOneWidget);
  });

  testWidgets('DashboardPageWidget shows correct destinations', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPageWidget()));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Run Simulation'), findsOneWidget);
    expect(find.text('Exit'), findsOneWidget);
  });

  testWidgets('DashboardPageWidget handles Run Simulation correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPageWidget()));

    // Tap Run Simulation
    await tester.tap(find.text('Run Simulation'));
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.text('Simulation running...'), findsOneWidget);

    // Close dialog
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Verify dialog closed
    expect(find.text('Simulation running...'), findsNothing);

    // Verify state update (Revenue Chart should appear)
    expect(find.text('Revenue Chart'), findsOneWidget);
  });

  testWidgets('DashboardPageWidget handles Exit correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPageWidget()));

    // Tap Exit
    await tester.tap(find.text('Exit'));
    await tester.pump(); // Allow SnackBar animation to start

    // Verify SnackBar appears
    expect(find.text('Exiting...'), findsOneWidget);
  });

  testWidgets('DashboardPageWidget shows Empty State initially', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPageWidget()));

    expect(find.text('Empty State'), findsOneWidget);
    expect(find.text('Revenue Chart'), findsNothing);
  });
}
