import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_e1/data/models/best_time_to_visit_model.dart';
import 'package:flutter_architecture_e1/data/models/location_model.dart';

class DestinationModel extends Equatable {
  final int id;
  final String name;
  final LocationModel location;
  final String cover;
  final double rating;

  final List<String>? category;
  final String? description;
  final int? popularScore;
  final List<String>? gallery;
  final int? reviewCount;
  final BestTimeToVisitModel? bestTimeToVisit;
  final List<String>? activities;
  final List<String>? imageSources;

  const DestinationModel({
    required this.id,
    required this.name,
    required this.location,
    required this.cover,
    required this.rating,
    this.category,
    this.description,
    this.popularScore,
    this.gallery,
    this.reviewCount,
    this.bestTimeToVisit,
    this.activities,
    this.imageSources,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      location: LocationModel.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      cover: json['cover'] as String,
      rating: (json['rating'] as num).toDouble(),
      category: (json['category'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      popularScore: json['popular_score'] as int?,
      gallery: (json['gallery'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      reviewCount: json['review_count'] as int?,
      bestTimeToVisit: json['best_time_to_visit'] != null
          ? BestTimeToVisitModel.fromJson(
              json['best_time_to_visit'] as Map<String, dynamic>,
            )
          : null,
      activities: (json['activities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageSources: (json['image_sources'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location.toJson(),
      'cover': cover,
      'rating': rating,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (popularScore != null) 'popular_score': popularScore,
      if (gallery != null) 'gallery': gallery,
      if (reviewCount != null) 'review_count': reviewCount,
      if (bestTimeToVisit != null)
        'best_time_to_visit': bestTimeToVisit!.toJson(),
      if (activities != null) 'activities': activities,
      if (imageSources != null) 'image_sources': imageSources,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    cover,
    rating,
    category,
    description,
    popularScore,
    gallery,
    reviewCount,
    bestTimeToVisit,
    activities,
    imageSources,
  ];
}
