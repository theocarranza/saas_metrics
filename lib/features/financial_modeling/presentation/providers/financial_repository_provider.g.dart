// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(financialRepository)
final financialRepositoryProvider = FinancialRepositoryProvider._();

final class FinancialRepositoryProvider
    extends
        $FunctionalProvider<
          FinancialRepository,
          FinancialRepository,
          FinancialRepository
        >
    with $Provider<FinancialRepository> {
  FinancialRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financialRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financialRepositoryHash();

  @$internal
  @override
  $ProviderElement<FinancialRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FinancialRepository create(Ref ref) {
    return financialRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinancialRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinancialRepository>(value),
    );
  }
}

String _$financialRepositoryHash() =>
    r'4a205d3eb1f9d7b7b3503ae29c83e0a27862901a';

@ProviderFor(SavedScenarios)
final savedScenariosProvider = SavedScenariosProvider._();

final class SavedScenariosProvider
    extends $AsyncNotifierProvider<SavedScenarios, List<FinancialScenario>> {
  SavedScenariosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedScenariosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedScenariosHash();

  @$internal
  @override
  SavedScenarios create() => SavedScenarios();
}

String _$savedScenariosHash() => r'a39f6d32715678a76123369e81214449dbb569cc';

abstract class _$SavedScenarios
    extends $AsyncNotifier<List<FinancialScenario>> {
  FutureOr<List<FinancialScenario>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<FinancialScenario>>,
              List<FinancialScenario>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<FinancialScenario>>,
                List<FinancialScenario>
              >,
              AsyncValue<List<FinancialScenario>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
