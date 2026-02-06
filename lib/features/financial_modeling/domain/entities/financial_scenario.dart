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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'durationMonths': durationMonths,
      'parameters': parameters,
    };
  }

  factory FinancialScenario.fromMap(Map<String, dynamic> map) {
    return FinancialScenario(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      startDate: DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
      durationMonths: map['durationMonths']?.toInt() ?? 12,
      parameters: Map<String, dynamic>.from(map['parameters'] ?? {}),
    );
  }

  FinancialScenario copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    int? durationMonths,
    Map<String, dynamic>? parameters,
  }) {
    return FinancialScenario(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      durationMonths: durationMonths ?? this.durationMonths,
      parameters: parameters ?? this.parameters,
    );
  }
}
