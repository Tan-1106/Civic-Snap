import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final String status;
  final Location location;
  final String? response;
  final DateTime? respondedAt;

  const ReportEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.status,
    required this.location,
    required this.response,
    required this.respondedAt,
  });

  @override
  List<Object?> get props => [id, userId, title, description, imageUrl, createdAt, status, location, response, respondedAt];
}

class Location {
  final double latitude;
  final double longitude;

  const Location({required this.latitude, required this.longitude});
}