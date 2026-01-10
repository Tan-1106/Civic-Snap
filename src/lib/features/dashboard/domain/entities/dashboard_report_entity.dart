class DashboardReportEntity {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final String status;
  final Location location;

  const DashboardReportEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.status,
    required this.location,
  });
}

class Location {
  final double latitude;
  final double longitude;

  const Location({required this.latitude, required this.longitude});
}