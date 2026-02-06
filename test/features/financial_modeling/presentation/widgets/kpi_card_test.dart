import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/widgets/kpi_card.dart';

void main() {
  testWidgets('KPICard renders title and value correctly', (
    WidgetTester tester,
  ) async {
    const title = 'Test Title';
    const value = '12345';
    const icon = Icons.abc;
    const color = Colors.red;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: KPICard(title: title, value: value, icon: icon, color: color),
        ),
      ),
    );

    expect(find.text(title), findsOneWidget);
    expect(find.text(value), findsOneWidget);
    expect(find.byIcon(icon), findsOneWidget);
  });
}
