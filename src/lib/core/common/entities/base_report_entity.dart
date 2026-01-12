class BaseReportEntity {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final String status;
  final ReportLocation location;
  final String? response;
  final DateTime? respondedAt;

  const BaseReportEntity({
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
}

class ReportLocation {
  final double latitude;
  final double longitude;

  const ReportLocation({
    required this.latitude,
    required this.longitude,
  });
}

