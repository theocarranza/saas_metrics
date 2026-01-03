import 'package:equatable/equatable.dart';

/// Entity representing the input configuration for a financial simulation.
class FinancialScenario extends Equatable {
  final String id;
  final String name;
  final DateTime startDate;
  final int durationMonths;
  final Map<String, dynamic> parameters;

  const FinancialScenario({
    required this.id,
    required this.name,
    required this.startDate,
    this.durationMonths = 12,
    required this.parameters,
  });

  @override
  List<Object> get props => [id, name, startDate, durationMonths, parameters];
}
