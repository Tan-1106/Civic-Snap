import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report_entity.dart';

class DashboardReportModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final String status;
  final GeoPoint location;
  final String? response;
  final DateTime? respondedAt;

  DashboardReportModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.status,
    required this.location,
    this.response,
    this.respondedAt,
  });

  factory DashboardReportModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DashboardReportModel(
      id: doc.id,
      userId: data['user_id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['image_url'] ?? '',
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'Pending',
      location: data['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      response: data['response'] as String?,
      respondedAt: (data['responded_at'] as Timestamp?)?.toDate(),
    );
  }

  DashboardReportEntity toEntity() {
    return DashboardReportEntity(
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
      response: response,
      respondedAt: respondedAt,
    );
  }
}
