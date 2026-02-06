import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saas_metrics/features/auth/data/repositories/auth_repository.dart';
import 'package:saas_metrics/features/auth/domain/entities/auth_token.dart';
import 'package:saas_metrics/features/auth/presentation/providers/auth_provider.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/financial_scenario.dart';
import 'package:saas_metrics/features/financial_modeling/domain/entities/monthly_financial_record.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/providers/financial_projections_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A fake auth repository that returns an immediately-valid token.
class FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthToken?> restoreSession() async {
    return AuthToken(
      value: 'test-token',
      expiry: DateTime.now().add(const Duration(minutes: 10)),
    );
  }

  @override
  Future<AuthToken> login(String email, String password) async {
    return AuthToken(
      value: 'test-token',
      expiry: DateTime.now().add(const Duration(minutes: 10)),
    );
  }

  @override
  Future<void> logout() async {}
}

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('FinancialProjectionsNotifier initial state is empty list', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      ],
    );
    addTearDown(container.dispose);

    // Listen to keep the provider alive
    final sub = container.listen(financialProjectionsProvider, (prev, next) {});
    addTearDown(sub.close);

    // Wait for the async provider to complete
    final result = await container.read(financialProjectionsProvider.future);

    expect(result, isEmpty);
  });

  test('generate updates state with records', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      ],
    );
    addTearDown(container.dispose);

    // Listen to keep the provider alive
    final sub = container.listen(financialProjectionsProvider, (prev, next) {});
    addTearDown(sub.close);

    // Wait for initial state to be ready
    await container.read(financialProjectionsProvider.future);

    final scenario = FinancialScenario(
      id: '1',
      name: 'Test',
      startDate: DateTime(2024),
      parameters: {},
    );

    await container
        .read(financialProjectionsProvider.notifier)
        .generate(scenario);

    final state = container.read(financialProjectionsProvider);
    expect(state.hasValue, true);
    expect(state.value!.length, 12); // Default duration is 12 months
  });
}
