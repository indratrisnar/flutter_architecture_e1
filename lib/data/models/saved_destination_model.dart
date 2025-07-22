import 'package:equatable/equatable.dart';

class SavedDestinationModel extends Equatable {
  final int id;
  final String name;
  final String cover;

  const SavedDestinationModel({
    required this.id,
    required this.name,
    required this.cover,
  });

  factory SavedDestinationModel.fromJson(Map<String, dynamic> json) {
    return SavedDestinationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      cover: json['cover'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'cover': cover};
  }

  @override
  List<Object> get props => [id, name, cover];
}
