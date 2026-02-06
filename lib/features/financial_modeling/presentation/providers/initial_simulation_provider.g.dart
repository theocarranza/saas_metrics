// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initial_simulation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InitialSimulation)
final initialSimulationProvider = InitialSimulationProvider._();

final class InitialSimulationProvider
    extends $AsyncNotifierProvider<InitialSimulation, bool> {
  InitialSimulationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialSimulationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialSimulationHash();

  @$internal
  @override
  InitialSimulation create() => InitialSimulation();
}

String _$initialSimulationHash() => r'4e6dd18efbf685d138ef4d3812fcbfbbd855cee5';

abstract class _$InitialSimulation extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
