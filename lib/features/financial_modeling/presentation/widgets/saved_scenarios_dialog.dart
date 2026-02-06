import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/financial_scenario.dart';
import '../providers/financial_projections_provider.dart';
import '../providers/financial_repository_provider.dart';
import 'package:intl/intl.dart';

class SavedScenariosDialog extends ConsumerWidget {
  const SavedScenariosDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenariosAsync = ref.watch(savedScenariosProvider);

    return AlertDialog(
      title: const Text('Saved Simulations'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: scenariosAsync.when(
          data: (scenarios) {
            if (scenarios.isEmpty) {
              return const Center(child: Text('No saved simulations found.'));
            }
            return ListView.separated(
              itemCount: scenarios.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final scenario = scenarios[index];
                return ListTile(
                  title: Text(scenario.name),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(scenario.startDate)} • ${scenario.durationMonths} months',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        color: Colors.green,
                        onPressed: () {
                          _loadScenario(context, ref, scenario);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          ref
                              .read(savedScenariosProvider.notifier)
                              .deleteScenario(scenario.id);
                        },
                      ),
                    ],
                  ),
                  onTap: () => _loadScenario(context, ref, scenario),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  void _loadScenario(
    BuildContext context,
    WidgetRef ref,
    FinancialScenario scenario,
  ) {
    Navigator.of(context).pop();
    ref.read(financialProjectionsProvider.notifier).generate(scenario);
  }
}
