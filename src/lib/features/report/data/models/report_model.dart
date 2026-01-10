import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/features/report/domain/entities/report_entity.dart';

class ReportModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final String status;
  final GeoPoint location;

  ReportModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.status,
    required this.location,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image_url'] ?? '',
      createdAt: (map['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'Pending',
      location: map['location'] as GeoPoint? ?? const GeoPoint(0, 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'created_at': Timestamp.fromDate(createdAt),
      'status': status,
      'location': location,
    };
  }

  ReportEntity toEntity() {
    return ReportEntity(
      id: id,
      userId: userId,
      title: title,
      description: description,
      imageUrl: imageUrl,
      createdAt: createdAt,
      status: status,
      location: Location(
        latitude: location.latitude,
        longitude: location.longitude,
      ),
    );
  }
}
