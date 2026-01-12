import 'package:flutter/material.dart';
import 'package:src/core/common/enums/report_status.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({
    super.key,
    required this.status,
  });

  Color _getStatusColor(String status) {
    if (status == ReportStatus.pending.displayName) {
      return Colors.red;
    } else if (status == ReportStatus.inProgress.displayName) {
      return Colors.orange;
    } else if (status == ReportStatus.resolved.displayName) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}