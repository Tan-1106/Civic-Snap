// Represents the base entity for a report in the system
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

  @override
  String toString() {
    return 'BaseReportEntity(id: $id, userId: $userId, title: $title, description: $description, imageUrl: $imageUrl, createdAt: $createdAt, status: $status, location: $location, response: $response, respondedAt: $respondedAt)';
  }
}

// Represents the geographical location of a report
class ReportLocation {
  final double latitude;
  final double longitude;

  const ReportLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'ReportLocation(latitude: $latitude, longitude: $longitude)';
  }
}

