// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_projections_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'aec472674cea7603ee2559eaeee17ab6a34e0829';

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
