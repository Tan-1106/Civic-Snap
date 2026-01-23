import 'package:src/core/common/entities/base_report_entity.dart';

class DashboardReportEntity {
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

  const DashboardReportEntity({
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

  factory DashboardReportEntity.fromBaseReport(BaseReportEntity base) {
    return DashboardReportEntity(
      id: base.id,
      userId: base.userId,
      title: base.title,
      description: base.description,
      imageUrl: base.imageUrl,
      createdAt: base.createdAt,
      status: base.status,
      location: Location(
        latitude: base.location.latitude,
        longitude: base.location.longitude,
      ),
      response: base.response,
      respondedAt: base.respondedAt,
    );
  }

  BaseReportEntity toBaseReport() {
    return BaseReportEntity(
      id: id,
      userId: userId,
      title: title,
      description: description,
      imageUrl: imageUrl,
      createdAt: createdAt,
      status: status,
      location: ReportLocation(
        latitude: location.latitude,
        longitude: location.longitude,
      ),
      response: response,
      respondedAt: respondedAt,
    );
  }
}

class Location {
  final double latitude;
  final double longitude;

  const Location({required this.latitude, required this.longitude});
}