import 'package:flutter/material.dart';
import 'package:src/features/dashboard/presentation/widgets/status_chip.dart';
import 'package:src/features/dashboard/domain/entities/dashboard_report.dart';

class ReportItem extends StatelessWidget {
  final DashboardReportEntity report;
  final VoidCallback onSeeMore;

  const ReportItem({
    super.key,
    required this.report,
    required this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Expanded(
              child: Text(
                report.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            StatusChip(
              status: report.status,
            ),
          ],
        ),
        Text(
          report.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: onSeeMore,
            child: Row
              (
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'See more',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Colors.blue,
                ),
              ],
            ),
          )
        ),
        const Divider(),
      ],
    );
  }
}
