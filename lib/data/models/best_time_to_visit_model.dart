import 'package:equatable/equatable.dart';

class BestTimeToVisitModel extends Equatable {
  final String season;
  final List<String> months;
  final String notes;

  const BestTimeToVisitModel({
    required this.season,
    required this.months,
    required this.notes,
  });

  factory BestTimeToVisitModel.fromJson(Map<String, dynamic> json) {
    return BestTimeToVisitModel(
      season: json['season'] as String,
      months: List<String>.from(json['months'] as List<dynamic>),
      notes: json['notes'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'season': season, 'months': months, 'notes': notes};
  }

  @override
  List<Object> get props => [season, months, notes];
}
