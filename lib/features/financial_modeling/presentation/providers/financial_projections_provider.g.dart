// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_projections_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SimulationProgress)
final simulationProgressProvider = SimulationProgressProvider._();

final class SimulationProgressProvider
    extends $NotifierProvider<SimulationProgress, double> {
  SimulationProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'simulationProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$simulationProgressHash();

  @$internal
  @override
  SimulationProgress create() => SimulationProgress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$simulationProgressHash() =>
    r'a3890480f7cdfef04b5b08cc7fdf304e66cedbc9';

abstract class _$SimulationProgress extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(FinancialProjectionsNotifier)
final financialProjectionsProvider = FinancialProjectionsNotifierProvider._();

final class FinancialProjectionsNotifierProvider
    extends
        $AsyncNotifierProvider<
          FinancialProjectionsNotifier,
          List<MonthlyFinancialRecord>
        > {
  FinancialProjectionsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financialProjectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financialProjectionsNotifierHash();

  @$internal
  @override
  FinancialProjectionsNotifier create() => FinancialProjectionsNotifier();
}

String _$financialProjectionsNotifierHash() =>
    r'354483916fda6b14a811ffb3ba089c4b3a824b9e';

abstract class _$FinancialProjectionsNotifier
    extends $AsyncNotifier<List<MonthlyFinancialRecord>> {
  FutureOr<List<MonthlyFinancialRecord>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<MonthlyFinancialRecord>>,
              List<MonthlyFinancialRecord>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MonthlyFinancialRecord>>,
                List<MonthlyFinancialRecord>
              >,
              AsyncValue<List<MonthlyFinancialRecord>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
