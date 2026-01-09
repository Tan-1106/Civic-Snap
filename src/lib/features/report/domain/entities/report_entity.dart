import 'package:equatable/equatable.dart';
import 'package:src/features/report/domain/entities/location_entity.dart';

class ReportEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final String status;
  final LocationEntity location;

  const ReportEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.status,
    required this.location,
  });

  @override
  List<Object?> get props => [id, userId, title, description, imageUrl, createdAt, status, location];
}