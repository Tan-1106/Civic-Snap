enum ReportStatus {
  pending('Pending'),
  inProgress('In Progress'),
  resolved('Resolved');

  final String displayName;
  const ReportStatus(this.displayName);
}